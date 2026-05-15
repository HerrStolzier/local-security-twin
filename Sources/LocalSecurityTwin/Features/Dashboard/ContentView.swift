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
        ZStack {
            BuddyHomeBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
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
                .frame(maxWidth: 1080, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
    }
}

private struct BuddyHomeBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.blue.opacity(0.10),
                Color.green.opacity(0.08),
                Color.orange.opacity(0.07),
                Color(nsColor: .windowBackgroundColor),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
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

    private var toneColor: Color {
        if presentation.startupChangeCount > 0 {
            return .orange
        }

        if presentation.findings.isEmpty {
            return .green
        }

        return .cyan
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center, spacing: 26) {
                ZStack {
                    Circle()
                        .stroke(.quaternary, lineWidth: 12)
                        .frame(width: 140, height: 140)

                    Circle()
                        .trim(from: 0, to: presentation.guardianProgress)
                        .stroke(
                            AngularGradient(
                                colors: [
                                    toneColor,
                                    .green,
                                    .blue,
                                    toneColor,
                                ],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 140, height: 140)

                    VStack(spacing: 6) {
                        Image(systemName: presentation.startupChangeCount > 0 ? "shield.righthalf.filled" : "shield.lefthalf.filled")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [toneColor, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(presentation.guardianTone)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 14) {
                    StatusBadge(
                        text: presentation.statusTitle,
                        systemImage: presentation.startupChangeCount > 0 ? "exclamationmark.shield" : "checkmark.shield",
                        color: toneColor
                    )

                    Text(presentation.headlineText)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(presentation.buddyMessageText)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Divider()

            HStack(alignment: .center, spacing: 14) {
                Button(presentation.primaryActionTitle, action: primaryAction)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(toneColor)
                    .disabled(presentation.findings.isEmpty)

                Text(presentation.nextStepText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 8)

                DefenseMetric(value: presentation.startupChangeCount, label: "neu", color: .orange)
                DefenseMetric(value: presentation.knownStartupCount, label: "bekannt", color: .cyan)
                DefenseMetric(value: presentation.reviewCount, label: "System", color: .green)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    toneColor.opacity(0.16),
                    Color.green.opacity(0.10),
                    Color(nsColor: .controlBackgroundColor).opacity(0.72),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(toneColor.opacity(0.32), lineWidth: 1)
        )
        .shadow(color: toneColor.opacity(0.18), radius: 22, x: 0, y: 12)
    }
}

private struct StatusBadge: View {
    let text: String
    let systemImage: String
    let color: Color

    var body: some View {
        Label(text, systemImage: systemImage)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(color.opacity(0.12), in: Capsule())
    }
}

private struct DefenseMetric: View {
    let value: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(value)")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(color)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 72, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color.opacity(0.16))
        )
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

    private var accentColor: Color {
        switch mission.id {
        case "startup":
            return .orange
        case "system":
            return .cyan
        case "hygiene":
            return .green
        default:
            return .secondary
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: mission.systemImage)
                    .font(.title3)
                    .foregroundStyle(accentColor)
                    .frame(width: 34, height: 34)
                    .background(accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

                Spacer()

                Text(mission.status)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .foregroundStyle(accentColor)
                    .background(accentColor.opacity(0.12), in: Capsule())
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
                .tint(accentColor)

            Button(mission.primaryActionTitle) {
                if let findingID = mission.findingID {
                    openFinding(findingID)
                }
            }
            .buttonStyle(.bordered)
            .tint(accentColor)
            .disabled(mission.findingID == nil)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 210, alignment: .topLeading)
        .background(
            LinearGradient(
                colors: [
                    accentColor.opacity(0.16),
                    Color(nsColor: .controlBackgroundColor).opacity(0.72),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(accentColor.opacity(0.28))
        )
        .shadow(color: accentColor.opacity(0.08), radius: 12, x: 0, y: 8)
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

    private var accentColor: Color {
        item.findingID == nil ? .green : .cyan
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: item.systemImage)
                .foregroundStyle(accentColor)
                .frame(width: 28, height: 28)
                .background(accentColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))

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
        .background(
            LinearGradient(
                colors: [
                    accentColor.opacity(0.10),
                    Color(nsColor: .controlBackgroundColor).opacity(0.7),
                ],
                startPoint: .leading,
                endPoint: .trailing
            ),
            in: RoundedRectangle(cornerRadius: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(accentColor.opacity(0.16))
        )
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
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.orange.opacity(0.2))
        )
    }
}
