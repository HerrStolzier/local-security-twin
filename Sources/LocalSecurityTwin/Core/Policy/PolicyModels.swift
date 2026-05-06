import Foundation

enum PolicyRisk: Int, Codable, CaseIterable, Comparable, Sendable {
    case low
    case medium
    case high

    static func < (lhs: PolicyRisk, rhs: PolicyRisk) -> Bool {
        lhs.rawValue < rhs.rawValue
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
}

enum PolicyDecision: String, Codable, CaseIterable, Sendable {
    case allow
    case deny

    var title: String {
        switch self {
        case .allow:
            return "Allowed"
        case .deny:
            return "Denied"
        }
    }
}

enum PolicyPersistenceScope: String, Codable, CaseIterable, Sendable {
    case session
    case remembered

    var title: String {
        switch self {
        case .session:
            return "This Session"
        case .remembered:
            return "Remembered"
        }
    }
}

enum PolicyConfirmationRequirement: String, Codable, CaseIterable, Comparable, Sendable {
    case standard
    case explicitApproval

    static func < (lhs: PolicyConfirmationRequirement, rhs: PolicyConfirmationRequirement) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }

    private var sortOrder: Int {
        switch self {
        case .standard:
            return 0
        case .explicitApproval:
            return 1
        }
    }

    var title: String {
        switch self {
        case .standard:
            return "Standard Confirmation"
        case .explicitApproval:
            return "Explicit Confirmation"
        }
    }
}

enum PolicyDecisionSource: String, Codable, Sendable {
    case session
    case remembered
}

struct PolicyAction: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let explanation: String
    let minimumConfirmation: PolicyConfirmationRequirement
}

extension PolicyAction {
    static let openSensitiveSettings = PolicyAction(
        id: "open-sensitive-settings",
        title: "Open Sensitive Settings",
        explanation: "Open a sensitive system settings area so the user can review access.",
        minimumConfirmation: .standard
    )

    static let trustItem = PolicyAction(
        id: "trust-item",
        title: "Trust Item",
        explanation: "Remember that a specific item is expected and should stay calmer in future views.",
        minimumConfirmation: .standard
    )

    static let runSafeValidation = PolicyAction(
        id: "run-safe-validation",
        title: "Run Safe Validation",
        explanation: "Run a tightly bounded validation step that checks whether a concern is real.",
        minimumConfirmation: .explicitApproval
    )
}

struct PolicySubject: Hashable, Codable, Sendable {
    let kind: String
    let identifier: String
    let displayName: String
}

struct PolicyKey: Hashable, Codable, Sendable {
    let actionID: String
    let subjectKind: String
    let subjectID: String
}

struct PolicyRequest: Hashable, Codable, Identifiable, Sendable {
    let action: PolicyAction
    let subject: PolicySubject
    let risk: PolicyRisk
    let reason: String
    let evidenceSummary: String

    var id: String {
        "\(key.actionID)::\(key.subjectKind)::\(key.subjectID)"
    }

    var key: PolicyKey {
        PolicyKey(
            actionID: action.id,
            subjectKind: subject.kind,
            subjectID: subject.identifier
        )
    }

    var confirmationRequirement: PolicyConfirmationRequirement {
        max(action.minimumConfirmation, risk >= .high ? .explicitApproval : .standard)
    }
}

struct PolicyRecord: Identifiable, Hashable, Codable, Sendable {
    let key: PolicyKey
    let actionTitle: String
    let actionExplanation: String
    let subjectName: String
    let decision: PolicyDecision
    let scope: PolicyPersistenceScope
    let risk: PolicyRisk
    let reason: String
    let evidenceSummary: String
    let createdAt: Date
    let updatedAt: Date

    var id: String {
        "\(key.actionID)::\(key.subjectKind)::\(key.subjectID)"
    }
}

enum PolicyResolution: Equatable, Sendable {
    case needsConsent(PolicyConfirmationRequirement)
    case allowed(PolicyDecisionSource)
    case denied(PolicyDecisionSource)
}

enum PolicyStoreError: LocalizedError, Equatable {
    case explicitConfirmationRequired(actionTitle: String)

    var errorDescription: String? {
        switch self {
        case .explicitConfirmationRequired(let actionTitle):
            return "\(actionTitle) needs an explicit confirmation because the request is high risk."
        }
    }
}
