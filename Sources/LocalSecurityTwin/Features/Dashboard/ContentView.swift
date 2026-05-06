import SwiftUI

struct ContentView: View {
    let findings: [Finding]
    let lastBaselineRefreshError: String?
    let rememberCurrentStartupState: () -> Void
    @State private var selection: Finding.ID?
    @State private var isShowingRememberConfirmation = false

    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                if hasStartupChanges {
                    RememberStartupStateBanner(
                        error: lastBaselineRefreshError,
                        onConfirm: {
                            isShowingRememberConfirmation = true
                        }
                    )
                }

                List(findings, selection: $selection) { finding in
                    FindingRowView(finding: finding)
                        .tag(finding.id)
                }
            }
            .navigationTitle("Findings")
        } detail: {
            if findings.isEmpty {
                ContentUnavailableView(
                    "No findings yet",
                    systemImage: "checkmark.shield",
                    description: Text("The first local sensor stays quiet unless it finds visible startup items. That means the app is not seeing anything worth surfacing right now.")
                )
            } else if let selectedFinding = findings.first(where: { $0.id == selection }) {
                FindingDetailView(finding: selectedFinding)
            } else {
                ContentUnavailableView(
                    "Select a finding",
                    systemImage: "shield",
                    description: Text("The future app will show live evidence, user guidance, and policy decisions here.")
                )
            }
        }
        .frame(minWidth: 1020, minHeight: 640)
        .onAppear {
            if selection == nil {
                selection = findings.first?.id
            }
        }
        .onChange(of: findings) { _, newFindings in
            if newFindings.contains(where: { $0.id == selection }) {
                return
            }

            selection = newFindings.first?.id
        }
        .confirmationDialog(
            "Remember current startup state?",
            isPresented: $isShowingRememberConfirmation,
            titleVisibility: .visible
        ) {
            Button("Remember Current Startup State") {
                rememberCurrentStartupState()
            }

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("The app will treat the currently visible startup hints as expected from now on. It will not change system settings.")
        }
    }

    private var hasStartupChanges: Bool {
        findings.contains { $0.source.kind == .baselineDiff }
    }
}

private struct RememberStartupStateBanner: View {
    let error: String?
    let onConfirm: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Startup changes are visible")
                        .font(.headline)
                    Text("If these changes are expected, remember the current startup state so the app can stay quiet about them next time.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button("Remember as Expected", action: onConfirm)
                    .buttonStyle(.borderedProminent)
            }

            if let error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding(14)
        .background(.quinary)
    }
}
