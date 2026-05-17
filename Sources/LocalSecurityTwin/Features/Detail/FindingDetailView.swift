import SwiftUI

struct FindingDetailView: View {
    @EnvironmentObject private var policyStore: PolicyStore
    let finding: Finding
    @State private var availableWidth: CGFloat = 0

    private var accentColor: Color {
        switch finding.displayGroup {
        case .changes:
            return .orange
        case .knownStartupHints:
            return .cyan
        case .review:
            return .purple
        }
    }

    var body: some View {
        ZStack {
            DetailBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    DetailHeroCard(finding: finding, accentColor: accentColor)

                    DetailGuidancePanel(finding: finding, accentColor: accentColor)

                    if finding.source.kind == .baselineDiff || finding.source.kind == .launchAgentInventory {
                        StartupSimpleOverview(finding: finding, accentColor: accentColor)
                    }

                    RecommendationSection(
                        finding: finding,
                        policyStore: policyStore,
                        accentColor: accentColor
                    )
                    TechnicalDetailSection(finding: finding, accentColor: accentColor)
                }
                .padding(detailPadding)
                .frame(maxWidth: 920, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
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
    }

    private var detailPadding: CGFloat {
        availableWidth > 0 && availableWidth < 640 ? 18 : 28
    }
}

private struct DetailBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.cyan.opacity(0.08),
                Color.purple.opacity(0.06),
                Color(nsColor: .windowBackgroundColor),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

private struct DetailHeroCard: View {
    let finding: Finding
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.title2)
                    .foregroundStyle(accentColor)
                    .frame(width: 44, height: 44)
                    .background(accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 6) {
                    Text("Buddy-Check")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(accentColor)

                    Text(finding.displayTitle)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            DetailStatusRow(finding: finding, accentColor: accentColor)
        }
        .padding(18)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .background(accentColor.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(accentColor.opacity(0.24))
        )
    }
}

private struct DetailStatusRow: View {
    let finding: Finding
    let accentColor: Color

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) {
                detailPills
            }

            VStack(alignment: .leading, spacing: 8) {
                detailPills
            }
        }
    }

    @ViewBuilder
    private var detailPills: some View {
        DetailPill(text: finding.displaySourceTitle, systemImage: "dot.scope", color: accentColor)
        DetailPill(text: finding.severity.displayTitle, systemImage: "shield", color: accentColor)
        DetailPill(text: finding.confidence.displayTitle, systemImage: "checkmark.seal", color: accentColor)
    }
}

private struct DetailPill: View {
    let text: String
    let systemImage: String
    let color: Color

    var body: some View {
        Label(text, systemImage: systemImage)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(color.opacity(0.12), in: Capsule())
    }
}

private struct DetailGuidancePanel: View {
    let finding: Finding
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Kurz gesagt", systemImage: "text.bubble")
                .font(.headline)
                .foregroundStyle(accentColor)

            Text(finding.plainLanguageAssessment)
                .font(.title3)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Label("Was du jetzt tun solltest", systemImage: "checkmark.seal")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(finding.nextStep)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .background(accentColor.opacity(0.06), in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(accentColor.opacity(0.18))
        )
    }
}

private struct StartupSimpleOverview: View {
    let finding: Finding
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Was heißt das für dich?")
                .font(.title3)
                .fontWeight(.semibold)

            SimpleFactRow(
                systemImage: "app.badge",
                title: "Erkannte Datei",
                text: finding.displaySubject
            )

            SimpleFactRow(
                systemImage: "arrow.clockwise",
                title: "Bedeutung",
                text: "Diese Datei kann macOS sagen, dass etwas automatisch im Hintergrund starten darf."
            )

            SimpleFactRow(
                systemImage: "shield",
                title: "Wichtig",
                text: "Das ist ein Hinweis, kein Alarm. Neu oder unerwartet wäre wichtiger als nur sichtbar."
            )
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .background(accentColor.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(accentColor.opacity(0.16))
        )
    }
}

private struct SimpleFactRow: View {
    let systemImage: String
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(.secondary)
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct StartupTechnicalOverview: View {
    let finding: Finding

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            StartupDetailLine(label: "Datei", value: finding.displaySubject)

            if let label = finding.startupLabel {
                StartupDetailLine(label: "Interner Name", value: label)
            }

            if let program = finding.startupProgram {
                StartupDetailLine(label: "Programm", value: program)
            } else if let arguments = finding.startupProgramArguments {
                StartupDetailLine(label: "Startbefehl", value: arguments)
            }

            if let runAtLoad = finding.startupRunAtLoadText {
                StartupDetailLine(label: "Startverhalten", value: runAtLoad)
            }

            if let keepAlive = finding.startupKeepAliveText {
                StartupDetailLine(label: "Hintergrundverhalten", value: keepAlive)
            }

            if let path = finding.startupFilePath {
                StartupDetailLine(label: "Pfad", value: path)
            }
        }
    }
}

private struct StartupDetailLine: View {
    let label: String
    let value: String

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                labelText
                    .frame(width: 150, alignment: .leading)

                valueText
            }

            VStack(alignment: .leading, spacing: 4) {
                labelText
                valueText
            }
        }
    }

    private var labelText: some View {
        Text(label)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
    }

    private var valueText: some View {
        Text(value)
            .font(.subheadline)
            .textSelection(.enabled)
            .fixedSize(horizontal: false, vertical: true)
    }
}

private struct EvidenceSection: View {
    let evidence: [FindingEvidence]

    var body: some View {
        DisclosureGroup {
            ForEach(evidence) { item in
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.displayTitle)
                        .font(.headline)
                    Text(item.displaySummary)
                    Text(item.displayDetail)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                .padding(14)
                .background(.background, in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.quaternary)
                )
            }
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text("Technische Belege")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Aufklappen, wenn du Pfade, plist-Details und Rohbelege sehen willst.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct TechnicalDetailSection: View {
    let finding: Finding
    let accentColor: Color

    var body: some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 16) {
                FindingSection(title: "Was wurde gefunden?", text: finding.displaySummary)

                if finding.source.kind == .baselineDiff || finding.source.kind == .launchAgentInventory {
                    StartupTechnicalOverview(finding: finding)
                }

                EvidenceSection(evidence: finding.evidence)

                Text("Diese technischen Daten sind nur Belege. Sie beweisen nicht, dass etwas gefährlich ist oder gerade aktiv läuft.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 8)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text("Technische Details")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Nur öffnen, wenn du Pfade, plist-Daten und Rohbelege sehen willst.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(accentColor.opacity(0.14))
        )
    }
}

private struct RecommendationSection: View {
    let finding: Finding
    let policyStore: PolicyStore
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nächster Schritt")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Die App führt dich erst durch eine bewusste Entscheidung. Sie ändert dabei keine Systemeinstellungen.")
                .foregroundStyle(.secondary)

            if let primaryRecommendation = finding.recommendations.first {
                RecommendationCard(
                    recommendation: primaryRecommendation,
                    request: finding.policyRequest(for: primaryRecommendation),
                    policyStore: policyStore,
                    accentColor: accentColor
                )
            }

            let remainingRecommendations = Array(finding.recommendations.dropFirst())
            if !remainingRecommendations.isEmpty {
                DisclosureGroup("Weitere mögliche Schritte") {
                    ForEach(remainingRecommendations) { recommendation in
                        RecommendationCard(
                            recommendation: recommendation,
                            request: finding.policyRequest(for: recommendation),
                            policyStore: policyStore,
                            accentColor: accentColor
                        )
                    }
                }
            }
        }
    }
}

private struct RecommendationCard: View {
    let recommendation: FindingRecommendation
    let request: PolicyRequest
    let policyStore: PolicyStore
    let accentColor: Color

    @State private var localError: String?
    @State private var pendingDecision: PendingPolicyDecision?
    @State private var isShowingConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 12) {
                    recommendationText

                    Spacer()

                    statusBadge
                }

                VStack(alignment: .leading, spacing: 8) {
                    recommendationText
                    statusBadge
                }
            }

            Text(requirementText)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(request.action.kind.consentSummary)
                .font(.caption)
                .foregroundStyle(.secondary)

            ViewThatFits(in: .horizontal) {
                HStack {
                    decisionButtons
                }

                VStack(alignment: .leading, spacing: 8) {
                    decisionButtons
                }
            }
            .buttonStyle(.bordered)

            if let localError {
                Text(localError)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .background(accentColor.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(accentColor.opacity(0.16))
        )
        .confirmationDialog(
            confirmationTitle,
            isPresented: $isShowingConfirmation,
            titleVisibility: .visible
        ) {
            Button("Bestätigen") {
                if let pendingDecision {
                    record(pendingDecision.decision, scope: pendingDecision.scope)
                }
                pendingDecision = nil
            }

            Button("Abbrechen", role: .cancel) {
                pendingDecision = nil
            }
        } message: {
            if let pendingDecision {
                Text(confirmationMessage(for: pendingDecision))
            }
        }
    }

    private var recommendationText: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(recommendation.title)
                .font(.headline)
            Text(recommendation.explanation)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var statusBadge: some View {
        Text(statusText)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(.quaternary, in: Capsule())
    }

    @ViewBuilder
    private var decisionButtons: some View {
        Button("Einmal erlauben") {
            pendingDecision = PendingPolicyDecision(decision: .allow, scope: .session)
            isShowingConfirmation = true
        }

        Button("Merken: erlauben") {
            pendingDecision = PendingPolicyDecision(decision: .allow, scope: .remembered)
            isShowingConfirmation = true
        }

        Button("Merken: ablehnen") {
            pendingDecision = PendingPolicyDecision(decision: .deny, scope: .remembered)
            isShowingConfirmation = true
        }
    }

    private var statusText: String {
        switch policyStore.resolution(for: request) {
        case .needsConsent(.standard):
            return "Fragt zuerst"
        case .needsConsent(.explicitApproval):
            return "Braucht Zustimmung"
        case .allowed(.session):
            return "Diese Sitzung erlaubt"
        case .allowed(.remembered):
            return "Erlaubnis gemerkt"
        case .denied(.session):
            return "Diese Sitzung abgelehnt"
        case .denied(.remembered):
            return "Ablehnung gemerkt"
        }
    }

    private var requirementText: String {
        switch request.confirmationRequirement {
        case .standard:
            return "Das ist ein normaler geführter Schritt. Er passiert erst nach deiner Bestätigung."
        case .explicitApproval:
            return "Dieser Schritt braucht eine bewusste Zustimmung, weil er mehr Belege sammeln könnte."
        }
    }

    private var confirmationTitle: String {
        "Schritt bestätigen?"
    }

    private func confirmationMessage(for pendingDecision: PendingPolicyDecision) -> String {
        let persistenceText =
            pendingDecision.scope == .remembered
            ? "Diese Entscheidung wird lokal gespeichert und kann in den Einstellungen wieder gelöscht werden."
            : "Diese Entscheidung gilt nur für diese Sitzung."

        return "\(request.action.kind.consentSummary) \(persistenceText) Die App ändert dabei keine Systemeinstellungen."
    }

    private func record(_ decision: PolicyDecision, scope: PolicyPersistenceScope) {
        do {
            try policyStore.record(
                decision: decision,
                for: request,
                scope: scope,
                explicitConfirmation: request.confirmationRequirement == .explicitApproval
            )
            localError = nil
        } catch {
            localError = error.localizedDescription
        }
    }
}

private struct PendingPolicyDecision: Identifiable {
    let id = UUID()
    let decision: PolicyDecision
    let scope: PolicyPersistenceScope
}

private struct FindingSection: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(text)
                .foregroundStyle(.secondary)
        }
    }
}
