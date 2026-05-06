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
        WindowGroup("Local Security Twin") {
            ContentView(findings: findingStore.findings)
                .environmentObject(policyStore)
                .task {
                    await findingStore.refreshIfNeeded()
                }
        }

        Settings {
            SettingsView()
                .environmentObject(policyStore)
        }

        MenuBarExtra("Security Twin", systemImage: "shield.lefthalf.filled") {
            MenuBarView(
                findings: findingStore.findings,
                rememberedPolicyCount: policyStore.rememberedPolicies.count,
                sensorCount: findingStore.sensorRuns.count,
                lastRefreshAt: findingStore.lastRefreshAt
            )
        }
    }
}
