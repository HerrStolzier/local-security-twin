import Foundation
import Testing
@testable import LocalSecurityTwin

@MainActor
struct StartupDiffFixtureTests {
    @Test func startupDiffFixtureCreatesRememberableAppState() throws {
        let fixture = try StartupDiffFixture()
        let store = FindingStore(
            pipeline: fixture.pipeline,
            contextProvider: fixture.context
        )

        store.refresh()

        let before = DashboardPresentation(findings: store.findings)
        #expect(before.startupChangeCount == 1)
        #expect(before.showsRememberCurrentStartupStateAction)
        #expect(store.findings.contains(where: { $0.displaySubject == "com.example.current.plist" }))

        store.rememberCurrentStartupState()

        let after = DashboardPresentation(findings: store.findings)
        #expect(after.startupChangeCount == 0)
        #expect(!after.showsRememberCurrentStartupStateAction)
        #expect(store.lastBaselineRefreshError == nil)
    }
}

private struct StartupDiffFixture {
    let workspaceURL: URL
    let homeURL: URL
    let pipeline: SensorPipeline

    init(fileManager: FileManager = .default) throws {
        workspaceURL = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        homeURL = workspaceURL.appendingPathComponent("home", isDirectory: true)

        let baselineURL = workspaceURL.appendingPathComponent("startup-item-baseline.json", isDirectory: false)
        let launchAgentsURL = homeURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("LaunchAgents", isDirectory: true)
        let currentURL = launchAgentsURL.appendingPathComponent("com.example.current.plist")

        try fileManager.createDirectory(at: launchAgentsURL, withIntermediateDirectories: true)
        try Self.writeMinimalPlist(to: currentURL)

        let baselineStore = StartupItemBaselineStore(storageURL: baselineURL)
        try baselineStore.save(
            StartupItemBaselineSnapshot(
                sensorID: "launch-agent-inventory",
                capturedAt: Date(timeIntervalSince1970: 500),
                items: []
            )
        )

        pipeline = SensorPipeline(
            sensors: [
                LaunchAgentInventorySensor(
                    fileManager: fileManager,
                    baselineStore: baselineStore,
                    sharedDirectories: []
                ),
            ]
        )
    }

    func context() -> SensorContext {
        SensorContext(
            homeDirectoryURL: homeURL,
            now: Date(timeIntervalSince1970: 1_000)
        )
    }

    private static func writeMinimalPlist(to url: URL) throws {
        let data = try PropertyListSerialization.data(
            fromPropertyList: [
                "Label": "com.example.current",
                "ProgramArguments": ["/usr/bin/true"],
                "RunAtLoad": true,
            ],
            format: .xml,
            options: 0
        )
        try data.write(to: url)
    }
}
