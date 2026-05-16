import Foundation

enum FindingSeverity: String, Codable, CaseIterable, Comparable, Sendable {
    case low
    case medium
    case high

    static func < (lhs: FindingSeverity, rhs: FindingSeverity) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }

    private var sortOrder: Int {
        switch self {
        case .low:
            return 0
        case .medium:
            return 1
        case .high:
            return 2
        }
    }

    var title: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }

    var policyRisk: PolicyRisk {
        switch self {
        case .low:
            return .low
        case .medium:
            return .medium
        case .high:
            return .high
        }
    }
}

enum FindingConfidence: String, Codable, CaseIterable, Sendable {
    case tentative
    case supported
    case strong

    var title: String {
        switch self {
        case .tentative:
            return "Tentative"
        case .supported:
            return "Supported"
        case .strong:
            return "Strong"
        }
    }
}

enum FindingSourceKind: String, Codable, CaseIterable, Sendable {
    case baselineDiff
    case launchAgentInventory
    case privacyPermissions
    case systemInventory
    case updateAwareness

    var title: String {
        switch self {
        case .baselineDiff:
            return "Changed Since Remembered State"
        case .launchAgentInventory:
            return "Launch Agent Inventory"
        case .privacyPermissions:
            return "Privacy Permissions"
        case .systemInventory:
            return "System Inventory"
        case .updateAwareness:
            return "Update Awareness"
        }
    }
}

struct FindingSource: Hashable, Codable, Sendable {
    let kind: FindingSourceKind
    let title: String
    let detail: String
}

struct FindingEvidence: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let summary: String
    let detail: String
}

struct FindingRecommendation: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let explanation: String
    let action: PolicyAction
}

struct Finding: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let source: FindingSource
    let severity: FindingSeverity
    let confidence: FindingConfidence
    let summary: String
    let userImpact: String
    let nextStep: String
    let evidence: [FindingEvidence]
    let recommendations: [FindingRecommendation]

    func policyRequest(for recommendation: FindingRecommendation) -> PolicyRequest {
        PolicyRequest(
            action: recommendation.action,
            subject: PolicySubject(
                kind: "finding",
                identifier: id,
                displayName: title
            ),
            risk: severity.policyRisk,
            reason: recommendation.explanation,
            evidenceSummary: evidenceSummary
        )
    }

    private var evidenceSummary: String {
        let lines = evidence.map(\.summary)
        return lines.isEmpty ? summary : lines.joined(separator: " ")
    }
}
