import SwiftUI

@main
struct LocalSecurityTwinApp: App {
    @StateObject private var findingStore: FindingStore
    @StateObject private var policyStore: PolicyStore

    init() {
        _findingStore = StateObject(wrappedValue: FindingStore())
        _policyStore = StateObject(wrappedValue: PolicyStore())
    }

    var body: some Scene {
        WindowGroup("Sento Guard") {
            ContentView(
                findings: findingStore.findings,
                lastBaselineRefreshError: findingStore.lastBaselineRefreshError,
                lastUpdateAwarenessRefreshNote: findingStore.lastUpdateAwarenessRefreshNote,
                isRefreshingUpdateAwarenessSource: findingStore.isRefreshingUpdateAwarenessSource,
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
