import SwiftUI

struct FindingDetailView: View {
    @EnvironmentObject private var policyStore: PolicyStore
    let finding: Finding

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(finding.displayTitle)
                        .font(.title)
                        .fontWeight(.semibold)

                    HStack(spacing: 12) {
                        Label(finding.displaySourceTitle, systemImage: "dot.scope")
                        Label(finding.severity.displayTitle, systemImage: "shield")
                        Label(finding.confidence.displayTitle, systemImage: "checkmark.seal")
                    }
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                }

                DetailGuidancePanel(finding: finding)

                if finding.source.kind == .baselineDiff || finding.source.kind == .launchAgentInventory {
                    StartupDetailOverview(finding: finding)
                }

                FindingSection(title: "Was wurde gefunden?", text: finding.displaySummary)
                EvidenceSection(evidence: finding.evidence)
                RecommendationSection(
                    finding: finding,
                    policyStore: policyStore
                )

                VStack(alignment: .leading, spacing: 10) {
                    Text("Produkt-Hinweis")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("Diese Ansicht erklaert zuerst, was sichtbar ist. Sie aendert keine Systemeinstellungen und beweist nicht, dass ein Hinweis gefaehrlich ist.")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(28)
        }
        .navigationTitle(finding.displayTitle)
    }
}

private struct DetailGuidancePanel: View {
    let finding: Finding

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            DetailGuidanceItem(
                title: "Kurz gesagt",
                text: finding.plainLanguageAssessment,
                systemImage: "text.bubble"
            )

            DetailGuidanceItem(
                title: "Warum das wichtig ist",
                text: finding.userImpact,
                systemImage: "questionmark.circle"
            )

            DetailGuidanceItem(
                title: "Naechster sicherer Schritt",
                text: finding.nextStep,
                systemImage: "checkmark.seal"
            )
        }
        .padding(16)
        .background(.quinary, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct DetailGuidanceItem: View {
    let title: String
    let text: String
    let systemImage: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(.secondary)
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 4) {
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

private struct StartupDetailOverview: View {
    let finding: Finding

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Autostart kurz erklaert")
                .font(.title3)
                .fontWeight(.semibold)

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

            Text("Das sind Belege aus einer sichtbaren plist-Datei. Sie zeigen, was macOS verwenden kann, aber nicht, ob der Dienst gerade aktiv laeuft.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary)
        )
    }
}

private struct StartupDetailLine: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .frame(width: 150, alignment: .leading)

            Text(value)
                .font(.subheadline)
                .textSelection(.enabled)
        }
    }
}

private struct EvidenceSection: View {
    let evidence: [FindingEvidence]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Belege")
                .font(.title3)
                .fontWeight(.semibold)

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
        }
    }
}

private struct RecommendationSection: View {
    let finding: Finding
    let policyStore: PolicyStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Empfohlene Schritte")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Diese Schaltflaechen speichern aktuell nur lokale Entscheidungen. Sie fuehren noch keine echte Systemaktion aus.")
                .foregroundStyle(.secondary)

            ForEach(finding.recommendations) { recommendation in
                RecommendationCard(
                    recommendation: recommendation,
                    request: finding.policyRequest(for: recommendation),
                    policyStore: policyStore
                )
            }
        }
    }
}

private struct RecommendationCard: View {
    let recommendation: FindingRecommendation
    let request: PolicyRequest
    let policyStore: PolicyStore

    @State private var localError: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(recommendation.title)
                        .font(.headline)
                    Text(recommendation.explanation)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(statusText)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.quaternary, in: Capsule())
            }

            Text(requirementText)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                Button("Einmal erlauben") {
                    record(.allow, scope: .session)
                }

                Button("Merken: erlauben") {
                    record(.allow, scope: .remembered)
                }

                Button("Merken: ablehnen") {
                    record(.deny, scope: .remembered)
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
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary)
        )
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
            return "Das ist ein normaler gefuehrter Schritt."
        case .explicitApproval:
            return "Dieser Schritt braucht eine bewusste Zustimmung."
        }
    }

    private func record(_ decision: PolicyDecision, scope: PolicyPersistenceScope) {
        do {
            try policyStore.record(
                decision: decision,
                for: request,
                scope: scope,
                explicitConfirmation: scope == .remembered
            )
            localError = nil
        } catch {
            localError = error.localizedDescription
        }
    }
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
