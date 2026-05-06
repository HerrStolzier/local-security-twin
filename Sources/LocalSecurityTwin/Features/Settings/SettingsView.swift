import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var policyStore: PolicyStore
    @State private var persistenceError: String?

    var body: some View {
        Form {
            Section("Trust and policy") {
                if policyStore.rememberedPolicies.isEmpty {
                    Text("No remembered approvals yet.")
                    Text("The app can now remember approved or denied actions locally. Future work will connect this store to real findings and guided actions.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(policyStore.rememberedPolicies) { record in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(record.subjectName)
                                    .font(.headline)
                                Spacer()
                                Text(record.decision.title)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(.quaternary, in: Capsule())
                            }

                            Text(record.actionTitle)
                                .font(.subheadline)

                            Text(record.reason)
                                .foregroundStyle(.secondary)

                            HStack {
                                Text("\(record.scope.title) · \(record.risk.title) risk")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                                Spacer()
                                Button("Reset") {
                                    reset(record.key)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Button("Reset all remembered decisions", role: .destructive) {
                        resetAll()
                    }
                }
            }

            Section("Connectivity") {
                Text("Online intelligence is not enabled in this skeleton.")
                Text("The product should stay useful offline.")
                    .foregroundStyle(.secondary)
            }

            if let persistenceError {
                Section("Storage") {
                    Text(persistenceError)
                        .foregroundStyle(.red)
                }
            }
        }
        .padding(20)
        .frame(width: 520)
    }

    private func reset(_ key: PolicyKey) {
        do {
            try policyStore.resetRememberedPolicy(for: key)
            persistenceError = nil
        } catch {
            persistenceError = error.localizedDescription
        }
    }

    private func resetAll() {
        do {
            try policyStore.resetAllRememberedPolicies()
            persistenceError = nil
        } catch {
            persistenceError = error.localizedDescription
        }
    }
}
