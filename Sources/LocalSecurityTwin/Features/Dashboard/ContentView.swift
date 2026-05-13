import SwiftUI

struct ContentView: View {
    let findings: [Finding]
    let lastBaselineRefreshError: String?
    let rememberCurrentStartupState: () -> Void
    @State private var selection: Finding.ID?
    @State private var isShowingRememberConfirmation = false
    @State private var isKnownStartupExpanded = true

    private var presentation: DashboardPresentation {
        DashboardPresentation(findings: findings)
    }

    var body: some View {
        HSplitView {
            VStack(spacing: 0) {
                BuddyStatusPanel(
                    presentation: presentation,
                    primaryAction: {
                        selection = presentation.findings(in: .changes).first?.id
                            ?? findings.first?.id
                    }
                )

                if presentation.showsRememberCurrentStartupStateAction {
                    RememberStartupStateBanner(
                        error: lastBaselineRefreshError,
                        onConfirm: {
                            isShowingRememberConfirmation = true
                        }
                    )
                }

                List(selection: $selection) {
                    ForEach(FindingGroup.allCases) { group in
                        let groupFindings = presentation.findings(in: group)
                        if !groupFindings.isEmpty {
                            Section(group.title) {
                                if group == .knownStartupHints, let summary = presentation.knownStartupSummaryText {
                                    KnownStartupSummaryRow(text: summary)
                                    DisclosureGroup("Einzelne Hinweise anzeigen", isExpanded: $isKnownStartupExpanded) {
                                        ForEach(groupFindings) { finding in
                                            FindingRowView(finding: finding)
                                                .tag(finding.id)
                                        }
                                    }
                                } else {
                                    ForEach(groupFindings) { finding in
                                        FindingRowView(finding: finding)
                                            .tag(finding.id)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.sidebar)
            }
            .safeAreaPadding(.top, 28)
            .frame(minWidth: 300, idealWidth: 340, maxWidth: 420)
            .background(.thinMaterial)

            DetailPane(
                findings: findings,
                selection: selection
            )
            .frame(minWidth: 640)
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
            "Aktuellen Autostart-Zustand merken?",
            isPresented: $isShowingRememberConfirmation,
            titleVisibility: .visible
        ) {
            Button("Als erwartet merken") {
                rememberCurrentStartupState()
            }

            Button("Abbrechen", role: .cancel) {}
        } message: {
            Text("Die App behandelt die aktuell sichtbaren Autostart-Hinweise danach als erwartet. Sie aendert dabei keine Systemeinstellungen.")
        }
    }

}

private struct DetailPane: View {
    let findings: [Finding]
    let selection: Finding.ID?

    var body: some View {
        if findings.isEmpty {
            ContentUnavailableView(
                "Noch keine Hinweise",
                systemImage: "checkmark.shield",
                description: Text("Die lokalen Sensoren bleiben ruhig, solange sie keine Hinweise anzeigen muessen.")
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let selectedFinding = findings.first(where: { $0.id == selection }) ?? findings.first {
            FindingDetailView(finding: selectedFinding)
        } else {
            ContentUnavailableView(
                "Hinweis auswaehlen",
                systemImage: "shield",
                description: Text("Waehle links einen Hinweis aus, um Einordnung, Belege und sichere naechste Schritte zu sehen.")
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct BuddyStatusPanel: View {
    let presentation: DashboardPresentation
    let primaryAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 5) {
                    Text(presentation.statusTitle)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    Text(presentation.headlineText)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(presentation.buddyMessageText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Button(presentation.primaryActionTitle, action: primaryAction)
                .buttonStyle(.borderedProminent)
                .disabled(presentation.findings.isEmpty)

            HStack(spacing: 10) {
                SummaryPill(value: presentation.startupChangeCount, label: "neue Aenderungen")
                SummaryPill(value: presentation.knownStartupCount, label: "Autostart-Hinweise")
                SummaryPill(value: presentation.reviewCount, label: "System & Beobachtung")
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                DashboardGuidanceLine(title: "Naechster sicherer Schritt", text: presentation.nextStepText)
                DashboardGuidanceLine(title: "Was die App gerade sieht", text: presentation.visibilityText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.background)
    }
}

private struct DashboardGuidanceLine: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct SummaryPill: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(value)")
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(.quinary, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct RememberStartupStateBanner: View {
    let error: String?
    let onConfirm: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Autostart-Aenderungen sichtbar")
                        .font(.headline)
                    Text("Wenn diese Aenderungen erwartet sind, kannst du den aktuellen Zustand merken. Die App bleibt dann beim naechsten Lauf ruhiger.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button("Als erwartet merken", action: onConfirm)
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

private struct KnownStartupSummaryRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "rectangle.stack")
                .foregroundStyle(.secondary)
                .frame(width: 18)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 6)
    }
}
