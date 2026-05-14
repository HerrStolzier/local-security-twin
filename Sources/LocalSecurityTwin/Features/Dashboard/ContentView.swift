import SwiftUI

struct ContentView: View {
    let findings: [Finding]
    let lastBaselineRefreshError: String?
    let rememberCurrentStartupState: () -> Void
    @State private var selection: Finding.ID?
    @State private var isShowingRememberConfirmation = false

    private var presentation: DashboardPresentation {
        DashboardPresentation(findings: findings)
    }

    var body: some View {
        HSplitView {
            BuddyHomeView(
                presentation: presentation,
                lastBaselineRefreshError: lastBaselineRefreshError,
                openFinding: { findingID in
                    selection = findingID
                },
                rememberCurrentStartupState: {
                    isShowingRememberConfirmation = true
                }
            )
            .frame(minWidth: selection == nil ? 920 : 620)

            if selection != nil {
                DetailPane(
                    findings: findings,
                    selection: selection,
                    close: {
                        selection = nil
                    }
                )
                .frame(minWidth: 520, idealWidth: 600)
            }
        }
        .frame(minWidth: selection == nil ? 980 : 1180, minHeight: 700)
        .onChange(of: findings) { _, newFindings in
            if let selection, newFindings.contains(where: { $0.id == selection }) {
                return
            }

            selection = nil
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

private struct BuddyHomeView: View {
    let presentation: DashboardPresentation
    let lastBaselineRefreshError: String?
    let openFinding: (Finding.ID) -> Void
    let rememberCurrentStartupState: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                GuardianStatusCard(
                    presentation: presentation,
                    primaryAction: {
                        if let findingID = presentation.findings(in: .changes).first?.id
                            ?? presentation.findings.first?.id {
                            openFinding(findingID)
                        }
                    }
                )

                if presentation.showsRememberCurrentStartupStateAction {
                    RememberStartupStateBanner(
                        error: lastBaselineRefreshError,
                        onConfirm: rememberCurrentStartupState
                    )
                }

                MissionSection(
                    missions: presentation.missions,
                    openFinding: openFinding
                )

                ActivityFeedSection(
                    items: presentation.activityItems,
                    openFinding: openFinding
                )

                VisibilityNote(text: presentation.visibilityText)
            }
            .padding(32)
            .frame(maxWidth: 1040, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .background(.background)
    }
}

private struct DetailPane: View {
    let findings: [Finding]
    let selection: Finding.ID?
    let close: () -> Void

    var body: some View {
        if findings.isEmpty {
            ContentUnavailableView(
                "Noch keine Hinweise",
                systemImage: "checkmark.shield",
                description: Text("Die lokalen Sensoren bleiben ruhig, solange sie keine Hinweise anzeigen muessen.")
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let selectedFinding = findings.first(where: { $0.id == selection }) ?? findings.first {
            VStack(spacing: 0) {
                HStack {
                    Text("Details")
                        .font(.headline)
                    Spacer()
                    Button("Schliessen", action: close)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.thinMaterial)

                Divider()

                FindingDetailView(finding: selectedFinding)
            }
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

private struct GuardianStatusCard: View {
    let presentation: DashboardPresentation
    let primaryAction: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 24) {
            ZStack {
                Circle()
                    .stroke(.quaternary, lineWidth: 12)
                    .frame(width: 132, height: 132)

                Circle()
                    .trim(from: 0, to: presentation.guardianProgress)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 132, height: 132)

                VStack(spacing: 2) {
                    Image(systemName: "shield.lefthalf.filled")
                        .font(.title2)
                        .foregroundStyle(.blue)

                    Text(presentation.guardianTone)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(presentation.statusTitle)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    Text(presentation.headlineText)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(presentation.buddyMessageText)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(spacing: 10) {
                    Button(presentation.primaryActionTitle, action: primaryAction)
                        .buttonStyle(.borderedProminent)
                        .disabled(presentation.findings.isEmpty)

                    Text(presentation.nextStepText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.quinary, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct MissionSection: View {
    let missions: [BuddyMission]
    let openFinding: (Finding.ID) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Missionen",
                subtitle: "Das sind die Schutzbereiche, auf die ich gerade achte."
            )

            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 230), spacing: 14),
                ],
                spacing: 14
            ) {
                ForEach(missions) { mission in
                    MissionCard(
                        mission: mission,
                        openFinding: openFinding
                    )
                }
            }
        }
    }
}

private struct MissionCard: View {
    let mission: BuddyMission
    let openFinding: (Finding.ID) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: mission.systemImage)
                    .font(.title3)
                    .foregroundStyle(.blue)
                    .frame(width: 24)

                Spacer()

                Text(mission.status)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.quaternary, in: Capsule())
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(mission.title)
                    .font(.headline)

                Text(mission.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)
            }

            ProgressView(value: mission.progress)
                .controlSize(.small)

            Button(mission.primaryActionTitle) {
                if let findingID = mission.findingID {
                    openFinding(findingID)
                }
            }
            .buttonStyle(.bordered)
            .disabled(mission.findingID == nil)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 210, alignment: .topLeading)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary)
        )
    }
}

private struct ActivityFeedSection: View {
    let items: [BuddyActivityItem]
    let openFinding: (Finding.ID) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Buddy-Aktivitaet",
                subtitle: "Was ich gerade lokal eingeordnet habe."
            )

            VStack(spacing: 10) {
                ForEach(items) { item in
                    ActivityFeedRow(item: item, openFinding: openFinding)
                }
            }
        }
    }
}

private struct ActivityFeedRow: View {
    let item: BuddyActivityItem
    let openFinding: (Finding.ID) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: item.systemImage)
                .foregroundStyle(.secondary)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)

                Text(item.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let findingID = item.findingID {
                Button("Details") {
                    openFinding(findingID)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(14)
        .background(.quinary, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct VisibilityNote: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "scope")
                .foregroundStyle(.secondary)
                .frame(width: 18)

            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 4)
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
