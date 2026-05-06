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
}
