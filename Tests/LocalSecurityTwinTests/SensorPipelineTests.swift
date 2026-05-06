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
        #expect(run.notes.contains(where: { $0.contains("Saved the first local startup baseline") }))
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
                $0 == "Compared against the stored local baseline: 1 new item(s), 1 missing item(s)."
            })
        )
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
