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
            return "Niedrig"
        case .medium:
            return "Mittel"
        case .high:
            return "Erhoeht"
        }
    }
}

enum PolicyDecision: String, Codable, CaseIterable, Sendable {
    case allow
    case deny

    var title: String {
        switch self {
        case .allow:
            return "Erlaubt"
        case .deny:
            return "Abgelehnt"
        }
    }
}

enum PolicyPersistenceScope: String, Codable, CaseIterable, Sendable {
    case session
    case remembered

    var title: String {
        switch self {
        case .session:
            return "Diese Sitzung"
        case .remembered:
            return "Lokal gemerkt"
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
            return "Normale Bestaetigung"
        case .explicitApproval:
            return "Bewusste Zustimmung"
        }
    }
}

enum PolicyDecisionSource: String, Codable, Sendable {
    case session
    case remembered
}

enum PolicyActionKind: String, Codable, CaseIterable, Sendable {
    case rememberLocalDecision
    case openExternalLocation
    case showGuidance
    case gatherEvidence

    var title: String {
        switch self {
        case .rememberLocalDecision:
            return "Lokale Entscheidung merken"
        case .openExternalLocation:
            return "Externen Ort oeffnen"
        case .showGuidance:
            return "Anleitung anzeigen"
        case .gatherEvidence:
            return "Weitere Belege sammeln"
        }
    }

    var consentSummary: String {
        switch self {
        case .rememberLocalDecision:
            return "Die App speichert nur deine Entscheidung lokal auf diesem Mac."
        case .openExternalLocation:
            return "Die App wuerde einen sichtbaren Ort ausserhalb dieser Ansicht oeffnen, aber keine Einstellung selbst aendern."
        case .showGuidance:
            return "Die App zeigt dir eine Anleitung und nimmt keine Systemaenderung vor."
        case .gatherEvidence:
            return "Die App wuerde spaeter nur eng begrenzte Belege sammeln und keine Systemeinstellung veraendern."
        }
    }
}

struct PolicyAction: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let title: String
    let explanation: String
    let kind: PolicyActionKind
    let minimumConfirmation: PolicyConfirmationRequirement

    init(
        id: String,
        title: String,
        explanation: String,
        kind: PolicyActionKind,
        minimumConfirmation: PolicyConfirmationRequirement
    ) {
        self.id = id
        self.title = title
        self.explanation = explanation
        self.kind = kind
        self.minimumConfirmation = minimumConfirmation
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)

        self.id = id
        self.title = try container.decode(String.self, forKey: .title)
        self.explanation = try container.decode(String.self, forKey: .explanation)
        self.kind = try container.decodeIfPresent(PolicyActionKind.self, forKey: .kind)
            ?? PolicyActionKind.legacyDefault(for: id)
        self.minimumConfirmation = try container.decode(
            PolicyConfirmationRequirement.self,
            forKey: .minimumConfirmation
        )
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case explanation
        case kind
        case minimumConfirmation
    }
}

private extension PolicyActionKind {
    static func legacyDefault(for actionID: String) -> PolicyActionKind {
        switch actionID {
        case "open-sensitive-settings":
            return .openExternalLocation
        case "run-safe-validation":
            return .gatherEvidence
        case "show-guidance":
            return .showGuidance
        default:
            return .rememberLocalDecision
        }
    }
}

extension PolicyAction {
    static let openSensitiveSettings = PolicyAction(
        id: "open-sensitive-settings",
        title: "Sensible Einstellungen oeffnen",
        explanation: "Oeffnet einen passenden Bereich der Systemeinstellungen, damit du ihn selbst pruefen kannst.",
        kind: .openExternalLocation,
        minimumConfirmation: .standard
    )

    static let trustItem = PolicyAction(
        id: "trust-item",
        title: "Hinweis als erwartet merken",
        explanation: "Merkt lokal, dass ein bestimmter Hinweis erwartet ist und kuenftig ruhiger eingeordnet werden soll.",
        kind: .rememberLocalDecision,
        minimumConfirmation: .standard
    )

    static let showGuidance = PolicyAction(
        id: "show-guidance",
        title: "Anleitung anzeigen",
        explanation: "Zeigt eine sichere Anleitung, ohne eine Systemeinstellung automatisch zu aendern.",
        kind: .showGuidance,
        minimumConfirmation: .standard
    )

    static let runSafeValidation = PolicyAction(
        id: "run-safe-validation",
        title: "Weitere Belege sammeln",
        explanation: "Fuehrt spaeter einen eng begrenzten Pruefschritt aus, der mehr Belege sammelt, ohne Systemeinstellungen zu aendern.",
        kind: .gatherEvidence,
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
            return "\(actionTitle) braucht eine bewusste Zustimmung, weil der Schritt erhoehtes Risiko hat."
        }
    }
}
