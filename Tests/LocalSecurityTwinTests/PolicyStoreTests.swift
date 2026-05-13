import Foundation
import Testing
@testable import LocalSecurityTwin

@MainActor
struct PolicyStoreTests {
    @Test func lowRiskRequestsNeedStandardConsentByDefault() throws {
        let store = makeStore()
        let request = makeRequest(risk: .low)

        let resolution = store.resolution(for: request)

        #expect(resolution == .needsConsent(.standard))
    }

    @Test func sessionDecisionStaysLocalToTheCurrentStore() throws {
        let storageURL = makeStorageURL()
        let store = PolicyStore(storageURL: storageURL)
        let request = makeRequest(risk: .medium)

        try store.record(decision: .allow, for: request, scope: .session)

        #expect(store.resolution(for: request) == .allowed(.session))

        let reloadedStore = PolicyStore(storageURL: storageURL)
        #expect(reloadedStore.resolution(for: request) == .needsConsent(.standard))
    }

    @Test func rememberedDecisionPersistsAcrossReload() throws {
        let storageURL = makeStorageURL()
        let store = PolicyStore(storageURL: storageURL)
        let request = makeRequest(risk: .medium)

        try store.record(decision: .deny, for: request, scope: .remembered)

        let reloadedStore = PolicyStore(storageURL: storageURL)
        #expect(reloadedStore.resolution(for: request) == .denied(.remembered))
        #expect(reloadedStore.rememberedPolicies.count == 1)
    }

    @Test func highRiskRememberedApprovalsNeedExplicitConfirmation() throws {
        let store = makeStore()
        let request = makeRequest(risk: .high, action: .runSafeValidation)

        #expect(throws: PolicyStoreError.explicitConfirmationRequired(actionTitle: "Weitere Belege sammeln")) {
            try store.record(decision: .allow, for: request, scope: .remembered)
        }

        try store.record(
            decision: .allow,
            for: request,
            scope: .remembered,
            explicitConfirmation: true
        )

        #expect(store.resolution(for: request) == .allowed(.remembered))
    }

    @Test func highRiskSessionApprovalsNeedExplicitConfirmationToo() throws {
        let store = makeStore()
        let request = makeRequest(risk: .high, action: .runSafeValidation)

        #expect(throws: PolicyStoreError.explicitConfirmationRequired(actionTitle: "Weitere Belege sammeln")) {
            try store.record(decision: .allow, for: request, scope: .session)
        }

        try store.record(
            decision: .allow,
            for: request,
            scope: .session,
            explicitConfirmation: true
        )

        #expect(store.resolution(for: request) == .allowed(.session))
    }

    @Test func guidedActionsDeclareTheirUserVisibleKind() {
        #expect(PolicyAction.trustItem.kind == .rememberLocalDecision)
        #expect(PolicyAction.openSensitiveSettings.kind == .openExternalLocation)
        #expect(PolicyAction.showGuidance.kind == .showGuidance)
        #expect(PolicyAction.runSafeValidation.kind == .gatherEvidence)
        #expect(PolicyAction.runSafeValidation.minimumConfirmation == .explicitApproval)
        #expect(PolicyAction.trustItem.kind.consentSummary.contains("lokal"))
    }

    @Test func legacyPolicyActionJSONDefaultsKindFromActionID() throws {
        let json = """
        {
          "id": "run-safe-validation",
          "title": "Gather More Evidence",
          "explanation": "Legacy action without kind.",
          "minimumConfirmation": "explicitApproval"
        }
        """

        let action = try JSONDecoder().decode(PolicyAction.self, from: Data(json.utf8))

        #expect(action.kind == .gatherEvidence)
        #expect(action.minimumConfirmation == .explicitApproval)
    }

    @Test func resetAllRememberedPoliciesClearsPersistedState() throws {
        let storageURL = makeStorageURL()
        let store = PolicyStore(storageURL: storageURL)
        let request = makeRequest(risk: .medium)

        try store.record(decision: .allow, for: request, scope: .remembered)
        try store.resetAllRememberedPolicies()

        let reloadedStore = PolicyStore(storageURL: storageURL)
        #expect(reloadedStore.rememberedPolicies.isEmpty)
        #expect(reloadedStore.resolution(for: request) == .needsConsent(.standard))
    }
}

@MainActor
private func makeStore() -> PolicyStore {
    PolicyStore(storageURL: makeStorageURL())
}

private func makeStorageURL() -> URL {
    FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
        .appendingPathComponent("policies.json", isDirectory: false)
}

private func makeRequest(
    risk: PolicyRisk,
    action: PolicyAction = .trustItem
) -> PolicyRequest {
    PolicyRequest(
        action: action,
        subject: PolicySubject(
            kind: "finding",
            identifier: "com.example.finding",
            displayName: "Example finding"
        ),
        risk: risk,
        reason: "The user is reviewing whether this item should stay trusted.",
        evidenceSummary: "The baseline comparison showed the same item twice in a row."
    )
}
