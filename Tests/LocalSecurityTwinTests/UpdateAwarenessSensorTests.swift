import Foundation
import Testing
@testable import LocalSecurityTwin

struct UpdateAwarenessSensorTests {
    @Test func decoderReadsSOFAFeedShape() throws {
        let data = Data(Self.sampleFeed(productVersion: "15.7.7").utf8)
        let catalog = try SOFAFeedDecoder.decode(data, fetchedAt: Date(timeIntervalSince1970: 1_000))

        #expect(catalog.updateHash == "abc123")
        #expect(catalog.releases.count == 1)
        #expect(catalog.releases.first?.productVersion == "15.7.7")
        #expect(catalog.releases.first?.cveCount == 2)
        #expect(catalog.releases.first?.activelyExploitedCVEs == ["CVE-2026-0002"])
    }

    @Test func currentMacOSCreatesCalmUpdateFinding() throws {
        let sensor = UpdateAwarenessSensor(
            provider: StubUpdateProvider(
                result: .available(
                    Self.catalog(productVersion: "15.7.7"),
                    note: "SOFA-Quellenstand wurde aktualisiert."
                )
            ),
            localVersionProvider: StubLocalVersionProvider(productVersion: "15.7.7")
        )

        let run = sensor.run(in: Self.context)

        let finding = try #require(run.findings.first)
        #expect(run.sensor.id == "update-awareness")
        #expect(finding.source.kind == .updateAwareness)
        #expect(finding.severity == .low)
        #expect(finding.title == "macOS wirkt nach Quellenstand aktuell")
        #expect(finding.userImpact.contains("kein Gesamturteil") || finding.userImpact.contains("nicht, dass der Mac vollständig sicher ist"))
        #expect(run.notes.contains(where: { $0.contains("SOFA-Quellenstand") }))
    }

    @Test func olderMacOSCreatesActionableButBoundedFinding() throws {
        let sensor = UpdateAwarenessSensor(
            provider: StubUpdateProvider(
                result: .available(Self.catalog(productVersion: "15.7.7", activelyExploitedCVEs: ["CVE-2026-0002"]))
            ),
            localVersionProvider: StubLocalVersionProvider(productVersion: "15.6.1")
        )

        let finding = try #require(sensor.run(in: Self.context).findings.first)

        #expect(finding.severity == .high)
        #expect(finding.title == "macOS-Update prüfen")
        #expect(finding.summary.contains("älter als 15.7.7"))
        #expect(finding.nextStep.contains("installiert nichts automatisch"))
        #expect(!finding.summary.localizedCaseInsensitiveContains("angegriffen"))
    }

    @Test func missingSourceCreatesTentativeVisibilityFinding() throws {
        let sensor = UpdateAwarenessSensor(
            provider: StubUpdateProvider(
                result: .unavailable(
                    note: "SOFA-Quelle und lokaler Cache waren nicht verfügbar.",
                    errorMessage: "offline"
                )
            ),
            localVersionProvider: StubLocalVersionProvider(productVersion: "15.6.1")
        )

        let run = sensor.run(in: Self.context)
        let finding = try #require(run.findings.first)

        #expect(finding.id == "update-awareness::source-unavailable")
        #expect(finding.severity == .low)
        #expect(finding.confidence == .tentative)
        #expect(finding.userImpact.contains("kein Sicherheitsalarm"))
        #expect(run.notes.contains(where: { $0.contains("nicht verfügbar") }))
    }

    @Test func defaultCacheProviderDoesNotFetchNetworkWithoutConsent() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let provider = CachedSOFAUpdateProvider(fetcher: FailingIfCalledFetcher(), allowsNetworkFetch: false)

        let result = provider.latestCatalog(
            in: SensorContext(homeDirectoryURL: workspaceURL, now: Date(timeIntervalSince1970: 1_000))
        )

        #expect(result.catalog == nil)
        #expect(result.note?.contains("Netzwerkabruf ist noch nicht aktiviert") == true)
    }

    @Test func cacheProviderUsesLocalCacheWithoutNetwork() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let cacheURL = workspaceURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Application Support", isDirectory: true)
            .appendingPathComponent("Sento Guard", isDirectory: true)
            .appendingPathComponent("sofa-macos-data-feed-cache.json", isDirectory: false)

        try FileManager.default.createDirectory(at: cacheURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data(Self.sampleFeed(productVersion: "15.7.7").utf8).write(to: cacheURL)
        let cacheDate = Date(timeIntervalSince1970: 500)
        try FileManager.default.setAttributes([.modificationDate: cacheDate], ofItemAtPath: cacheURL.path)

        let provider = CachedSOFAUpdateProvider(fetcher: FailingIfCalledFetcher(), allowsNetworkFetch: false)
        let result = provider.latestCatalog(
            in: SensorContext(homeDirectoryURL: workspaceURL, now: Date(timeIntervalSince1970: 1_000))
        )

        #expect(result.catalog?.release(forMajorVersion: 15)?.productVersion == "15.7.7")
        #expect(abs((result.catalog?.fetchedAt.timeIntervalSince1970 ?? 0) - cacheDate.timeIntervalSince1970) < 1)
        #expect(result.note == "Lokaler SOFA-Cache wurde genutzt.")
    }

    @Test func cacheProviderFetchesAndStoresSOFAFeedWhenNetworkIsExplicitlyAllowed() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let provider = CachedSOFAUpdateProvider(
            fetcher: StaticSOFAFetcher(data: Data(Self.sampleFeed(productVersion: "15.7.8").utf8)),
            allowsNetworkFetch: true
        )

        let result = provider.latestCatalog(
            in: SensorContext(homeDirectoryURL: workspaceURL, now: Date(timeIntervalSince1970: 2_000))
        )

        #expect(result.catalog?.release(forMajorVersion: 15)?.productVersion == "15.7.8")
        #expect(result.catalog?.fetchedAt == Date(timeIntervalSince1970: 2_000))
        #expect(result.note == "SOFA-Quellenstand wurde aktualisiert.")

        let cachedData = try Data(contentsOf: Self.cacheURL(in: workspaceURL))
        let cachedCatalog = try SOFAFeedDecoder.decode(cachedData, fetchedAt: Date(timeIntervalSince1970: 3_000))
        #expect(cachedCatalog.release(forMajorVersion: 15)?.productVersion == "15.7.8")
    }

    @Test func cacheProviderFallsBackToLocalCacheWhenExplicitNetworkFetchFails() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let cacheURL = Self.cacheURL(in: workspaceURL)
        try FileManager.default.createDirectory(at: cacheURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data(Self.sampleFeed(productVersion: "15.7.6").utf8).write(to: cacheURL)

        let cacheDate = Date(timeIntervalSince1970: 1_500)
        try FileManager.default.setAttributes([.modificationDate: cacheDate], ofItemAtPath: cacheURL.path)

        let provider = CachedSOFAUpdateProvider(
            fetcher: ThrowingSOFAFetcher(),
            allowsNetworkFetch: true
        )

        let result = provider.latestCatalog(
            in: SensorContext(homeDirectoryURL: workspaceURL, now: Date(timeIntervalSince1970: 2_000))
        )

        #expect(result.catalog?.release(forMajorVersion: 15)?.productVersion == "15.7.6")
        #expect(abs((result.catalog?.fetchedAt.timeIntervalSince1970 ?? 0) - cacheDate.timeIntervalSince1970) < 1)
        #expect(result.note == "Lokaler SOFA-Cache wurde genutzt.")
        #expect(result.errorMessage == nil)
    }

    @Test func livePipelineContainsUpdateAwarenessSensor() {
        let sensorIDs = SensorPipeline.live().sensors.map(\.descriptor.id)

        #expect(sensorIDs.contains("update-awareness"))
    }

    private static let context = SensorContext(
        homeDirectoryURL: URL(fileURLWithPath: "/tmp/test-home", isDirectory: true),
        now: Date(timeIntervalSince1970: 1_000)
    )

    private static func catalog(
        productVersion: String,
        activelyExploitedCVEs: [String] = []
    ) -> SOFAUpdateCatalog {
        SOFAUpdateCatalog(
            updateHash: "abc123",
            fetchedAt: Date(timeIntervalSince1970: 1_000),
            releases: [
                SOFAUpdateRelease(
                    osVersion: "Sequoia 15",
                    productVersion: productVersion,
                    build: "24G90",
                    releaseDate: Date(timeIntervalSince1970: 900),
                    securityInfo: "apple-security-info",
                    cveCount: 2,
                    activelyExploitedCVEs: activelyExploitedCVEs
                ),
            ]
        )
    }

    private static func sampleFeed(productVersion: String) -> String {
        """
        {
          "UpdateHash": "abc123",
          "OSVersions": [
            {
              "OSVersion": "Sequoia 15",
              "Latest": {
                "ProductVersion": "\(productVersion)",
                "Build": "24G90",
                "ReleaseDate": "2026-05-11T00:00:00Z",
                "SecurityInfo": "apple-security-info",
                "CVEs": {
                  "CVE-2026-0001": false,
                  "CVE-2026-0002": true
                },
                "ActivelyExploitedCVEs": ["CVE-2026-0002"]
              }
            }
          ]
        }
        """
    }

    private static func cacheURL(in workspaceURL: URL) -> URL {
        workspaceURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Application Support", isDirectory: true)
            .appendingPathComponent("Sento Guard", isDirectory: true)
            .appendingPathComponent("sofa-macos-data-feed-cache.json", isDirectory: false)
    }
}

private struct StubUpdateProvider: UpdateAwarenessProviding {
    let result: UpdateAwarenessProviderResult

    func latestCatalog(in context: SensorContext) -> UpdateAwarenessProviderResult {
        result
    }
}

private struct StubLocalVersionProvider: LocalOSVersionProviding {
    let productVersion: String

    func localOSVersion() -> LocalOSVersion {
        LocalOSVersion(productVersion: productVersion, buildVersion: "test-build")
    }
}

private struct FailingIfCalledFetcher: SOFADataFetching {
    func fetchSOFAData() throws -> Data {
        Issue.record("Netzwerk-Fetcher sollte ohne Zustimmung nicht aufgerufen werden.")
        return Data()
    }
}

private struct StaticSOFAFetcher: SOFADataFetching {
    let data: Data

    func fetchSOFAData() throws -> Data {
        data
    }
}

private struct ThrowingSOFAFetcher: SOFADataFetching {
    func fetchSOFAData() throws -> Data {
        throw SOFAFetchError.invalidResponse
    }
}
