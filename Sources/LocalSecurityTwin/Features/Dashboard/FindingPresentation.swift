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
            return "Neue Änderungen"
        case .knownStartupHints:
            return "Bekannte Autostart-Hinweise"
        case .review:
            return "Zur Beobachtung"
        }
    }

    var emptyText: String {
        switch self {
        case .changes:
            return "Keine neuen Startup-Änderungen sichtbar."
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

    var statusTitle: String {
        if startupChangeCount > 0 {
            return "Bitte kurz prüfen"
        }

        if findings.isEmpty {
            return "Alles ruhig"
        }

        return "Zur Beobachtung"
    }

    var buddyMessageText: String {
        if findings.isEmpty {
            return "Ich sehe gerade keinen Hinweis, der deine Aufmerksamkeit braucht."
        }

        if startupChangeCount > 0 {
            return "Ich habe eine Veränderung im Autostart gesehen. Das ist nicht automatisch gefährlich, aber wir sollten kurz klären, ob du sie erwartest."
        }

        if knownStartupCount > 0 && reviewCount > 0 {
            return "Ich sehe bekannte Autostart-Hinweise und ein paar Systemsignale. Das ist vor allem Orientierung; wichtig wird es erst, wenn etwas neu oder unerwartet ist."
        }

        if knownStartupCount > 0 {
            return "Ich sehe bekannte Autostart-Hinweise. Sie sind nicht automatisch kritisch, aber sie erklären, was im Hintergrund starten kann."
        }

        return "Ich sehe lokale Systemsignale. Sie helfen uns, den Mac einzuordnen, ersetzen aber kein vollständiges Sicherheitsurteil."
    }

    var primaryActionTitle: String {
        if startupChangeCount > 0 {
            return "Neue Änderung ansehen"
        }

        if findings.isEmpty {
            return "Nichts zu tun"
        }

        return "Hinweise ansehen"
    }

    var knownStartupSummaryText: String? {
        guard knownStartupCount > 1 else {
            return nil
        }

        return "\(knownStartupCount) bekannte Autostart-Hinweise zusammengefasst. Öffne die Einzelhinweise nur, wenn du eine bestimmte App genauer ansehen willst."
    }

    var guardianTone: String {
        if startupChangeCount > 0 {
            return "Aufmerksam"
        }

        if findings.isEmpty {
            return "Stabil"
        }

        return "Beobachtet"
    }

    var guardianProgress: Double {
        if startupChangeCount > 0 {
            return 0.45
        }

        if findings.isEmpty {
            return 0.9
        }

        return 0.68
    }

    var missions: [BuddyMission] {
        [
            startupMission,
            systemMission,
            hygieneMission,
            privacyMission,
            appRiskMission,
        ]
    }

    var activityItems: [BuddyActivityItem] {
        var items: [BuddyActivityItem] = []

        if startupChangeCount > 0 {
            items.append(
                BuddyActivityItem(
                    id: "startup-change",
                    systemImage: "exclamationmark.shield",
                    title: "\(startupChangeCount) neue Autostart-Änderung(en)",
                    message: "Diese Änderung sollte kurz eingeordnet werden.",
                    findingID: findings(in: .changes).first?.id
                )
            )
        } else {
            items.append(
                BuddyActivityItem(
                    id: "startup-stable",
                    systemImage: "checkmark.shield",
                    title: "Keine neue Autostart-Änderung",
                    message: "Der aktuelle lokale Blick zeigt keine neue Startup-Überraschung.",
                    findingID: nil
                )
            )
        }

        if knownStartupCount > 0 {
            items.append(
                BuddyActivityItem(
                    id: "known-startup",
                    systemImage: "rectangle.stack",
                    title: "\(knownStartupCount) bekannte Autostart-Hinweise",
                    message: "Zusammengefasst, damit du zuerst das Wichtige siehst.",
                    findingID: findings(in: .knownStartupHints).first?.id
                )
            )
        }

        if reviewCount > 0 {
            items.append(
                BuddyActivityItem(
                    id: "system-context",
                    systemImage: "desktopcomputer",
                    title: "\(reviewCount) Systemsignal(e)",
                    message: "Diese Hinweise helfen beim Einordnen, sind aber kein Gesamturteil.",
                    findingID: findings(in: .review).first?.id
                )
            )
        }

        return items
    }

    var showsRememberCurrentStartupStateAction: Bool {
        startupChangeCount > 0
    }

    var headlineText: String {
        if findings.isEmpty {
            return "Alles ruhig im ersten lokalen Blick"
        }

        if startupChangeCount > 0 {
            return "\(startupChangeCount) Autostart-Änderung(en) brauchen deine Einordnung"
        }

        if knownStartupCount == 0 && reviewCount > 0 {
            return "\(reviewCount) lokale Systemhinweis(e) sichtbar"
        }

        return "\(knownStartupCount) bekannte Autostart-Hinweis(e) sichtbar"
    }

    var summaryText: String {
        if findings.isEmpty {
            return "Aktuell sieht die App keine lokalen Hinweise, die sie anzeigen sollte."
        }

        if startupChangeCount > 0 {
            return "Wichtig sind zuerst die Änderungen seit dem gemerkten Zustand. Bekannte Hinweise kannst du danach in Ruhe prüfen."
        }

        if knownStartupCount == 0 && reviewCount > 0 {
            return "Die App sieht lokale Systemhinweise. Das ist Orientierung, kein vollständiges Sicherheitsurteil."
        }

        return "Es sind sichtbare Autostart-Hinweise vorhanden. Das ist nicht automatisch gefährlich, sondern zuerst eine lokale Orientierung."
    }

    var nextStepText: String {
        if findings.isEmpty {
            return "Du musst gerade nichts tun. Beim nächsten Lauf vergleicht die App wieder den sichtbaren Zustand."
        }

        if startupChangeCount > 0 {
            return "Prüfe zuerst die neuen oder verschwundenen Hinweise. Wenn sie erwartet sind, merke den aktuellen Zustand bewusst als normal."
        }

        if knownStartupCount == 0 && reviewCount > 0 {
            return "Lies die Systemhinweise als Kontext. Wichtig ist, ob eine Einstellung anders wirkt, als du sie erwartest."
        }

        return "Schau dir bekannte Hinweise in Ruhe an. Wichtig ist vor allem, ob du die zugehörige App erkennst."
    }

    var visibilityText: String {
        "Aktuell sieht die App sichtbare Autostart-Dateien und lokale Systemprofil-Daten. Das sind Belege zur Einordnung, kein Beweis für aktive oder gefährliche Software und kein vollständiges Urteil über den Mac."
    }

    func findings(in group: FindingGroup) -> [Finding] {
        findings.filter { $0.displayGroup == group }
    }

    private var startupMission: BuddyMission {
        if startupChangeCount > 0 {
            return BuddyMission(
                id: "startup",
                title: "Autostart einordnen",
                status: "Bitte prüfen",
                summary: "Es gibt neue oder verschwundene Autostart-Hinweise seit dem gemerkten Zustand.",
                systemImage: "bolt.horizontal.circle",
                progress: 0.35,
                primaryActionTitle: "Neue Änderung ansehen",
                findingID: findings(in: .changes).first?.id
            )
        }

        return BuddyMission(
            id: "startup",
            title: "Autostart verstehen",
            status: knownStartupCount > 0 ? "\(knownStartupCount) bekannt" : "Ruhig",
            summary: knownStartupCount > 0
                ? "Bekannte Autostart-Hinweise sind zusammengefasst und nur bei Bedarf im Detail sichtbar."
                : "Aktuell gibt es keine sichtbaren Autostart-Hinweise, die deine Aufmerksamkeit brauchen.",
            systemImage: "bolt.horizontal.circle",
            progress: knownStartupCount > 0 ? 0.7 : 0.9,
            primaryActionTitle: knownStartupCount > 0 ? "Zusammenfassung ansehen" : "Keine Aktion nötig",
            findingID: findings(in: .knownStartupHints).first?.id
        )
    }

    private var systemMission: BuddyMission {
        BuddyMission(
            id: "system",
            title: "Mac-Schutzsignale",
            status: reviewCount > 0 ? "\(reviewCount) sichtbar" : "Noch leer",
            summary: reviewCount > 0
                ? "Lokale Systemsignale sind sichtbar. Sie helfen beim Einordnen, ohne ein Gesamturteil zu behaupten."
                : "Systemschutzsignale erscheinen hier, sobald der lokale Sensor etwas anzeigen kann.",
            systemImage: "desktopcomputer",
            progress: reviewCount > 0 ? 0.6 : 0.25,
            primaryActionTitle: reviewCount > 0 ? "Systemhinweis ansehen" : "Später prüfen",
            findingID: findings(in: .review).first?.id
        )
    }

    private var hygieneMission: BuddyMission {
        BuddyMission(
            id: "hygiene",
            title: "Security-Hygiene",
            status: "Geplant",
            summary: "Hier landen später FileVault, Firewall, Updates, 2FA, Passwortmanager und VPN-Fragen.",
            systemImage: "checklist",
            progress: 0.15,
            primaryActionTitle: "Noch nicht aktiv",
            findingID: nil
        )
    }

    private var privacyMission: BuddyMission {
        BuddyMission(
            id: "privacy",
            title: "Digitaler Fußabdruck",
            status: "Geplant",
            summary: "Später helfe ich dir, sichtbare Daten, alte Accounts und Datenbroker-Funde geordnet anzugehen.",
            systemImage: "person.crop.circle",
            progress: 0.1,
            primaryActionTitle: "Später",
            findingID: nil
        )
    }

    private var appRiskMission: BuddyMission {
        BuddyMission(
            id: "app-risk",
            title: "App-Risiken prüfen",
            status: "Geplant",
            summary: "Hier soll später sichtbar werden, welche Apps ungewöhnliche Rechte, alte Versionen oder riskante Muster zeigen.",
            systemImage: "square.grid.2x2",
            progress: 0.12,
            primaryActionTitle: "Später",
            findingID: nil
        )
    }
}

struct BuddyMission: Identifiable, Equatable {
    let id: String
    let title: String
    let status: String
    let summary: String
    let systemImage: String
    let progress: Double
    let primaryActionTitle: String
    let findingID: Finding.ID?
}

struct BuddyActivityItem: Identifiable, Equatable {
    let id: String
    let systemImage: String
    let title: String
    let message: String
    let findingID: Finding.ID?
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

            return "Autostart-Hinweis für diesen Benutzer"
        case .privacyPermissions:
            return "Datenschutz-Berechtigung"
        case .systemInventory:
            return title
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
            return "\(displaySubject) liegt an einem Ort, den macOS für automatischen Hintergrundstart nutzen kann."
        case .privacyPermissions, .systemInventory:
            return summary
        }
    }

    var displaySourceTitle: String {
        switch source.kind {
        case .baselineDiff:
            return "Änderung seit gemerktem Zustand"
        case .launchAgentInventory:
            return "Sichtbarer Autostart-Hinweis"
        case .privacyPermissions:
            return "Datenschutz"
        case .systemInventory:
            return source.title
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
            return "Prüfen"
        case .high:
            return "Genauer prüfen"
        }
    }

    var plainLanguageAssessment: String {
        switch source.kind {
        case .baselineDiff:
            if id.contains("::removed::") {
                return "Wichtig ist hier vor allem die Änderung: Dieser Hinweis war früher sichtbar und ist jetzt weg. Das ist oft normal nach Updates oder Deinstallationen."
            }

            return "Wichtig ist hier vor allem die Änderung: Dieser Hinweis war beim letzten gemerkten Zustand noch nicht sichtbar. Wenn du die App kennst, kannst du ihn als erwartet merken."
        case .launchAgentInventory:
            return "Dieser Hinweis ist nicht automatisch gefährlich. Er zeigt nur, dass macOS diese Datei für Hintergrundstart verwenden kann."
        case .privacyPermissions:
            return "Diese Berechtigung kann sensibel sein. Entscheidend ist, ob du die App kennst und ihr diesen Zugriff geben wolltest."
        case .systemInventory:
            return "Dieser Systemhinweis soll dir helfen, lokale Veränderungen besser einzuordnen."
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
            return "Soll im Hintergrund verfügbar bleiben"
        }

        if value.localizedCaseInsensitiveContains("bedingungen")
            || value.localizedCaseInsensitiveContains("conditional") {
            return "Nutzt Bedingungen, um bei Bedarf verfügbar zu bleiben"
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
            return "Früher beobachtete Datei"
        case "scope":
            return "Bereich"
        case "baseline-comparison":
            return "Änderung seit gemerktem Zustand"
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
            return "Erhöht"
        }
    }
}

extension FindingConfidence {
    var displayTitle: String {
        switch self {
        case .tentative:
            return "Erste Einschätzung"
        case .supported:
            return "Mit Beleg"
        case .strong:
            return "Stark belegt"
        }
    }
}
