import Foundation
import Testing
@testable import LocalSecurityTwin

struct StartupItemBaselineStoreTests {
    @Test func baselineStoreCreatesAndReloadsInitialSnapshot() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let storageURL = workspaceURL.appendingPathComponent("startup-item-baseline.json", isDirectory: false)
        let store = StartupItemBaselineStore(storageURL: storageURL)
        let initialItems = [
            StartupItemRecord(
                path: "/Library/LaunchDaemons/com.example.daemon.plist",
                scope: .sharedDaemon
            ),
            StartupItemRecord(
                path: "/Users/example/Library/LaunchAgents/com.example.agent.plist",
                scope: .userAgent
            ),
        ]

        let firstState = try store.initializeIfNeeded(
            sensorID: "launch-agent-inventory",
            items: initialItems.reversed(),
            capturedAt: Date(timeIntervalSince1970: 1_000)
        )

        #expect(firstState.status == .createdInitialSnapshot)
        #expect(firstState.snapshot.items.map(\.id) == initialItems.map(\.id).sorted())
        #expect(try store.load() == firstState.snapshot)

        let secondState = try store.initializeIfNeeded(
            sensorID: "launch-agent-inventory",
            items: initialItems + [
                StartupItemRecord(
                    path: "/Library/LaunchAgents/com.example.extra.plist",
                    scope: .sharedAgent
                ),
            ],
            capturedAt: Date(timeIntervalSince1970: 2_000)
        )

        #expect(secondState.status == .loadedExistingSnapshot)
        #expect(secondState.snapshot == firstState.snapshot)
    }

    @Test func baselineStoreRejectsSnapshotForDifferentSensor() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let storageURL = workspaceURL.appendingPathComponent("startup-item-baseline.json", isDirectory: false)
        let store = StartupItemBaselineStore(storageURL: storageURL)

        try store.save(
            StartupItemBaselineSnapshot(
                sensorID: "different-sensor",
                capturedAt: Date(timeIntervalSince1970: 1_000),
                items: []
            )
        )

        #expect(throws: StartupItemBaselineStoreError.sensorMismatch(
            expected: "launch-agent-inventory",
            actual: "different-sensor"
        )) {
            try store.initializeIfNeeded(
                sensorID: "launch-agent-inventory",
                items: [],
                capturedAt: Date(timeIntervalSince1970: 2_000)
            )
        }
    }

    @Test func baselineRefreshReplacesSnapshotOnlyWhenSensorMatches() throws {
        let workspaceURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let storageURL = workspaceURL.appendingPathComponent("startup-item-baseline.json", isDirectory: false)
        let store = StartupItemBaselineStore(storageURL: storageURL)
        let originalItem = StartupItemRecord(
            path: "/Library/LaunchDaemons/com.example.old.plist",
            scope: .sharedDaemon
        )
        let refreshedItem = StartupItemRecord(
            path: "/private/var/example/../example/com.example.new.plist",
            scope: .sharedAgent,
            details: StartupItemDetails(
                label: "com.example.new",
                program: "/usr/local/bin/example",
                programArguments: ["/usr/local/bin/example", "--background"],
                runAtLoad: true,
                keepAliveSummary: "Always tries to stay available"
            )
        )

        try store.save(
            StartupItemBaselineSnapshot(
                sensorID: "launch-agent-inventory",
                capturedAt: Date(timeIntervalSince1970: 1_000),
                items: [originalItem]
            )
        )

        let refreshedSnapshot = try store.refresh(
            sensorID: "launch-agent-inventory",
            items: [refreshedItem],
            capturedAt: Date(timeIntervalSince1970: 2_000)
        )

        #expect(refreshedSnapshot.capturedAt == Date(timeIntervalSince1970: 2_000))
        #expect(refreshedSnapshot.items.map(\.id) == [refreshedItem.id])
        #expect(refreshedSnapshot.items.first?.details?.label == "com.example.new")
        #expect(try store.load(expectedSensorID: "launch-agent-inventory") == refreshedSnapshot)
    }
}
