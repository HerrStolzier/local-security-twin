import SwiftUI

struct FindingDetailView: View {
    @EnvironmentObject private var policyStore: PolicyStore
    let finding: Finding

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(finding.displayTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack(spacing: 12) {
                        Label(finding.displaySourceTitle, systemImage: "dot.scope")
                        Label(finding.severity.displayTitle, systemImage: "shield")
                        Label(finding.confidence.displayTitle, systemImage: "checkmark.seal")
                    }
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                }

                FindingSection(title: "Kurze Einordnung", text: finding.plainLanguageAssessment)
                FindingSection(title: "Was wurde gefunden?", text: finding.displaySummary)
                FindingSection(title: "Warum ist das wichtig?", text: finding.userImpact)
                FindingSection(title: "Naechster sicherer Schritt", text: finding.nextStep)
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

private struct EvidenceSection: View {
    let evidence: [FindingEvidence]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Belege")
                .font(.title3)
                .fontWeight(.semibold)

            ForEach(evidence) { item in
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.summary)
                    Text(item.detail)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                .padding(14)
                .background(.quinary, in: RoundedRectangle(cornerRadius: 12))
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
        .background(.quinary, in: RoundedRectangle(cornerRadius: 12))
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
