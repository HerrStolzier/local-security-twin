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

struct DashboardPresentation {
    let findings: [Finding]

    var startupChangeCount: Int {
        findings(in: .changes).count
    }

    var knownStartupCount: Int {
        findings(in: .knownStartupHints).count
    }

    var reviewCount: Int {
        findings(in: .review).count
    }

    var showsRememberCurrentStartupStateAction: Bool {
        startupChangeCount > 0
    }

    var summaryText: String {
        if findings.isEmpty {
            return "Aktuell sieht die App keine lokalen Hinweise, die sie anzeigen sollte."
        }

        if startupChangeCount > 0 {
            return "Wichtig sind zuerst die Aenderungen seit dem gemerkten Zustand. Bekannte Hinweise kannst du danach in Ruhe pruefen."
        }

        return "Es sind sichtbare Autostart-Hinweise vorhanden. Das ist nicht automatisch gefaehrlich, sondern zuerst eine lokale Orientierung."
    }

    func findings(in group: FindingGroup) -> [Finding] {
        findings.filter { $0.displayGroup == group }
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
            if title.localizedCaseInsensitiveContains("systemweit")
                || title.localizedCaseInsensitiveContains("shared daemon") {
                return "Systemweiter Autostart-Hinweis"
            }

            if title.localizedCaseInsensitiveContains("gemeinsam")
                || title.localizedCaseInsensitiveContains("shared") {
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
            return "Zur Info"
        case .medium:
            return "Pruefen"
        case .high:
            return "Genauer pruefen"
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

    var startupFilePath: String? {
        evidence
            .lazy
            .compactMap { evidenceItem in
                path(from: evidenceItem.summary)
            }
            .first
    }

    var startupLabel: String? {
        startupDetailValue(prefix: "Label:")
    }

    var startupProgram: String? {
        startupDetailValue(prefix: "Program:")
    }

    var startupProgramArguments: String? {
        startupDetailValue(prefix: "Program arguments:")
    }

    var startupRunAtLoadText: String? {
        guard let value = startupDetailValue(prefix: "Run at load:") else {
            return nil
        }

        return value == "yes"
            ? "Kann beim Laden automatisch starten"
            : "Startet nicht ausdruecklich beim Laden"
    }

    var startupKeepAliveText: String? {
        guard let value = startupDetailValue(prefix: "Keep alive:") else {
            return nil
        }

        if value.localizedCaseInsensitiveContains("dauerhaft")
            || value.localizedCaseInsensitiveContains("always") {
            return "Soll im Hintergrund verfuegbar bleiben"
        }

        if value.localizedCaseInsensitiveContains("bedingungen")
            || value.localizedCaseInsensitiveContains("conditional") {
            return "Nutzt Bedingungen, um bei Bedarf verfuegbar zu bleiben"
        }

        return value
    }

    private func fileName(from text: String) -> String? {
        guard let path = path(from: text) else {
            return nil
        }

        return URL(fileURLWithPath: path).lastPathComponent
    }

    private func path(from text: String) -> String? {
        guard let range = text.range(of: ".plist") else {
            return nil
        }

        let prefix = text[..<range.upperBound]
        let separators = CharacterSet.whitespacesAndNewlines
        return prefix
            .components(separatedBy: separators)
            .last { $0.hasSuffix(".plist") }
            .map { $0.trimmingCharacters(in: CharacterSet(charactersIn: ".")) }
    }

    private func startupDetailValue(prefix: String) -> String? {
        guard let details = evidence.first(where: { $0.id == "plist-details" })?.detail else {
            return nil
        }

        return details
            .components(separatedBy: .newlines)
            .first { $0.hasPrefix(prefix) }
            .map { line in
                String(line.dropFirst(prefix.count)).trimmingCharacters(in: .whitespaces)
            }
    }
}

extension FindingEvidence {
    var displayTitle: String {
        switch id {
        case "plist-details":
            return "Autostart-Details"
        case "path", "current-path":
            return "Aktuell beobachtete Datei"
        case "previous-path":
            return "Frueher beobachtete Datei"
        case "scope":
            return "Bereich"
        case "baseline-comparison":
            return "Aenderung seit gemerktem Zustand"
        default:
            return title
        }
    }

    var displaySummary: String {
        switch id {
        case "plist-details":
            return "Die App konnte einfache Startinformationen aus der plist-Datei lesen."
        case "path", "current-path":
            return "Diese Datei ist aktuell sichtbar."
        case "previous-path":
            return "Diese Datei war im gemerkten Zustand sichtbar."
        case "scope":
            return "Dieser Bereich bestimmt, ob der Hinweis nur den Nutzer oder das System betrifft."
        case "baseline-comparison":
            return "Die App vergleicht den aktuellen Zustand mit dem lokal gemerkten Zustand."
        default:
            return summary
        }
    }

    var displayDetail: String {
        switch id {
        case "plist-details":
            return detail
        case "path", "current-path", "previous-path", "baseline-comparison", "scope":
            return detail
        default:
            return detail
        }
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
