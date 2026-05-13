import Foundation
import Testing
@testable import LocalSecurityTwin

struct SensorPipelineTests {
    @Test func launchAgentInventorySensorReportsFindingsFromVisibleDirectories() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let homeURL = workspaceURL.appendingPathComponent("home", isDirectory: true)
        let baselineURL = workspaceURL.appendingPathComponent("startup-item-baseline.json", isDirectory: false)
        let userLaunchAgentsURL = homeURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("LaunchAgents", isDirectory: true)
        let sharedLaunchDaemonsURL = workspaceURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("LaunchDaemons", isDirectory: true)

        try FileManager.default.createDirectory(at: userLaunchAgentsURL, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: sharedLaunchDaemonsURL, withIntermediateDirectories: true)
        FileManager.default.createFile(
            atPath: userLaunchAgentsURL.appendingPathComponent("com.example.agent.plist").path,
            contents: Data("<plist/>".utf8)
        )
        FileManager.default.createFile(
            atPath: sharedLaunchDaemonsURL.appendingPathComponent("com.example.daemon.plist").path,
            contents: Data("<plist/>".utf8)
        )

        let baselineStore = StartupItemBaselineStore(storageURL: baselineURL)
        let sensor = LaunchAgentInventorySensor(
            fileManager: .default,
            baselineStore: baselineStore,
            sharedDirectories: [sharedLaunchDaemonsURL]
        )

        let run = sensor.run(
            in: SensorContext(
                homeDirectoryURL: homeURL,
                now: Date(timeIntervalSince1970: 1_000)
            )
        )

        #expect(run.sensor.id == "launch-agent-inventory")
        #expect(run.findings.count == 2)
        #expect(run.findings.contains(where: { $0.severity == .medium }))
        #expect(run.findings.contains(where: { $0.severity == .high }))
        #expect(run.notes.contains(where: { $0.contains("Ersten lokalen Autostart-Zustand") }))
        #expect(try baselineStore.load()?.items.count == 2)
    }

    @Test func launchAgentInventorySensorReportsAddedAndRemovedItemsAgainstStoredBaseline() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let homeURL = workspaceURL.appendingPathComponent("home", isDirectory: true)
        let baselineURL = workspaceURL.appendingPathComponent("startup-item-baseline.json", isDirectory: false)
        let userLaunchAgentsURL = homeURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("LaunchAgents", isDirectory: true)
        let sharedLaunchDaemonsURL = workspaceURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("LaunchDaemons", isDirectory: true)

        try FileManager.default.createDirectory(at: userLaunchAgentsURL, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: sharedLaunchDaemonsURL, withIntermediateDirectories: true)

        let unchangedURL = userLaunchAgentsURL.appendingPathComponent("com.example.unchanged.plist")
        let addedURL = sharedLaunchDaemonsURL.appendingPathComponent("com.example.new-daemon.plist")
        let removedURL = userLaunchAgentsURL.appendingPathComponent("com.example.removed.plist")

        FileManager.default.createFile(
            atPath: unchangedURL.path,
            contents: Data("<plist/>".utf8)
        )
        FileManager.default.createFile(
            atPath: addedURL.path,
            contents: Data("<plist/>".utf8)
        )

        let baselineStore = StartupItemBaselineStore(storageURL: baselineURL)
        try baselineStore.save(
            StartupItemBaselineSnapshot(
                sensorID: "launch-agent-inventory",
                capturedAt: Date(timeIntervalSince1970: 500),
                items: [
                    StartupItemRecord(
                        path: unchangedURL.path,
                        scope: .userAgent
                    ),
                    StartupItemRecord(
                        path: removedURL.path,
                        scope: .userAgent
                    ),
                ]
            )
        )

        let sensor = LaunchAgentInventorySensor(
            fileManager: .default,
            baselineStore: baselineStore,
            sharedDirectories: [sharedLaunchDaemonsURL]
        )

        let run = sensor.run(
            in: SensorContext(
                homeDirectoryURL: homeURL,
                now: Date(timeIntervalSince1970: 1_000)
            )
        )

        #expect(run.findings.count == 3)
        #expect(
            run.findings.contains(where: {
                $0.source.kind == .baselineDiff
                    && $0.summary.contains("com.example.new-daemon.plist")
            })
        )
        #expect(
            run.findings.contains(where: {
                $0.source.kind == .baselineDiff
                    && $0.summary.contains("com.example.removed.plist")
            })
        )
        #expect(
            run.findings.contains(where: {
                $0.source.kind == .launchAgentInventory
                    && $0.summary.contains("com.example.unchanged.plist")
            })
        )
        #expect(
            run.notes.contains(where: {
                $0 == "Mit dem lokal gemerkten Zustand verglichen: 1 neue Eintraege, 1 verschwundene Eintraege."
            })
        )
    }

    @Test func launchAgentInventorySensorKeepsInventoryVisibleWhenBaselineIsCorrupt() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let homeURL = workspaceURL.appendingPathComponent("home", isDirectory: true)
        let baselineURL = workspaceURL.appendingPathComponent("startup-item-baseline.json", isDirectory: false)
        let userLaunchAgentsURL = homeURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("LaunchAgents", isDirectory: true)

        try FileManager.default.createDirectory(at: userLaunchAgentsURL, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: workspaceURL, withIntermediateDirectories: true)
        try Data("not-json".utf8).write(to: baselineURL)

        FileManager.default.createFile(
            atPath: userLaunchAgentsURL.appendingPathComponent("com.example.agent.plist").path,
            contents: Data("<plist/>".utf8)
        )

        let sensor = LaunchAgentInventorySensor(
            fileManager: .default,
            baselineStore: StartupItemBaselineStore(storageURL: baselineURL),
            sharedDirectories: []
        )

        let run = sensor.run(
            in: SensorContext(
                homeDirectoryURL: homeURL,
                now: Date(timeIntervalSince1970: 1_000)
            )
        )

        #expect(run.findings.count == 1)
        #expect(run.findings.first?.source.kind == .launchAgentInventory)
        #expect(run.notes.contains(where: { $0.contains("Autostart-Aenderungserkennung ist in diesem Lauf eingeschraenkt") }))
    }

    @Test func launchAgentInventorySensorKeepsInventoryVisibleWhenBaselineCannotBeSaved() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let homeURL = workspaceURL.appendingPathComponent("home", isDirectory: true)
        let blockedBaselineURL = workspaceURL.appendingPathComponent("startup-item-baseline.json", isDirectory: false)
        let userLaunchAgentsURL = homeURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("LaunchAgents", isDirectory: true)

        try FileManager.default.createDirectory(at: userLaunchAgentsURL, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: blockedBaselineURL, withIntermediateDirectories: true)

        FileManager.default.createFile(
            atPath: userLaunchAgentsURL.appendingPathComponent("com.example.agent.plist").path,
            contents: Data("<plist/>".utf8)
        )

        let sensor = LaunchAgentInventorySensor(
            fileManager: .default,
            baselineStore: StartupItemBaselineStore(storageURL: blockedBaselineURL),
            sharedDirectories: []
        )

        let run = sensor.run(
            in: SensorContext(
                homeDirectoryURL: homeURL,
                now: Date(timeIntervalSince1970: 1_000)
            )
        )

        #expect(run.findings.count == 1)
        #expect(run.findings.first?.source.kind == .launchAgentInventory)
        #expect(run.notes.contains(where: { $0.contains("Autostart-Aenderungserkennung ist in diesem Lauf eingeschraenkt") }))
    }

    @Test func launchAgentInventorySensorReadsSimplePlistDetails() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let homeURL = workspaceURL.appendingPathComponent("home", isDirectory: true)
        let baselineURL = workspaceURL.appendingPathComponent("startup-item-baseline.json", isDirectory: false)
        let userLaunchAgentsURL = homeURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("LaunchAgents", isDirectory: true)
        let plistURL = userLaunchAgentsURL.appendingPathComponent("com.example.agent.plist")

        try FileManager.default.createDirectory(at: userLaunchAgentsURL, withIntermediateDirectories: true)
        let plistData = try PropertyListSerialization.data(
            fromPropertyList: [
                "Label": "com.example.agent",
                "ProgramArguments": ["/usr/local/bin/example", "--background"],
                "RunAtLoad": true,
                "KeepAlive": true,
            ],
            format: .xml,
            options: 0
        )
        try plistData.write(to: plistURL)

        let sensor = LaunchAgentInventorySensor(
            fileManager: .default,
            baselineStore: StartupItemBaselineStore(storageURL: baselineURL),
            sharedDirectories: []
        )

        let run = sensor.run(
            in: SensorContext(
                homeDirectoryURL: homeURL,
                now: Date(timeIntervalSince1970: 1_000)
            )
        )

        let detailsEvidence = try #require(run.findings.first?.evidence.first(where: { $0.id == "plist-details" }))
        #expect(detailsEvidence.detail.contains("Label: com.example.agent"))
        #expect(detailsEvidence.detail.contains("Program arguments: /usr/local/bin/example --background"))
        #expect(detailsEvidence.detail.contains("Run at load: yes"))
    }

    @Test func startupBaselineRefreshClearsPreviousDiffFindings() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let homeURL = workspaceURL.appendingPathComponent("home", isDirectory: true)
        let baselineURL = workspaceURL.appendingPathComponent("startup-item-baseline.json", isDirectory: false)
        let userLaunchAgentsURL = homeURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("LaunchAgents", isDirectory: true)
        let unchangedURL = userLaunchAgentsURL.appendingPathComponent("com.example.unchanged.plist")
        let addedURL = userLaunchAgentsURL.appendingPathComponent("com.example.added.plist")

        try FileManager.default.createDirectory(at: userLaunchAgentsURL, withIntermediateDirectories: true)
        FileManager.default.createFile(atPath: unchangedURL.path, contents: Data("<plist/>".utf8))
        FileManager.default.createFile(atPath: addedURL.path, contents: Data("<plist/>".utf8))

        let baselineStore = StartupItemBaselineStore(storageURL: baselineURL)
        try baselineStore.save(
            StartupItemBaselineSnapshot(
                sensorID: "launch-agent-inventory",
                capturedAt: Date(timeIntervalSince1970: 500),
                items: [
                    StartupItemRecord(path: unchangedURL.path, scope: .userAgent),
                ]
            )
        )

        let sensor = LaunchAgentInventorySensor(
            fileManager: .default,
            baselineStore: baselineStore,
            sharedDirectories: []
        )
        let context = SensorContext(homeDirectoryURL: homeURL, now: Date(timeIntervalSince1970: 1_000))

        #expect(sensor.run(in: context).findings.contains(where: { $0.source.kind == .baselineDiff }))

        try sensor.refreshRememberedStartupState(in: context)

        let runAfterRefresh = sensor.run(
            in: SensorContext(homeDirectoryURL: homeURL, now: Date(timeIntervalSince1970: 2_000))
        )
        #expect(!runAfterRefresh.findings.contains(where: { $0.source.kind == .baselineDiff }))
        #expect(try baselineStore.load(expectedSensorID: "launch-agent-inventory")?.items.count == 2)
    }

    @Test func findingStoreSortsCollectedFindingsBySeverityThenConfidence() async throws {
        let pipeline = SensorPipeline(
            sensors: [
                StubSensor(
                    descriptor: SensorDescriptor(
                        id: "stub",
                        title: "Stub",
                        summary: "Test sensor"
                    ),
                    findings: [
                        Finding(
                            id: "low",
                            title: "Low confidence item",
                            source: FindingSource(
                                kind: .systemInventory,
                                title: "Stub",
                                detail: "Stub"
                            ),
                            severity: .low,
                            confidence: .tentative,
                            summary: "Low",
                            userImpact: "Low",
                            nextStep: "Low",
                            evidence: [],
                            recommendations: []
                        ),
                        Finding(
                            id: "high",
                            title: "High confidence item",
                            source: FindingSource(
                                kind: .systemInventory,
                                title: "Stub",
                                detail: "Stub"
                            ),
                            severity: .high,
                            confidence: .supported,
                            summary: "High",
                            userImpact: "High",
                            nextStep: "High",
                            evidence: [],
                            recommendations: []
                        ),
                    ]
                )
            ]
        )

        let store = await MainActor.run { FindingStore(pipeline: pipeline) }
        await MainActor.run {
            #expect(store.findings.isEmpty)
        }

        await MainActor.run {
            store.refresh()
        }

        await MainActor.run {
            #expect(store.findings.map(\.id) == ["high", "low"])
            #expect(store.sensorRuns.count == 1)
        }
    }

    @Test func findingStoreCanRememberCurrentStartupStateAndRefreshFindings() async throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let homeURL = workspaceURL.appendingPathComponent("home", isDirectory: true)
        let baselineURL = workspaceURL.appendingPathComponent("startup-item-baseline.json", isDirectory: false)
        let userLaunchAgentsURL = homeURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("LaunchAgents", isDirectory: true)
        let currentURL = userLaunchAgentsURL.appendingPathComponent("com.example.current.plist")

        try FileManager.default.createDirectory(at: userLaunchAgentsURL, withIntermediateDirectories: true)
        FileManager.default.createFile(atPath: currentURL.path, contents: Data("<plist/>".utf8))

        let baselineStore = StartupItemBaselineStore(storageURL: baselineURL)
        try baselineStore.save(
            StartupItemBaselineSnapshot(
                sensorID: "launch-agent-inventory",
                capturedAt: Date(timeIntervalSince1970: 500),
                items: []
            )
        )

        let pipeline = SensorPipeline(
            sensors: [
                LaunchAgentInventorySensor(
                    fileManager: .default,
                    baselineStore: baselineStore,
                    sharedDirectories: []
                )
            ]
        )
        let store = await MainActor.run {
            FindingStore(
                pipeline: pipeline,
                contextProvider: {
                    SensorContext(homeDirectoryURL: homeURL, now: Date(timeIntervalSince1970: 1_000))
                }
            )
        }

        await MainActor.run {
            store.refresh()
            #expect(store.findings.contains(where: { $0.source.kind == .baselineDiff }))
            let presentationBeforeRefresh = DashboardPresentation(findings: store.findings)
            #expect(presentationBeforeRefresh.showsRememberCurrentStartupStateAction)
            #expect(presentationBeforeRefresh.startupChangeCount == 1)
            store.rememberCurrentStartupState()
            #expect(!store.findings.contains(where: { $0.source.kind == .baselineDiff }))
            let presentationAfterRefresh = DashboardPresentation(findings: store.findings)
            #expect(!presentationAfterRefresh.showsRememberCurrentStartupStateAction)
            #expect(presentationAfterRefresh.startupChangeCount == 0)
            #expect(store.lastBaselineRefreshError == nil)
        }
    }
}

private struct StubSensor: FindingSensor {
    let descriptor: SensorDescriptor
    let findings: [Finding]

    func run(in context: SensorContext) -> SensorRun {
        SensorRun(
            sensor: descriptor,
            findings: findings,
            notes: [],
            completedAt: context.now
        )
    }
}
