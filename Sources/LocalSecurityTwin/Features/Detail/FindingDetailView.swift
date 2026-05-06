import SwiftUI

struct FindingDetailView: View {
    @EnvironmentObject private var policyStore: PolicyStore
    let finding: Finding

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(finding.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack(spacing: 12) {
                        Label(finding.source.title, systemImage: "dot.scope")
                        Label(finding.severity.title, systemImage: "shield")
                        Label(finding.confidence.title, systemImage: "checkmark.seal")
                    }
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                }

                FindingSection(title: "What happened", text: finding.summary)
                FindingSection(title: "Why it matters", text: finding.userImpact)
                FindingSection(title: "What to do next", text: finding.nextStep)
                EvidenceSection(evidence: finding.evidence)
                RecommendationSection(
                    finding: finding,
                    policyStore: policyStore
                )

                VStack(alignment: .leading, spacing: 10) {
                    Text("Product note")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("This placeholder detail view represents the future explain-before-action flow. Real findings should always carry evidence, plain-language context, and a safe action path.")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(28)
        }
        .navigationTitle(finding.title)
    }
}

private struct EvidenceSection: View {
    let evidence: [FindingEvidence]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Evidence")
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
            Text("Recommended actions")
                .font(.title3)
                .fontWeight(.semibold)

            Text("These controls currently record local trust decisions only. They do not run the real action yet.")
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
                Button("Allow Once") {
                    record(.allow, scope: .session)
                }

                Button("Remember Allow") {
                    record(.allow, scope: .remembered)
                }

                Button("Remember Deny") {
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
            return "Ask First"
        case .needsConsent(.explicitApproval):
            return "Needs Explicit Approval"
        case .allowed(.session):
            return "Allowed This Session"
        case .allowed(.remembered):
            return "Remembered Allow"
        case .denied(.session):
            return "Denied This Session"
        case .denied(.remembered):
            return "Remembered Deny"
        }
    }

    private var requirementText: String {
        switch request.confirmationRequirement {
        case .standard:
            return "This is a standard-risk guided action."
        case .explicitApproval:
            return "This is a high-risk guided action and should always be treated as an explicit user choice."
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
