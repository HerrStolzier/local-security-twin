import Foundation

enum SecurityHygieneEvidenceKind: String, Codable, Hashable, Sendable {
    case observedLocally
    case inferredFromLocalSignal
    case userAnswered
    case notVerifiable

    var title: String {
        switch self {
        case .observedLocally:
            return "Lokal gesehen"
        case .inferredFromLocalSignal:
            return "Aus lokalem Hinweis abgeleitet"
        case .userAnswered:
            return "Von dir beantwortet"
        case .notVerifiable:
            return "Nicht automatisch prüfbar"
        }
    }

    var explanation: String {
        switch self {
        case .observedLocally:
            return "Sento konnte diesen Zustand lokal lesen."
        case .inferredFromLocalSignal:
            return "Sento sieht einen lokalen Hinweis, aber nicht die ganze Wahrheit."
        case .userAnswered:
            return "Diese Aussage stammt aus deiner bewussten Antwort."
        case .notVerifiable:
            return "Sento kann diesen Zustand aktuell nicht ehrlich automatisch prüfen."
        }
    }
}

enum SecurityHygieneCategory: String, Codable, Hashable, Sendable {
    case macProtection
    case accountProtection
    case passwordHygiene
    case networkAndVPN
    case deepSystemSoftware

    var title: String {
        switch self {
        case .macProtection:
            return "Mac-Schutz"
        case .accountProtection:
            return "Account-Schutz"
        case .passwordHygiene:
            return "Passwort-Hygiene"
        case .networkAndVPN:
            return "Netzwerk und VPN"
        case .deepSystemSoftware:
            return "Tiefe Systemsoftware"
        }
    }
}

enum SecurityHygieneCheckID: String, Codable, Hashable, Sendable {
    case macOSUpdates
    case gatekeeper
    case sip
    case fileVault
    case firewall
    case twoFactorAuthentication
    case passwordManager
    case recoveryCodes
    case vpnUsefulness
    case systemExtensions
}

struct SecurityHygieneCheck: Identifiable, Codable, Hashable, Sendable {
    let id: SecurityHygieneCheckID
    let title: String
    let category: SecurityHygieneCategory
    let evidenceKind: SecurityHygieneEvidenceKind
    let summary: String
    let boundary: String

    static let initialCatalog: [SecurityHygieneCheck] = [
        SecurityHygieneCheck(
            id: .macOSUpdates,
            title: "macOS-Updates",
            category: .macProtection,
            evidenceKind: .observedLocally,
            summary: "Sento kann die sichtbare macOS-Version mit dem lokal gespeicherten SOFA-Quellenstand vergleichen.",
            boundary: "Das ist ein Update-Hinweis, kein vollständiges Sicherheitsurteil."
        ),
        SecurityHygieneCheck(
            id: .gatekeeper,
            title: "Gatekeeper",
            category: .macProtection,
            evidenceKind: .observedLocally,
            summary: "Sento kann den Gatekeeper-Status lesen, wenn macOS die lokale Abfrage erlaubt.",
            boundary: "Ein aktiver Gatekeeper beweist nicht, dass jede installierte App sicher ist."
        ),
        SecurityHygieneCheck(
            id: .sip,
            title: "System Integrity Protection",
            category: .macProtection,
            evidenceKind: .observedLocally,
            summary: "Sento kann den SIP-Status lesen, wenn die lokale macOS-Abfrage verfügbar ist.",
            boundary: "SIP ist ein wichtiges Schutzsignal, aber kein Gesamturteil über den Mac."
        ),
        SecurityHygieneCheck(
            id: .fileVault,
            title: "FileVault",
            category: .macProtection,
            evidenceKind: .notVerifiable,
            summary: "FileVault ist als wichtiger Schutzbereich geplant.",
            boundary: "Sento behauptet den FileVault-Zustand erst, wenn ein stabiler lokaler Check gebaut ist."
        ),
        SecurityHygieneCheck(
            id: .firewall,
            title: "Firewall",
            category: .macProtection,
            evidenceKind: .notVerifiable,
            summary: "Die macOS-Firewall ist als späteres lokales Schutzsignal geplant.",
            boundary: "Sento ändert keine Firewall-Einstellung still und bewertet sie erst nach einem eigenen Check."
        ),
        SecurityHygieneCheck(
            id: .twoFactorAuthentication,
            title: "2FA für wichtige Konten",
            category: .accountProtection,
            evidenceKind: .userAnswered,
            summary: "2FA startet als geführte Nutzerfrage für Apple-ID, E-Mail, Banking und Cloud-Konten.",
            boundary: "Ohne Integration kann Sento 2FA nicht automatisch verifizieren."
        ),
        SecurityHygieneCheck(
            id: .passwordManager,
            title: "Passwortmanager",
            category: .passwordHygiene,
            evidenceKind: .userAnswered,
            summary: "Passwortmanager-Nutzung startet als bewusste Nutzerangabe.",
            boundary: "Sento fragt keine Passwörter ab und behauptet keine Passwortqualität."
        ),
        SecurityHygieneCheck(
            id: .recoveryCodes,
            title: "Recovery Codes",
            category: .accountProtection,
            evidenceKind: .userAnswered,
            summary: "Recovery Codes werden später als Checklistenfrage geführt.",
            boundary: "Sento fragt keine Recovery Codes ab und speichert keine Geheimnisse."
        ),
        SecurityHygieneCheck(
            id: .vpnUsefulness,
            title: "VPN-Sinnhaftigkeit",
            category: .networkAndVPN,
            evidenceKind: .userAnswered,
            summary: "VPN wird als Kontextfrage erklärt, etwa für fremde WLANs oder berufliche Vorgaben.",
            boundary: "VPN wird nicht als magischer Rundumschutz verkauft."
        ),
        SecurityHygieneCheck(
            id: .systemExtensions,
            title: "System Extensions",
            category: .deepSystemSoftware,
            evidenceKind: .notVerifiable,
            summary: "Tiefe Systemsoftware bleibt ein späterer macOS-Sichtbarkeits-Spike.",
            boundary: "Die Existenz einer Erweiterung ist noch keine Bewertung."
        ),
    ]
}
