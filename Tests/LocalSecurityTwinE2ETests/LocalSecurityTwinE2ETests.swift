import Foundation
import Testing
@testable import LocalSecurityTwin

@MainActor
struct LocalSecurityTwinPolicyE2ETests {
    @Test func policyWorkflowPersistsAndResetsRememberedDecisionE2E() throws {
        let storageURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
            .appendingPathComponent("policies.json", isDirectory: false)

        let request = PolicyRequest(
            action: .runSafeValidation,
            subject: PolicySubject(
                kind: "finding",
                identifier: "suspicious-launch-agent",
                displayName: "Suspicious launch agent"
            ),
            risk: .high,
            reason: "The app wants to run a tightly bounded validation before making a stronger claim.",
            evidenceSummary: "A launch agent appeared after the last trusted baseline."
        )

        let firstStore = PolicyStore(storageURL: storageURL)
        #expect(firstStore.resolution(for: request) == .needsConsent(.explicitApproval))

        try firstStore.record(
            decision: .allow,
            for: request,
            scope: .remembered,
            explicitConfirmation: true
        )

        let reloadedStore = PolicyStore(storageURL: storageURL)
        #expect(reloadedStore.resolution(for: request) == .allowed(.remembered))

        try reloadedStore.resetRememberedPolicy(for: request.key)

        let finalStore = PolicyStore(storageURL: storageURL)
        #expect(finalStore.resolution(for: request) == .needsConsent(.explicitApproval))
    }
}
