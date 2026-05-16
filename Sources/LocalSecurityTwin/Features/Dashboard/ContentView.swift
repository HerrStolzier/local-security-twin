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
            SentoSidebar(presentation: presentation)
                .frame(width: 220)

            ZStack {
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
            }

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
        .frame(minWidth: selection == nil ? 1060 : 1240, minHeight: 720)
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

private struct SentoSidebar: View {
    let presentation: DashboardPresentation

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(spacing: 12) {
                SentoMark(size: 38)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Sento Guard")
                        .font(.headline)
                    Text("Dein lokaler Schutzbuddy")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, 18)

            SidebarPrimaryRow()

            SidebarGroup(
                title: "Missionen",
                items: [
                    SidebarItem(title: "Autostart", value: "\(presentation.knownStartupCount)", systemImage: "bolt.horizontal.circle", color: .orange),
                    SidebarItem(title: "Mac-Schutz", value: "\(presentation.reviewCount)", systemImage: "desktopcomputer", color: .cyan),
                    SidebarItem(title: "Security-Hygiene", value: "Plan", systemImage: "checklist.checked", color: .purple),
                ]
            )

            SidebarGroup(
                title: "Buddy",
                items: [
                    SidebarItem(title: "Aktivitaet", value: "\(presentation.activityItems.count)", systemImage: "sparkles", color: .blue),
                    SidebarItem(title: "Hinweise", value: "\(presentation.findings.count)", systemImage: "bell", color: .indigo),
                    SidebarItem(title: "Systemsignale", value: "\(presentation.reviewCount)", systemImage: "display", color: .cyan),
                ]
            )

            Spacer()

            SentoSidebarCard()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 18)
        .background(.ultraThinMaterial)
    }
}

private struct SentoMark: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [.blue.opacity(0.85), .cyan.opacity(0.85), .purple.opacity(0.72)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(systemName: "shield.lefthalf.filled")
                .font(.system(size: size * 0.46, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
    }
}

private struct SidebarPrimaryRow: View {
    var body: some View {
        Label("Uebersicht", systemImage: "house")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.blue)
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.blue.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct SidebarGroup: View {
    let title: String
    let items: [SidebarItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            ForEach(items) { item in
                HStack(spacing: 10) {
                    Image(systemName: item.systemImage)
                        .foregroundStyle(item.color)
                        .frame(width: 20)

                    Text(item.title)
                        .font(.subheadline)
                        .lineLimit(1)

                    Spacer()

                    Text(item.value)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(item.color)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(item.color.opacity(0.12), in: Capsule())
                }
                .padding(.vertical, 5)
            }
        }
    }
}

private struct SidebarItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let systemImage: String
    let color: Color
}

private struct SentoSidebarCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SentoCharacterBadge(size: 76)

            Text("Ich bin Sento")
                .font(.headline)

            Text("Ich beobachte lokal und melde mich, wenn etwas deine Aufmerksamkeit braucht.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.blue.opacity(0.14))
        )
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
                    SentoTopBar()

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

                    SentoLocalPromiseCard()

                    VisibilityNote(text: presentation.visibilityText)
                }
                .padding(32)
                .frame(maxWidth: 1180, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
    }
}

private struct SentoTopBar: View {
    var body: some View {
        HStack {
            Spacer()

            Label("Lokaler Check bereit", systemImage: "circle.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))

            Button {
            } label: {
                Image(systemName: "bell")
            }
            .buttonStyle(.bordered)
            .disabled(true)

            SettingsLink {
                Image(systemName: "gearshape")
            }
            .buttonStyle(.bordered)
        }
    }
}

private struct BuddyHomeBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.cyan.opacity(0.11),
                Color.blue.opacity(0.08),
                Color.purple.opacity(0.06),
                Color.orange.opacity(0.05),
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
        HStack(alignment: .center, spacing: 28) {
            SentoCharacterBadge(size: 156)

            VStack(alignment: .leading, spacing: 16) {
                StatusBadge(
                    text: presentation.statusTitle,
                    systemImage: presentation.startupChangeCount > 0 ? "exclamationmark.shield" : "checkmark.shield",
                    color: toneColor
                )

                Text("Hallo! Ich bin Sento Guard.")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(presentation.buddyMessageText)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(alignment: .center, spacing: 14) {
                    Button(presentation.primaryActionTitle, action: primaryAction)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(toneColor)
                        .disabled(presentation.findings.isEmpty)

                    Text(presentation.nextStepText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: 16)

            HStack(spacing: 12) {
                DefenseMetric(value: presentation.startupChangeCount, label: "neu", color: .mint)
                DefenseMetric(value: presentation.knownStartupCount, label: "Hinweise", color: .blue)
                DefenseMetric(value: presentation.reviewCount, label: "System", color: .purple)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .background(toneColor.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(toneColor.opacity(0.32), lineWidth: 1)
        )
        .shadow(color: toneColor.opacity(0.18), radius: 22, x: 0, y: 12)
    }
}

private struct SentoCharacterBadge: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(.cyan.opacity(0.16))
                .frame(width: size, height: size)

            Circle()
                .stroke(.blue.opacity(0.18), lineWidth: size * 0.055)
                .frame(width: size * 0.88, height: size * 0.88)

            Circle()
                .trim(from: 0.05, to: 0.78)
                .stroke(
                    AngularGradient(
                        colors: [.cyan, .blue, .purple, .cyan],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: size * 0.055, lineCap: .round)
                )
                .rotationEffect(.degrees(-86))
                .frame(width: size * 0.88, height: size * 0.88)

            VStack(spacing: size * 0.05) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: size * 0.28, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("Sento")
                    .font(.system(size: max(10, size * 0.09), weight: .bold))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
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
        VStack(alignment: .leading, spacing: 4) {
            Text("\(value)")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(color)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 104, height: 82, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
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
                    GridItem(.adaptive(minimum: 210), spacing: 14),
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
            return .purple
        case "privacy":
            return .teal
        case "app-risk":
            return .pink
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
                    .foregroundStyle(.primary)

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
        .frame(maxWidth: .infinity, minHeight: 214, alignment: .topLeading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .background(accentColor.opacity(0.07), in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(accentColor.opacity(0.28))
        )
        .shadow(color: accentColor.opacity(0.08), radius: 12, x: 0, y: 8)
    }
}

private struct SentoLocalPromiseCard: View {
    var body: some View {
        HStack(alignment: .center, spacing: 22) {
            SentoCharacterBadge(size: 112)

            VStack(alignment: .leading, spacing: 10) {
                Text("Ich bleibe lokal")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Aktuell pruefe ich lokale Hinweise beim Start und zeige dir ruhig, was ich einordnen kann.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 6) {
                    Label("100% lokal im aktuellen Stand", systemImage: "checkmark.circle.fill")
                    Label("Datenschutzfreundlich gedacht", systemImage: "checkmark.circle.fill")
                    Label("Technische Details nur bei Bedarf", systemImage: "checkmark.circle.fill")
                }
                .font(.caption)
                .foregroundStyle(.blue)
            }

            Spacer()
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.cyan.opacity(0.16))
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

    private var accentColor: Color {
        item.findingID == nil ? .purple : .cyan
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
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .background(accentColor.opacity(0.06), in: RoundedRectangle(cornerRadius: 8))
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
