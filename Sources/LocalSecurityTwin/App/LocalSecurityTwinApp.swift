import SwiftUI

@main
struct LocalSecurityTwinApp: App {
    @StateObject private var findingStore: FindingStore
    @StateObject private var policyStore: PolicyStore
    @StateObject private var hygieneAnswerStore: SecurityHygieneAnswerStore

    init() {
        _findingStore = StateObject(wrappedValue: FindingStore())
        _policyStore = StateObject(wrappedValue: PolicyStore())
        _hygieneAnswerStore = StateObject(wrappedValue: SecurityHygieneAnswerStore())
    }

    var body: some Scene {
        WindowGroup("Sento Guard") {
            ContentView(
                findings: findingStore.findings,
                hygieneAnswers: hygieneAnswerStore.answers,
                hygienePersistenceNote: hygieneAnswerStore.localPersistenceNote,
                lastBaselineRefreshError: findingStore.lastBaselineRefreshError,
                lastUpdateAwarenessRefreshNote: findingStore.lastUpdateAwarenessRefreshNote,
                isRefreshingUpdateAwarenessSource: findingStore.isRefreshingUpdateAwarenessSource,
                recordHygieneAnswer: { answer, checkID in
                    try hygieneAnswerStore.record(answer: answer, for: checkID)
                },
                clearHygieneAnswer: { checkID in
                    try hygieneAnswerStore.clearAnswer(for: checkID)
                },
                rememberCurrentStartupState: {
                    findingStore.rememberCurrentStartupState()
                },
                refreshUpdateAwarenessSource: {
                    Task {
                        await findingStore.refreshUpdateAwarenessSource()
                    }
                }
            )
                .environmentObject(policyStore)
                .task {
                    await findingStore.refreshIfNeeded()
                }
        }

        Settings {
            SettingsView()
                .environmentObject(policyStore)
        }

        MenuBarExtra("Sento Guard", systemImage: "shield.lefthalf.filled") {
            MenuBarView(
                findings: findingStore.findings,
                rememberedPolicyCount: policyStore.rememberedPolicies.count,
                sensorCount: findingStore.sensorRuns.count,
                lastRefreshAt: findingStore.lastRefreshAt
            )
        }
    }
}
