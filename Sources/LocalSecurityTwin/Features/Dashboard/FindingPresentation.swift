import Foundation

enum FindingGroup: String, CaseIterable, Identifiable {
    case changes
    case knownStartupHints
    case review

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .changes:
            return "Neue Aenderungen"
        case .knownStartupHints:
            return "Bekannte Autostart-Hinweise"
        case .review:
            return "Zur Beobachtung"
        }
    }

    var emptyText: String {
        switch self {
        case .changes:
            return "Keine neuen Startup-Aenderungen sichtbar."
        case .knownStartupHints:
            return "Noch keine bekannten Autostart-Hinweise geladen."
        case .review:
            return "Keine weiteren Hinweise zur Beobachtung."
        }
    }
}

extension Finding {
    var displayGroup: FindingGroup {
        switch source.kind {
        case .baselineDiff:
            return .changes
        case .launchAgentInventory:
            return .knownStartupHints
        case .privacyPermissions, .systemInventory:
            return .review
        }
    }

    var displayTitle: String {
        switch source.kind {
        case .baselineDiff:
            if id.contains("::removed::") {
                return "Autostart-Hinweis ist verschwunden"
            }

            return "Neuer Autostart-Hinweis"
        case .launchAgentInventory:
            if title.localizedCaseInsensitiveContains("shared daemon") {
                return "Systemweiter Autostart-Hinweis"
            }

            if title.localizedCaseInsensitiveContains("shared") {
                return "Gemeinsamer Autostart-Hinweis"
            }

            return "Autostart-Hinweis fuer diesen Benutzer"
        case .privacyPermissions:
            return "Datenschutz-Berechtigung"
        case .systemInventory:
            return "System-Hinweis"
        }
    }

    var displaySummary: String {
        switch source.kind {
        case .baselineDiff:
            if id.contains("::removed::") {
                return "\(displaySubject) war im gemerkten Zustand vorhanden und ist jetzt nicht mehr sichtbar."
            }

            return "\(displaySubject) ist seit dem gemerkten Zustand neu sichtbar."
        case .launchAgentInventory:
            return "\(displaySubject) liegt an einem Ort, den macOS fuer automatischen Hintergrundstart nutzen kann."
        case .privacyPermissions, .systemInventory:
            return summary
        }
    }

    var displaySourceTitle: String {
        switch source.kind {
        case .baselineDiff:
            return "Aenderung seit gemerktem Zustand"
        case .launchAgentInventory:
            return "Sichtbarer Autostart-Hinweis"
        case .privacyPermissions:
            return "Datenschutz"
        case .systemInventory:
            return "System"
        }
    }

    var displaySubject: String {
        evidence
            .lazy
            .compactMap { evidenceItem in
                fileName(from: evidenceItem.summary)
            }
            .first
            ?? summary.components(separatedBy: " ").first
            ?? title
    }

    var displayImportance: String {
        switch severity {
        case .low:
            return "Ruhig pruefen"
        case .medium:
            return "Anschauen"
        case .high:
            return "Genauer ansehen"
        }
    }

    var plainLanguageAssessment: String {
        switch source.kind {
        case .baselineDiff:
            if id.contains("::removed::") {
                return "Wichtig ist hier vor allem die Aenderung: Dieser Hinweis war frueher sichtbar und ist jetzt weg. Das ist oft normal nach Updates oder Deinstallationen."
            }

            return "Wichtig ist hier vor allem die Aenderung: Dieser Hinweis war beim letzten gemerkten Zustand noch nicht sichtbar. Wenn du die App kennst, kannst du ihn als erwartet merken."
        case .launchAgentInventory:
            return "Dieser Hinweis ist nicht automatisch gefaehrlich. Er zeigt nur, dass macOS diese Datei fuer Hintergrundstart verwenden kann."
        case .privacyPermissions:
            return "Diese Berechtigung kann sensibel sein. Entscheidend ist, ob du die App kennst und ihr diesen Zugriff geben wolltest."
        case .systemInventory:
            return "Dieser Systemhinweis soll dir helfen, lokale Veraenderungen besser einzuordnen."
        }
    }

    private func fileName(from text: String) -> String? {
        guard let range = text.range(of: ".plist") else {
            return nil
        }

        let prefix = text[..<range.upperBound]
        let separators = CharacterSet(charactersIn: " /")
        return prefix
            .components(separatedBy: separators)
            .last
    }
}

extension FindingSeverity {
    var displayTitle: String {
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

extension FindingConfidence {
    var displayTitle: String {
        switch self {
        case .tentative:
            return "Erste Einschaetzung"
        case .supported:
            return "Mit Beleg"
        case .strong:
            return "Stark belegt"
        }
    }
}
