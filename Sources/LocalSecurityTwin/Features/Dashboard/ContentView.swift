import SwiftUI

struct ContentView: View {
    let findings: [Finding]
    let hygieneAnswers: [SecurityHygieneAnswerRecord]
    let hygienePersistenceNote: String?
    let lastBaselineRefreshError: String?
    let lastUpdateAwarenessRefreshNote: String?
    let isRefreshingUpdateAwarenessSource: Bool
    let recordHygieneAnswer: (SecurityHygieneAnswer, SecurityHygieneCheckID) throws -> Void
    let rememberCurrentStartupState: () -> Void
    let refreshUpdateAwarenessSource: () -> Void
    @State private var selection: Finding.ID?
    @State private var isShowingRememberConfirmation = false
    @State private var isShowingUpdateAwarenessConfirmation = false
    @State private var hygieneAnswerError: String?

    private var presentation: DashboardPresentation {
        DashboardPresentation(findings: findings, hygieneAnswers: hygieneAnswers)
    }

    var body: some View {
        GeometryReader { proxy in
            if usesCompactShell(for: proxy.size.width) {
                compactDashboardShell
            } else {
                regularDashboardShell
            }
        }
        .frame(minWidth: 560, minHeight: 620)
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
            Text("Die App behandelt die aktuell sichtbaren Autostart-Hinweise danach als erwartet. Sie ändert dabei keine Systemeinstellungen.")
        }
        .confirmationDialog(
            "SOFA-Stand online aktualisieren?",
            isPresented: $isShowingUpdateAwarenessConfirmation,
            titleVisibility: .visible
        ) {
            Button("SOFA-Stand aktualisieren") {
                refreshUpdateAwarenessSource()
            }

            Button("Abbrechen", role: .cancel) {}
        } message: {
            Text("Sento Guard lädt einmalig den öffentlichen macOS-Update-Stand von SOFA, speichert ihn lokal und vergleicht ihn mit deiner sichtbaren macOS-Version. Die App installiert nichts und ändert keine Systemeinstellungen.")
        }
    }

    private func usesCompactShell(for width: CGFloat) -> Bool {
        width < 760
    }

    private var regularDashboardShell: some View {
        HSplitView {
            SentoSidebar(presentation: presentation)
                .frame(minWidth: 176, idealWidth: 220, maxWidth: 240)

            ZStack {
                buddyHome
            }

            if selection != nil {
                DetailPane(
                    findings: findings,
                    selection: selection,
                    close: {
                        selection = nil
                    }
                )
                .frame(minWidth: 360, idealWidth: 520)
            }
        }
    }

    private var compactDashboardShell: some View {
        VStack(spacing: 0) {
            CompactSentoNavigation(presentation: presentation)

            Divider()

            if selection != nil {
                compactDetail
            } else {
                buddyHome
            }
        }
    }

    private var compactDetail: some View {
        DetailPane(
            findings: findings,
            selection: selection,
            close: {
                selection = nil
            }
        )
    }

    private var buddyHome: some View {
        BuddyHomeView(
            presentation: presentation,
            lastBaselineRefreshError: lastBaselineRefreshError,
            lastUpdateAwarenessRefreshNote: lastUpdateAwarenessRefreshNote,
            isRefreshingUpdateAwarenessSource: isRefreshingUpdateAwarenessSource,
            hygienePersistenceNote: hygienePersistenceNote,
            hygieneAnswerError: hygieneAnswerError,
            openFinding: { findingID in
                selection = findingID
            },
            recordHygieneAnswer: { answer, checkID in
                do {
                    try recordHygieneAnswer(answer, checkID)
                    hygieneAnswerError = nil
                } catch {
                    hygieneAnswerError = "Diese Antwort konnte gerade nicht lokal gespeichert werden."
                }
            },
            rememberCurrentStartupState: {
                isShowingRememberConfirmation = true
            },
            refreshUpdateAwarenessSource: {
                isShowingUpdateAwarenessConfirmation = true
            }
        )
        .frame(minWidth: 0, maxWidth: .infinity)
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
                    SidebarItem(title: "Security-Hygiene", value: "Belege", systemImage: "checklist.checked", color: .purple),
                ]
            )

            SidebarGroup(
                title: "Buddy",
                items: [
                    SidebarItem(title: "Aktivität", value: "\(presentation.activityItems.count)", systemImage: "sparkles", color: .blue),
                    SidebarItem(title: "Hinweise", value: "\(presentation.findings.count)", systemImage: "bell", color: .indigo),
                    SidebarItem(title: "Systemsignale", value: "\(presentation.reviewCount)", systemImage: "display", color: .cyan),
                ]
            )

            Spacer()
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
        Label("Übersicht", systemImage: "house")
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

private struct CompactSentoNavigation: View {
    let presentation: DashboardPresentation

    var body: some View {
        HStack(spacing: 14) {
            HStack(spacing: 10) {
                SentoMark(size: 34)

                VStack(alignment: .leading, spacing: 1) {
                    Text("Sento Guard")
                        .font(.headline)
                    Text("Lokaler Schutzbuddy")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 8)

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 8) {
                    CompactNavBadge(value: "\(presentation.knownStartupCount)", label: "Autostart", systemImage: "bolt.horizontal.circle", color: .orange)
                    CompactNavBadge(value: "\(presentation.reviewCount)", label: "System", systemImage: "display", color: .cyan)
                    CompactNavBadge(value: "\(presentation.findings.count)", label: "Hinweise", systemImage: "bell", color: .indigo)
                }

                HStack(spacing: 8) {
                    CompactIconBadge(value: "\(presentation.knownStartupCount)", systemImage: "bolt.horizontal.circle", color: .orange)
                    CompactIconBadge(value: "\(presentation.reviewCount)", systemImage: "display", color: .cyan)
                    CompactIconBadge(value: "\(presentation.findings.count)", systemImage: "bell", color: .indigo)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
}

private struct CompactNavBadge: View {
    let value: String
    let label: String
    let systemImage: String
    let color: Color

    var body: some View {
        Label {
            Text("\(value) \(label)")
                .lineLimit(1)
        } icon: {
            Image(systemName: systemImage)
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(color)
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background(color.opacity(0.12), in: Capsule())
    }
}

private struct CompactIconBadge: View {
    let value: String
    let systemImage: String
    let color: Color

    var body: some View {
        Label {
            Text(value)
        } icon: {
            Image(systemName: systemImage)
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(color.opacity(0.12), in: Capsule())
    }
}

private struct BuddyHomeView: View {
    let presentation: DashboardPresentation
    let lastBaselineRefreshError: String?
    let lastUpdateAwarenessRefreshNote: String?
    let isRefreshingUpdateAwarenessSource: Bool
    let hygienePersistenceNote: String?
    let hygieneAnswerError: String?
    let openFinding: (Finding.ID) -> Void
    let recordHygieneAnswer: (SecurityHygieneAnswer, SecurityHygieneCheckID) -> Void
    let rememberCurrentStartupState: () -> Void
    let refreshUpdateAwarenessSource: () -> Void

    var body: some View {
        ZStack {
            BuddyHomeBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SentoTopBar(
                        isRefreshingUpdateAwarenessSource: isRefreshingUpdateAwarenessSource,
                        refreshUpdateAwarenessSource: refreshUpdateAwarenessSource
                    )

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

                    if let lastUpdateAwarenessRefreshNote {
                        UpdateAwarenessRefreshBanner(note: lastUpdateAwarenessRefreshNote)
                    }

                    MissionSection(
                        missions: presentation.missions,
                        openFinding: openFinding
                    )

                    HygieneOverviewSection(items: presentation.hygieneOverviewItems)

                    GuidedHygieneQuestionSection(
                        questions: presentation.guidedHygieneQuestions,
                        persistenceNote: hygienePersistenceNote,
                        answerError: hygieneAnswerError,
                        recordAnswer: recordHygieneAnswer
                    )

                    ActivityFeedSection(
                        items: presentation.activityItems,
                        openFinding: openFinding
                    )

                    SentoLocalPromiseCard()

                    VisibilityNote(text: presentation.visibilityText)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 24)
                .frame(maxWidth: 1180, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
    }
}

private struct SentoTopBar: View {
    let isRefreshingUpdateAwarenessSource: Bool
    let refreshUpdateAwarenessSource: () -> Void

    var body: some View {
        ViewThatFits(in: .horizontal) {
            regularLayout

            compactLayout
        }
    }

    private var regularLayout: some View {
        HStack {
            Spacer()

            localCheckLabel("Lokaler Check bereit")

            updateAwarenessButton(
                Label(
                    isRefreshingUpdateAwarenessSource ? "SOFA wird geladen" : "SOFA-Stand aktualisieren",
                    systemImage: isRefreshingUpdateAwarenessSource ? "hourglass" : "arrow.clockwise"
                )
            )

            notificationButton

            settingsButton
        }
    }

    private var compactLayout: some View {
        HStack {
            Spacer()

            localCheckLabel("Lokal")

            updateAwarenessButton(
                Image(systemName: isRefreshingUpdateAwarenessSource ? "hourglass" : "arrow.clockwise")
            )

            notificationButton

            settingsButton
        }
    }

    private func localCheckLabel(_ text: String) -> some View {
        Label(text, systemImage: "circle.fill")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.blue)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }

    private func updateAwarenessButton<LabelContent: View>(_ label: LabelContent) -> some View {
        Button(action: refreshUpdateAwarenessSource) {
            label
        }
        .buttonStyle(.bordered)
        .disabled(isRefreshingUpdateAwarenessSource)
        .help("Lädt den öffentlichen macOS-Update-Stand bewusst online und speichert ihn lokal.")
    }

    private var notificationButton: some View {
        Button {
        } label: {
            Image(systemName: "bell")
        }
        .buttonStyle(.bordered)
        .disabled(true)
    }

    private var settingsButton: some View {
        SettingsLink {
            Image(systemName: "gearshape")
        }
        .buttonStyle(.bordered)
    }
}

private struct UpdateAwarenessRefreshBanner: View {
    let note: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "arrow.clockwise.circle.fill")
                .font(.title3)
                .foregroundStyle(.cyan)
                .frame(width: 32, height: 32)
                .background(.cyan.opacity(0.14), in: RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 5) {
                Text("SOFA-Stand aktualisiert")
                    .font(.headline)

                Text("Sento hat den öffentlichen macOS-Update-Stand geladen, lokal gespeichert und neu mit deiner sichtbaren macOS-Version verglichen.")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(note)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Es wurde nichts installiert und keine Systemeinstellung geändert.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.cyan.opacity(0.20))
        )
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
                description: Text("Die lokalen Sensoren bleiben ruhig, solange sie keine Hinweise anzeigen müssen.")
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let selectedFinding = findings.first(where: { $0.id == selection }) ?? findings.first {
            VStack(spacing: 0) {
                HStack {
                    Text("Details")
                        .font(.headline)
                    Spacer()
                    Button("Schließen", action: close)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.thinMaterial)

                Divider()

                FindingDetailView(finding: selectedFinding)
            }
        } else {
            ContentUnavailableView(
                "Hinweis auswählen",
                systemImage: "shield",
                description: Text("Wähle links einen Hinweis aus, um Einordnung, Belege und sichere nächste Schritte zu sehen.")
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct GuardianStatusCard: View {
    let presentation: DashboardPresentation
    let primaryAction: () -> Void
    @State private var availableWidth: CGFloat = 0

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
        Group {
            if availableWidth > 0 && availableWidth < 780 {
                compactLayout
            } else {
                regularLayout
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .background(toneColor.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        availableWidth = proxy.size.width
                    }
                    .onChange(of: proxy.size.width) { _, newWidth in
                        availableWidth = newWidth
                    }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(toneColor.opacity(0.32), lineWidth: 1)
        )
        .shadow(color: toneColor.opacity(0.18), radius: 22, x: 0, y: 12)
    }

    private var regularLayout: some View {
        HStack(alignment: .center, spacing: 28) {
            SentoCharacterBadge(size: 156)

            heroCopy

            Spacer(minLength: 16)

            metricRow
        }
    }

    private var compactLayout: some View {
        VStack(alignment: .leading, spacing: 22) {
            SentoCharacterBadge(size: 118)

            heroCopy

            metricRow
        }
    }

    private var heroCopy: some View {
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

            ViewThatFits(in: .horizontal) {
                HStack(alignment: .center, spacing: 14) {
                    primaryButton

                    nextStepText
                }

                VStack(alignment: .leading, spacing: 10) {
                    primaryButton

                    nextStepText
                }
            }
        }
        .frame(maxWidth: 480, alignment: .leading)
    }

    private var primaryButton: some View {
        Button(presentation.primaryActionTitle, action: primaryAction)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(toneColor)
            .disabled(presentation.findings.isEmpty)
    }

    private var nextStepText: some View {
        Text(presentation.nextStepText)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .lineLimit(3)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var metricRow: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) {
                metricCards
            }

            VStack(spacing: 10) {
                metricCards
            }
        }
    }

    @ViewBuilder
    private var metricCards: some View {
        DefenseMetric(value: presentation.startupChangeCount, label: "neu", color: .mint)
        DefenseMetric(value: presentation.knownStartupCount, label: "Hinweise", color: .blue)
        DefenseMetric(value: presentation.reviewCount, label: "System", color: .purple)
    }
}

private struct SentoCharacterBadge: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [.cyan.opacity(0.24), .blue.opacity(0.10), .clear],
                        center: .center,
                        startRadius: size * 0.06,
                        endRadius: size * 0.46
                    )
                )
                .frame(width: size * 0.98, height: size * 0.80)
                .offset(y: size * 0.02)

            SentoSpark(size: size * 0.055)
                .fill(.cyan.opacity(0.55))
                .frame(width: size * 0.10, height: size * 0.10)
                .offset(x: -size * 0.34, y: -size * 0.24)

            SentoSpark(size: size * 0.040)
                .fill(.purple.opacity(0.50))
                .frame(width: size * 0.08, height: size * 0.08)
                .offset(x: size * 0.32, y: -size * 0.28)

            Ellipse()
                .fill(.blue.opacity(0.16))
                .frame(width: size * 0.64, height: size * 0.12)
                .offset(y: size * 0.39)

            ZStack {
                SentoCape(size: size)
                    .fill(
                        LinearGradient(
                            colors: [.purple.opacity(0.54), .blue.opacity(0.22)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size * 0.62, height: size * 0.56)
                    .offset(x: -size * 0.18, y: size * 0.14)

                RoundedRectangle(cornerRadius: size * 0.08)
                    .fill(.blue.opacity(0.72))
                    .frame(width: size * 0.09, height: size * 0.22)
                    .offset(x: -size * 0.12, y: size * 0.32)

                RoundedRectangle(cornerRadius: size * 0.08)
                    .fill(.blue.opacity(0.72))
                    .frame(width: size * 0.09, height: size * 0.22)
                    .offset(x: size * 0.12, y: size * 0.32)

                RoundedRectangle(cornerRadius: size * 0.18)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.96), .cyan.opacity(0.28), .blue.opacity(0.22)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size * 0.48, height: size * 0.50)
                    .overlay(
                        RoundedRectangle(cornerRadius: size * 0.18)
                            .stroke(.blue.opacity(0.30), lineWidth: max(1, size * 0.014))
                    )
                    .shadow(color: .cyan.opacity(0.16), radius: size * 0.08, x: 0, y: size * 0.03)
                    .offset(y: size * 0.13)

                RoundedRectangle(cornerRadius: size * 0.24)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.98), .blue.opacity(0.28), .purple.opacity(0.12)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size * 0.58, height: size * 0.42)
                    .overlay(
                        RoundedRectangle(cornerRadius: size * 0.24)
                            .stroke(.cyan.opacity(0.46), lineWidth: max(1, size * 0.018))
                    )
                    .offset(y: -size * 0.15)

                RoundedRectangle(cornerRadius: size * 0.16)
                    .fill(
                        LinearGradient(
                            colors: [.indigo.opacity(0.94), .black.opacity(0.78)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size * 0.40, height: size * 0.19)
                    .overlay(
                        RoundedRectangle(cornerRadius: size * 0.16)
                            .stroke(.cyan.opacity(0.34), lineWidth: max(1, size * 0.008))
                    )
                    .offset(y: -size * 0.14)

                HStack(spacing: size * 0.075) {
                    RoundedRectangle(cornerRadius: size * 0.018)
                        .fill(.cyan)
                        .frame(width: size * 0.07, height: size * 0.055)
                        .shadow(color: .cyan.opacity(0.9), radius: size * 0.03)

                    RoundedRectangle(cornerRadius: size * 0.018)
                        .fill(.cyan)
                        .frame(width: size * 0.07, height: size * 0.055)
                        .shadow(color: .cyan.opacity(0.9), radius: size * 0.03)
                }
                .offset(y: -size * 0.14)

                SentoShield(size: size)
                    .fill(
                        LinearGradient(
                            colors: [.cyan.opacity(0.98), .blue.opacity(0.88), .purple.opacity(0.74)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size * 0.24, height: size * 0.30)
                    .overlay(
                        SentoShield(size: size)
                            .stroke(.white.opacity(0.78), lineWidth: max(1, size * 0.012))
                    )
                    .shadow(color: .blue.opacity(0.24), radius: size * 0.04, x: 0, y: size * 0.025)
                    .offset(x: size * 0.31, y: size * 0.16)

                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: size * 0.13, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .offset(y: size * 0.12)
            }
            .offset(x: -size * 0.03)

            RoundedRectangle(cornerRadius: size * 0.16)
                .stroke(
                    LinearGradient(
                        colors: [.cyan.opacity(0.42), .blue.opacity(0.18), .purple.opacity(0.24)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: max(1, size * 0.010)
                )
                .frame(width: size * 0.76, height: size * 0.82)
                .offset(y: size * 0.02)
                .opacity(0.28)
        }
        .frame(width: size, height: size)
    }
}

private struct SentoSpark: Shape {
    let size: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: CGPoint(x: center.x, y: rect.minY))
        path.addLine(to: CGPoint(x: center.x + size * 0.18, y: center.y - size * 0.18))
        path.addLine(to: CGPoint(x: rect.maxX, y: center.y))
        path.addLine(to: CGPoint(x: center.x + size * 0.18, y: center.y + size * 0.18))
        path.addLine(to: CGPoint(x: center.x, y: rect.maxY))
        path.addLine(to: CGPoint(x: center.x - size * 0.18, y: center.y + size * 0.18))
        path.addLine(to: CGPoint(x: rect.minX, y: center.y))
        path.addLine(to: CGPoint(x: center.x - size * 0.18, y: center.y - size * 0.18))
        path.closeSubpath()
        return path
    }
}

private struct SentoCape: Shape {
    let size: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX * 0.62, y: rect.minY + size * 0.04))
        path.addLine(to: CGPoint(x: rect.minX + size * 0.04, y: rect.maxY - size * 0.02))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - size * 0.10, y: rect.maxY - size * 0.10),
            control: CGPoint(x: rect.midX, y: rect.maxY + size * 0.05)
        )
        path.addLine(to: CGPoint(x: rect.maxX - size * 0.12, y: rect.minY + size * 0.12))
        path.closeSubpath()
        return path
    }
}

private struct SentoShield: Shape {
    let size: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.18))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.10, y: rect.midY))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.maxX - rect.width * 0.14, y: rect.maxY * 0.84)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + rect.width * 0.10, y: rect.midY),
            control: CGPoint(x: rect.minX + rect.width * 0.14, y: rect.maxY * 0.84)
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.18))
        path.closeSubpath()
        return path
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
        .frame(minWidth: 82, maxWidth: .infinity, minHeight: 76, alignment: .leading)
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
                    GridItem(.adaptive(minimum: 190), spacing: 14),
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

    private var isActionable: Bool {
        mission.findingID != nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: mission.systemImage)
                    .font(.title3)
                    .foregroundStyle(accentColor)
                    .frame(width: 34, height: 34)
                    .background(accentColor.opacity(0.16), in: RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(accentColor.opacity(0.22))
                    )

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

            if isActionable {
                Button(mission.primaryActionTitle) {
                    if let findingID = mission.findingID {
                        openFinding(findingID)
                    }
                }
                .buttonStyle(.bordered)
                .tint(accentColor)
            } else {
                Text(mission.primaryActionTitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(accentColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(accentColor.opacity(0.10), in: RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(accentColor.opacity(0.14))
                    )
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 214, alignment: .topLeading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .background(accentColor.opacity(0.085), in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(accentColor.opacity(0.34))
        )
        .shadow(color: accentColor.opacity(0.08), radius: 12, x: 0, y: 8)
    }
}

private struct SentoLocalPromiseCard: View {
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .center, spacing: 22) {
                SentoCharacterBadge(size: 112)
                promiseText
                Spacer()
            }

            VStack(alignment: .leading, spacing: 14) {
                SentoCharacterBadge(size: 92)
                promiseText
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.cyan.opacity(0.16))
        )
    }

    private var promiseText: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ich bleibe lokal")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Aktuell prüfe ich lokale Hinweise beim Start und zeige dir ruhig, was ich einordnen kann.")
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
    }
}

private struct HygieneOverviewSection: View {
    let items: [HygieneOverviewItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Sicherheitsgewohnheiten",
                subtitle: "Sento sortiert, was er selbst sehen kann und wobei er dich später bewusst fragt."
            )

            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 220), spacing: 14),
                ],
                spacing: 14
            ) {
                ForEach(items) { item in
                    HygieneOverviewCard(item: item)
                }
            }
        }
    }
}

private struct HygieneOverviewCard: View {
    let item: HygieneOverviewItem

    private var accentColor: Color {
        switch item.id {
        case SecurityHygieneEvidenceKind.observedLocally.rawValue:
            return .green
        case SecurityHygieneEvidenceKind.userAnswered.rawValue:
            return .purple
        case SecurityHygieneEvidenceKind.notVerifiable.rawValue:
            return .secondary
        default:
            return .cyan
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Circle()
                    .fill(accentColor.opacity(0.22))
                    .frame(width: 10, height: 10)
                    .padding(.top, 5)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)

                    Text(item.explanation)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            VStack(alignment: .leading, spacing: 7) {
                ForEach(item.checks) { check in
                    ViewThatFits(in: .horizontal) {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            checkTitle(check)
                            Spacer(minLength: 8)
                            statusBadge(check.status)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            checkTitle(check)
                            statusBadge(check.status)
                        }
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(accentColor.opacity(0.16))
        )
    }

    private func checkTitle(_ check: HygieneCheckStatus) -> some View {
        Text(check.title)
            .font(.caption)
            .foregroundStyle(.primary)
            .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private func statusBadge(_ status: String?) -> some View {
        if let status {
            Text(status)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(accentColor)
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(accentColor.opacity(0.12), in: Capsule())
        }
    }
}

private struct GuidedHygieneQuestionSection: View {
    let questions: [GuidedHygieneQuestion]
    let persistenceNote: String?
    let answerError: String?
    let recordAnswer: (SecurityHygieneAnswer, SecurityHygieneCheckID) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Buddy-Fragen",
                subtitle: "Sento fragt nur dort nach, wo er lokal nicht ehrlich prüfen kann."
            )

            HygieneQuestionProgressNote(
                answeredCount: questions.filter { $0.answer != nil }.count,
                totalCount: questions.count
            )

            if let persistenceNote {
                HygieneQuestionNote(text: persistenceNote, color: .orange)
            }

            if let answerError {
                HygieneQuestionNote(text: answerError, color: .orange)
            }

            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 250), spacing: 14),
                ],
                spacing: 14
            ) {
                ForEach(questions) { question in
                    GuidedHygieneQuestionCard(
                        question: question,
                        recordAnswer: recordAnswer
                    )
                }
            }
        }
    }
}

private struct GuidedHygieneQuestionCard: View {
    let question: GuidedHygieneQuestion
    let recordAnswer: (SecurityHygieneAnswer, SecurityHygieneCheckID) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "questionmark.bubble")
                    .font(.headline)
                    .foregroundStyle(.purple)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 4) {
                    Text(question.title)
                        .font(.headline)

                    Text(question.question)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Text(question.boundary)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Label(question.reason, systemImage: "lightbulb")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 8) {
                    answerButtons
                }

                VStack(alignment: .leading, spacing: 8) {
                    answerButtons
                }
            }

            if let answer = question.answer {
                Label(answer.statusTitle, systemImage: "checkmark.circle.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.purple)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.purple.opacity(0.16))
        )
    }

    @ViewBuilder
    private var answerButtons: some View {
        ForEach(SecurityHygieneAnswer.allCases, id: \.self) { answer in
            Button(answer.title) {
                recordAnswer(answer, question.id)
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .tint(question.answer == answer ? .purple : .secondary)
        }
    }
}

private struct HygieneQuestionProgressNote: View {
    let answeredCount: Int
    let totalCount: Int

    var body: some View {
        Label(progressText, systemImage: "lock.doc")
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.purple.opacity(0.12))
            )
    }

    private var progressText: String {
        if totalCount == 0 {
            return "Aktuell gibt es keine offenen Buddy-Fragen."
        }

        if answeredCount == 0 {
            return "Noch keine Antwort gespeichert. Deine Antworten bleiben lokal und sind keine automatische Prüfung."
        }

        return "\(answeredCount) von \(totalCount) Antworten lokal gespeichert. Du kannst später weiter ergänzen."
    }
}

private struct HygieneQuestionNote: View {
    let text: String
    let color: Color

    var body: some View {
        Label(text, systemImage: "exclamationmark.circle")
            .font(.caption)
            .foregroundStyle(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color.opacity(0.10), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct ActivityFeedSection: View {
    let items: [BuddyActivityItem]
    let openFinding: (Finding.ID) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(
                title: "Buddy-Aktivität",
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
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: 12) {
                rowIcon
                rowText
                Spacer()
                detailsButton
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 12) {
                    rowIcon
                    rowText
                }
                detailsButton
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

    private var rowIcon: some View {
        Image(systemName: item.systemImage)
            .foregroundStyle(accentColor)
            .frame(width: 28, height: 28)
            .background(accentColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
    }

    private var rowText: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .font(.headline)

            Text(item.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private var detailsButton: some View {
        if let findingID = item.findingID {
            Button("Details") {
                openFinding(findingID)
            }
            .buttonStyle(.bordered)
        }
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
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .center, spacing: 12) {
                    bannerText
                    Spacer()
                    confirmButton
                }

                VStack(alignment: .leading, spacing: 10) {
                    bannerText
                    confirmButton
                }
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

    private var bannerText: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Autostart-Änderungen sichtbar")
                .font(.headline)
            Text("Wenn diese Änderungen erwartet sind, kannst du den aktuellen Zustand merken. Die App bleibt dann beim nächsten Lauf ruhiger.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var confirmButton: some View {
        Button("Als erwartet merken", action: onConfirm)
            .buttonStyle(.borderedProminent)
    }
}
