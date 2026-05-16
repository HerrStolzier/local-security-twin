import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var policyStore: PolicyStore
    @State private var persistenceError: String?

    var body: some View {
        Form {
            Section("Vertrauen und Entscheidungen") {
                if let localPersistenceNote = policyStore.localPersistenceNote {
                    Text(localPersistenceNote)
                        .foregroundStyle(.secondary)
                }

                if policyStore.rememberedPolicies.isEmpty {
                    Text("Noch keine gemerkten Entscheidungen.")
                    Text("Die App kann erlaubte oder abgelehnte Schritte lokal merken. Spätere geführte Aktionen werden diese Entscheidungen nutzen.")
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
                                Text("\(record.scope.title) · Risiko: \(record.risk.title)")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                                Spacer()
                                Button("Zurücksetzen") {
                                    reset(record.key)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Button("Alle gemerkten Entscheidungen zurücksetzen", role: .destructive) {
                        resetAll()
                    }
                }
            }

            Section("Verbindung") {
                Text("Online-Intelligenz ist aktuell nicht aktiviert.")
                Text("Das Produkt soll auch offline nützlich bleiben.")
                    .foregroundStyle(.secondary)
            }

            if let persistenceError {
                Section("Speicher") {
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
