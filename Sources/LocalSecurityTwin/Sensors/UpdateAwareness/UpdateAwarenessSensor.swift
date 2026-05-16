import Foundation

struct UpdateAwarenessSensor: FindingSensor {
    let descriptor = SensorDescriptor(
        id: "update-awareness",
        title: "macOS-Update-Stand",
        summary: "Vergleicht die lokale macOS-Version mit einem gecachten SOFA-Quellenstand."
    )

    private let provider: any UpdateAwarenessProviding
    private let localVersionProvider: any LocalOSVersionProviding

    init(
        provider: any UpdateAwarenessProviding = CachedSOFAUpdateProvider(),
        localVersionProvider: any LocalOSVersionProviding = ProcessInfoLocalOSVersionProvider()
    ) {
        self.provider = provider
        self.localVersionProvider = localVersionProvider
    }

    func run(in context: SensorContext) -> SensorRun {
        let localVersion = localVersionProvider.localOSVersion()
        let result = provider.latestCatalog(in: context)

        var notes: [String] = []
        if let note = result.note {
            notes.append(note)
        }

        let findings: [Finding]
        if let catalog = result.catalog {
            findings = [makeFinding(localVersion: localVersion, catalog: catalog)]
            notes.append("macOS-Update-Stand mit SOFA-Quelle verglichen: Stand \(Self.sourceDateFormatter.string(from: catalog.fetchedAt)).")
        } else {
            findings = [makeUnavailableFinding(localVersion: localVersion, errorMessage: result.errorMessage)]
            notes.append("macOS-Update-Stand konnte nicht sicher geprüft werden.")
        }

        return SensorRun(
            sensor: descriptor,
            findings: findings,
            notes: notes,
            completedAt: context.now
        )
    }

    private func makeFinding(localVersion: LocalOSVersion, catalog: SOFAUpdateCatalog) -> Finding {
        guard let release = catalog.release(forMajorVersion: localVersion.majorVersion) else {
            return makeUnknownMajorVersionFinding(localVersion: localVersion, catalog: catalog)
        }

        let comparison = SoftwareVersion(localVersion.productVersion)
            .compare(to: SoftwareVersion(release.productVersion))
        let isCurrent = comparison != .orderedAscending
        let activeExploitCount = release.activelyExploitedCVEs.count

        return Finding(
            id: "update-awareness::macos-\(localVersion.majorVersion)",
            title: isCurrent ? "macOS wirkt nach Quellenstand aktuell" : "macOS-Update prüfen",
            source: source,
            severity: isCurrent ? .low : (activeExploitCount > 0 ? .high : .medium),
            confidence: .supported,
            summary: isCurrent
                ? "Die lokale Version \(localVersion.productVersion) ist nach dem letzten SOFA-Stand nicht älter als \(release.productVersion)."
                : "Die lokale Version \(localVersion.productVersion) ist nach dem letzten SOFA-Stand älter als \(release.productVersion).",
            userImpact: isCurrent
                ? "Das ist ein gutes Schutzsignal. Es bedeutet aber nicht, dass der Mac vollständig sicher ist."
                : "Ein neueres macOS-Update kann Sicherheitskorrekturen enthalten. Das heißt nicht, dass dein Mac angegriffen wurde, aber du solltest den Update-Stand bewusst prüfen.",
            nextStep: isCurrent
                ? "Keine schnelle Aktion nötig. Behalte nur im Blick, von wann der Quellenstand ist."
                : "Öffne die macOS-Softwareupdates selbst und prüfe, ob das Update für deinen Mac angeboten wird. Sento Guard installiert nichts automatisch.",
            evidence: updateEvidence(localVersion: localVersion, release: release, catalog: catalog),
            recommendations: [
                FindingRecommendation(
                    id: isCurrent ? "review-update-source" : "open-software-update-guidance",
                    title: isCurrent ? "Quellenstand ansehen" : "Update manuell prüfen",
                    explanation: isCurrent
                        ? "Zeigt dir den letzten bekannten Quellenstand. Die App ändert dabei nichts am System."
                        : "Nutze das als Anleitung, um Softwareupdate selbst in macOS zu prüfen. Die App startet keine Installation.",
                    action: .showGuidance
                ),
            ]
        )
    }

    private func makeUnknownMajorVersionFinding(localVersion: LocalOSVersion, catalog: SOFAUpdateCatalog) -> Finding {
        Finding(
            id: "update-awareness::unknown-major-\(localVersion.majorVersion)",
            title: "macOS-Update-Stand konnte nicht zugeordnet werden",
            source: source,
            severity: .low,
            confidence: .tentative,
            summary: "Der SOFA-Quellenstand enthält keinen passenden Eintrag für macOS \(localVersion.majorVersion).",
            userImpact: "Das ist zuerst eine Sichtgrenze. Es bedeutet nicht automatisch, dass dein Mac veraltet oder unsicher ist.",
            nextStep: "Prüfe später erneut oder vergleiche den macOS-Stand manuell mit den Apple-Sicherheitsupdates.",
            evidence: [
                FindingEvidence(
                    id: "sofa-source",
                    title: "SOFA-Quellenstand",
                    summary: "Quelle geladen am \(Self.sourceDateFormatter.string(from: catalog.fetchedAt)).",
                    detail: "UpdateHash: \(catalog.updateHash)\nBekannte macOS-Hauptversionen: \(catalog.releases.map(\.osVersion).joined(separator: ", "))"
                ),
            ],
            recommendations: [
                FindingRecommendation(
                    id: "review-apple-security-releases",
                    title: "Apple-Sicherheitsupdates manuell vergleichen",
                    explanation: "Nutze das als ruhige Anleitung. Die App nimmt keine Systemänderung vor.",
                    action: .showGuidance
                ),
            ]
        )
    }

    private func makeUnavailableFinding(localVersion: LocalOSVersion, errorMessage: String?) -> Finding {
        Finding(
            id: "update-awareness::source-unavailable",
            title: "Update-Stand gerade nicht sicher prüfbar",
            source: source,
            severity: .low,
            confidence: .tentative,
            summary: "Sento Guard konnte keinen SOFA-Quellenstand laden oder aus dem lokalen Cache lesen.",
            userImpact: "Das ist kein Sicherheitsalarm. Es bedeutet nur, dass die App den aktuellen Update-Stand gerade nicht belegen kann.",
            nextStep: "Prüfe bei Gelegenheit macOS-Softwareupdate direkt in den Systemeinstellungen oder starte die App später erneut.",
            evidence: [
                FindingEvidence(
                    id: "local-version",
                    title: "Lokale macOS-Version",
                    summary: "Lokal sichtbar: macOS \(localVersion.productVersion).",
                    detail: "Produktversion: \(localVersion.productVersion)\nBuild: \(localVersion.buildVersion ?? "nicht gelesen")\nFehler: \(errorMessage ?? "kein Cache und kein Quellenstand verfügbar")"
                ),
            ],
            recommendations: [
                FindingRecommendation(
                    id: "show-update-guidance",
                    title: "Softwareupdate selbst prüfen",
                    explanation: "Zeigt eine Anleitung, damit du den Update-Stand selbst prüfen kannst. Die App ändert nichts.",
                    action: .showGuidance
                ),
            ]
        )
    }

    private func updateEvidence(
        localVersion: LocalOSVersion,
        release: SOFAUpdateRelease,
        catalog: SOFAUpdateCatalog
    ) -> [FindingEvidence] {
        [
            FindingEvidence(
                id: "local-version",
                title: "Lokale macOS-Version",
                summary: "Lokal sichtbar: macOS \(localVersion.productVersion).",
                detail: "Produktversion: \(localVersion.productVersion)\nBuild: \(localVersion.buildVersion ?? "nicht gelesen")"
            ),
            FindingEvidence(
                id: "sofa-latest",
                title: "SOFA-Quellenstand",
                summary: "SOFA nennt für \(release.osVersion) aktuell \(release.productVersion).",
                detail: [
                    "Quelle geladen am: \(Self.sourceDateFormatter.string(from: catalog.fetchedAt))",
                    "UpdateHash: \(catalog.updateHash)",
                    "Build: \(release.build)",
                    "Veröffentlicht: \(release.releaseDateText)",
                    "Security-Info: \(release.securityInfo ?? "nicht angegeben")",
                    "CVEs: \(release.cveCount)",
                    "Aktiv ausgenutzte CVEs: \(release.activelyExploitedCVEs.count)",
                ].joined(separator: "\n")
            ),
        ]
    }

    private var source: FindingSource {
        FindingSource(
            kind: .updateAwareness,
            title: "macOS-Update-Stand",
            detail: "Vergleicht lokale macOS-Version mit einem lokal gecachten SOFA-Quellenstand."
        )
    }

    private static let sourceDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

protocol UpdateAwarenessProviding {
    func latestCatalog(in context: SensorContext) -> UpdateAwarenessProviderResult
}

struct UpdateAwarenessProviderResult: Sendable {
    let catalog: SOFAUpdateCatalog?
    let note: String?
    let errorMessage: String?

    static func available(_ catalog: SOFAUpdateCatalog, note: String? = nil) -> UpdateAwarenessProviderResult {
        UpdateAwarenessProviderResult(catalog: catalog, note: note, errorMessage: nil)
    }

    static func unavailable(note: String? = nil, errorMessage: String? = nil) -> UpdateAwarenessProviderResult {
        UpdateAwarenessProviderResult(catalog: nil, note: note, errorMessage: errorMessage)
    }
}

protocol LocalOSVersionProviding {
    func localOSVersion() -> LocalOSVersion
}

struct LocalOSVersion: Hashable, Sendable {
    let productVersion: String
    let buildVersion: String?

    var majorVersion: Int {
        Int(productVersion.split(separator: ".").first ?? "") ?? 0
    }
}

struct ProcessInfoLocalOSVersionProvider: LocalOSVersionProviding {
    func localOSVersion() -> LocalOSVersion {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return LocalOSVersion(
            productVersion: "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)",
            buildVersion: nil
        )
    }
}

struct SOFAUpdateCatalog: Hashable, Sendable {
    let updateHash: String
    let fetchedAt: Date
    let releases: [SOFAUpdateRelease]

    func release(forMajorVersion majorVersion: Int) -> SOFAUpdateRelease? {
        releases.first { $0.majorVersion == majorVersion }
    }
}

struct SOFAUpdateRelease: Hashable, Sendable {
    let osVersion: String
    let productVersion: String
    let build: String
    let releaseDate: Date?
    let securityInfo: String?
    let cveCount: Int
    let activelyExploitedCVEs: [String]

    var majorVersion: Int {
        Int(productVersion.split(separator: ".").first ?? "") ?? 0
    }

    var releaseDateText: String {
        guard let releaseDate else {
            return "nicht angegeben"
        }

        return ISO8601DateFormatter().string(from: releaseDate)
    }
}

struct CachedSOFAUpdateProvider: UpdateAwarenessProviding {
    private let fetcher: any SOFADataFetching
    private let allowsNetworkFetch: Bool
    private let cacheFileName = "sofa-macos-data-feed-cache.json"

    init(fetcher: any SOFADataFetching = URLSessionSOFADataFetcher(), allowsNetworkFetch: Bool = false) {
        self.fetcher = fetcher
        self.allowsNetworkFetch = allowsNetworkFetch
    }

    func latestCatalog(in context: SensorContext) -> UpdateAwarenessProviderResult {
        let cacheURL = context.homeDirectoryURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Application Support", isDirectory: true)
            .appendingPathComponent("Sento Guard", isDirectory: true)
            .appendingPathComponent(cacheFileName, isDirectory: false)

        guard allowsNetworkFetch else {
            return cachedCatalog(from: cacheURL) ?? .unavailable(
                note: "SOFA-Netzwerkabruf ist noch nicht aktiviert; lokaler Cache war nicht verfügbar.",
                errorMessage: "Kein lokaler SOFA-Cache vorhanden."
            )
        }

        do {
            let data = try fetcher.fetchSOFAData()
            let catalog = try SOFAFeedDecoder.decode(data, fetchedAt: context.now)

            do {
                try FileManager.default.createDirectory(
                    at: cacheURL.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                )
                try data.write(to: cacheURL, options: .atomic)
            } catch {
                return .available(
                    catalog,
                    note: "SOFA-Quellenstand wurde aktualisiert, konnte aber nicht lokal gespeichert werden."
                )
            }

            return .available(
                catalog,
                note: "SOFA-Quellenstand wurde aktualisiert."
            )
        } catch {
            if let cachedResult = cachedCatalog(from: cacheURL) {
                return cachedResult
            } else {
                return .unavailable(
                    note: "SOFA-Quelle und lokaler Cache waren nicht verfügbar.",
                    errorMessage: error.localizedDescription
                )
            }
        }
    }

    private func cachedCatalog(from cacheURL: URL) -> UpdateAwarenessProviderResult? {
        do {
            let cachedData = try Data(contentsOf: cacheURL)
            let attributes = try? FileManager.default.attributesOfItem(atPath: cacheURL.path)
            let fetchedAt = attributes?[.modificationDate] as? Date ?? Date.distantPast

            return .available(
                try SOFAFeedDecoder.decode(cachedData, fetchedAt: fetchedAt),
                note: "Lokaler SOFA-Cache wurde genutzt."
            )
        } catch {
            return nil
        }
    }
}

protocol SOFADataFetching {
    func fetchSOFAData() throws -> Data
}

struct URLSessionSOFADataFetcher: SOFADataFetching {
    func fetchSOFAData() throws -> Data {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "sofafeed.macadmins.io"
        components.path = "/v1/macos_data_feed.json"

        guard let url = components.url else {
            throw SOFAFetchError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 8
        request.setValue("SentoGuard/0.1 local-security-twin", forHTTPHeaderField: "User-Agent")

        let semaphore = DispatchSemaphore(value: 0)
        let resultBox = SOFAFetchResultBox()

        URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                semaphore.signal()
            }

            if let error {
                resultBox.store(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode),
                  let data else {
                resultBox.store(.failure(SOFAFetchError.invalidResponse))
                return
            }

            resultBox.store(.success(data))
        }.resume()

        if semaphore.wait(timeout: .now() + 10) == .timedOut {
            throw SOFAFetchError.timedOut
        }

        return try resultBox.value().get()
    }
}

private final class SOFAFetchResultBox: @unchecked Sendable {
    private let lock = NSLock()
    private var storedResult: Result<Data, Error> = .failure(SOFAFetchError.invalidResponse)

    func store(_ result: Result<Data, Error>) {
        lock.lock()
        storedResult = result
        lock.unlock()
    }

    func value() -> Result<Data, Error> {
        lock.lock()
        defer {
            lock.unlock()
        }

        return storedResult
    }
}

enum SOFAFetchError: LocalizedError {
    case invalidResponse
    case timedOut

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "SOFA hat keine verwendbare Antwort geliefert."
        case .timedOut:
            return "SOFA hat nicht rechtzeitig geantwortet."
        }
    }
}

enum SOFAFeedDecoder {
    static func decode(_ data: Data, fetchedAt: Date) throws -> SOFAUpdateCatalog {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let feed = try decoder.decode(SOFAFeed.self, from: data)

        return SOFAUpdateCatalog(
            updateHash: feed.updateHash,
            fetchedAt: fetchedAt,
            releases: feed.osVersions.map { version in
                SOFAUpdateRelease(
                    osVersion: version.osVersion,
                    productVersion: version.latest.productVersion,
                    build: version.latest.build,
                    releaseDate: version.latest.releaseDate,
                    securityInfo: version.latest.securityInfo,
                    cveCount: version.latest.cves.count,
                    activelyExploitedCVEs: version.latest.activelyExploitedCVEs
                )
            }
        )
    }
}

private struct SOFAFeed: Decodable {
    let updateHash: String
    let osVersions: [SOFAOSVersion]

    private enum CodingKeys: String, CodingKey {
        case updateHash = "UpdateHash"
        case osVersions = "OSVersions"
    }
}

private struct SOFAOSVersion: Decodable {
    let osVersion: String
    let latest: SOFALatestRelease

    private enum CodingKeys: String, CodingKey {
        case osVersion = "OSVersion"
        case latest = "Latest"
    }
}

private struct SOFALatestRelease: Decodable {
    let productVersion: String
    let build: String
    let releaseDate: Date?
    let securityInfo: String?
    let cves: [String: Bool]
    let activelyExploitedCVEs: [String]

    private enum CodingKeys: String, CodingKey {
        case productVersion = "ProductVersion"
        case build = "Build"
        case releaseDate = "ReleaseDate"
        case securityInfo = "SecurityInfo"
        case cves = "CVEs"
        case activelyExploitedCVEs = "ActivelyExploitedCVEs"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        productVersion = try container.decode(String.self, forKey: .productVersion)
        build = try container.decode(String.self, forKey: .build)
        releaseDate = try container.decodeIfPresent(Date.self, forKey: .releaseDate)
        securityInfo = try container.decodeIfPresent(String.self, forKey: .securityInfo)
        cves = try container.decodeIfPresent([String: Bool].self, forKey: .cves) ?? [:]
        activelyExploitedCVEs = try container.decodeIfPresent([String].self, forKey: .activelyExploitedCVEs) ?? []
    }
}

private struct SoftwareVersion {
    let parts: [Int]

    init(_ version: String) {
        parts = version
            .split(separator: ".")
            .map { Int($0) ?? 0 }
    }

    func compare(to other: SoftwareVersion) -> ComparisonResult {
        let count = max(parts.count, other.parts.count)

        for index in 0..<count {
            let left = index < parts.count ? parts[index] : 0
            let right = index < other.parts.count ? other.parts[index] : 0

            if left < right {
                return .orderedAscending
            }

            if left > right {
                return .orderedDescending
            }
        }

        return .orderedSame
    }
}
