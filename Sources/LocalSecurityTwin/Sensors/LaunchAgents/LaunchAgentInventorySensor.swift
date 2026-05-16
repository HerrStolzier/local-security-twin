import Foundation

struct LaunchAgentInventorySensor: StartupBaselineRefreshingSensor {
    let descriptor = SensorDescriptor(
        id: "launch-agent-inventory",
        title: "Sichtbare Autostart-Hinweise",
        summary: "Sucht sichtbare plist-Dateien in Autostart-Ordnern des Nutzers und des Systems."
    )

    private let fileManager: FileManager
    private let sharedDirectories: [URL]
    private let baselineStore: StartupItemBaselineStore

    init(
        fileManager: FileManager = .default,
        baselineStore: StartupItemBaselineStore = StartupItemBaselineStore(),
        sharedDirectories: [URL] = [
            URL(fileURLWithPath: "/Library/LaunchAgents", isDirectory: true),
            URL(fileURLWithPath: "/Library/LaunchDaemons", isDirectory: true),
        ]
    ) {
        self.fileManager = fileManager
        self.baselineStore = baselineStore
        self.sharedDirectories = sharedDirectories
    }

    func run(in context: SensorContext) -> SensorRun {
        let directories = startupDirectories(in: context)

        let items = scanStartupItems(in: directories)

        do {
            let baselineState = try baselineStore.initializeIfNeeded(
                sensorID: descriptor.id,
                items: items,
                capturedAt: context.now
            )
            let findings = makeFindings(for: items, baselineState: baselineState)
            let notes = makeNotes(
                for: items,
                directories: directories,
                baselineState: baselineState
            )

            return SensorRun(
                sensor: descriptor,
                findings: findings,
                notes: notes,
                completedAt: context.now
            )
        } catch {
            let findings = items.map(makeInventoryFinding)
            let notes = makeFallbackNotes(for: items, directories: directories, error: error)

            return SensorRun(
                sensor: descriptor,
                findings: findings,
                notes: notes,
                completedAt: context.now
            )
        }
    }

    func refreshRememberedStartupState(in context: SensorContext) throws {
        let directories = startupDirectories(in: context)
        let items = scanStartupItems(in: directories)
        try baselineStore.refresh(
            sensorID: descriptor.id,
            items: items,
            capturedAt: context.now
        )
    }

    private func startupDirectories(in context: SensorContext) -> [URL] {
        [
            context.homeDirectoryURL
                .appendingPathComponent("Library", isDirectory: true)
                .appendingPathComponent("LaunchAgents", isDirectory: true),
        ] + sharedDirectories
    }

    private func scanStartupItems(in directories: [URL]) -> [LaunchAgentItem] {
        directories
            .flatMap(scanDirectory)
            .sorted { lhs, rhs in
                lhs.id < rhs.id
            }
    }

    private func scanDirectory(_ directoryURL: URL) -> [LaunchAgentItem] {
        let scope = scope(forDirectory: directoryURL)

        guard
            let entries = try? fileManager.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: [.isRegularFileKey],
                options: [.skipsHiddenFiles]
            )
        else {
            return []
        }

        return entries
            .filter { $0.pathExtension == "plist" }
            .map { itemURL in
                LaunchAgentItem(
                    path: itemURL.path,
                    scope: scope,
                    details: readDetails(from: itemURL)
                )
            }
    }

    private func readDetails(from itemURL: URL) -> StartupItemDetails? {
        guard
            let data = try? Data(contentsOf: itemURL),
            let propertyList = try? PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            ),
            let dictionary = propertyList as? [String: Any]
        else {
            return nil
        }

        return StartupItemDetails(
            label: dictionary["Label"] as? String,
            program: dictionary["Program"] as? String,
            programArguments: dictionary["ProgramArguments"] as? [String] ?? [],
            runAtLoad: dictionary["RunAtLoad"] as? Bool,
            keepAliveSummary: keepAliveSummary(from: dictionary["KeepAlive"])
        )
    }

    private func keepAliveSummary(from value: Any?) -> String? {
        switch value {
        case let bool as Bool:
            return bool ? "Soll dauerhaft verfügbar bleiben" : "Fordert kein dauerhaftes Neustarten durch launchd an"
        case let dictionary as [String: Any]:
            if dictionary.isEmpty {
                return nil
            }

            return "Nutzt Bedingungen für Hintergrundverfügbarkeit: \(dictionary.keys.sorted().joined(separator: ", "))"
        default:
            return nil
        }
    }

    private func scope(forDirectory directoryURL: URL) -> StartupItemScope {
        if directoryURL.lastPathComponent == "LaunchDaemons" {
            return .sharedDaemon
        }

        if directoryURL.path.hasPrefix("/Library/LaunchAgents") {
            return .sharedAgent
        }

        return .userAgent
    }

    private func makeFindings(
        for items: [LaunchAgentItem],
        baselineState: StartupItemBaselineState
    ) -> [Finding] {
        switch baselineState.status {
        case .createdInitialSnapshot:
            return items.map(makeInventoryFinding)
        case .loadedExistingSnapshot:
            let diff = compare(items: items, against: baselineState.snapshot.items)

            return diff.added.map { makeAddedSinceBaselineFinding(for: $0, baseline: baselineState.snapshot) }
                + diff.removed.map { makeRemovedSinceBaselineFinding(for: $0, baseline: baselineState.snapshot) }
                + diff.unchanged.map(makeInventoryFinding)
        }
    }

    private func makeInventoryFinding(for item: LaunchAgentItem) -> Finding {
        let fileName = item.fileName
        let scopeTitle = item.scope.title

        return Finding(
            id: "launch-item::\(item.id)",
            title: "\(scopeTitle) Autostart-Hinweis ist sichtbar",
            source: FindingSource(
                kind: .launchAgentInventory,
                title: "Sichtbare Autostart-Hinweise",
                detail: "Sucht sichtbare plist-Dateien in Autostart-Ordnern des Nutzers und des Systems."
            ),
            severity: item.scope.defaultSeverity,
            confidence: .supported,
            summary: "\(fileName) ist an einem Ort sichtbar, den macOS für automatischen Hintergrundstart nutzen kann.",
            userImpact: "Das ist ein Autostart-Hinweis, kein Beweis dafür, dass die Software gerade läuft oder gefährlich ist. Wichtig ist er, weil solche Orte Software nach Login oder Start im Hintergrund verfügbar machen können.",
            nextStep: "Prüfe, ob dieser Hinweis zu Software gehört, die du erwartest. Wenn ja, kannst du ihn als erwartet merken. Wenn nicht, beobachte ihn weiter, bevor du ihn als normal behandelst.",
            evidence: startupEvidence(for: item, scopeTitle: scopeTitle) + [
                FindingEvidence(
                    id: "path",
                    title: "Beobachtete Datei",
                    summary: "Eine plist-Datei wurde unter \(item.path) gefunden.",
                    detail: "Dieser Sensor meldet sichtbare Dateisystem-Belege. Das beweist nicht, dass der Eintrag gerade geladen ist oder läuft."
                ),
                FindingEvidence(
                    id: "scope",
                    title: "Autostart-Bereich",
                    summary: "Der Hinweis liegt im Bereich: \(scopeTitle).",
                    detail: item.scope.userExplanation
                ),
            ],
            recommendations: [
                FindingRecommendation(
                    id: "trust-launch-item",
                    title: "Diesen Autostart-Hinweis als erwartet merken",
                    explanation: "Nutze das, wenn du den Eintrag kennst und er nicht weiter als Überraschung auftauchen soll.",
                    action: .trustItem
                ),
                FindingRecommendation(
                    id: "validate-launch-item",
                    title: "Diesen Hinweis weiter beobachten",
                    explanation: "Nutze später einen begrenzten Prüfschritt, wenn du mehr Belege brauchst, bevor du den Hinweis einordnest.",
                    action: .runSafeValidation
                ),
            ]
        )
    }

    private func startupEvidence(for item: LaunchAgentItem, scopeTitle: String) -> [FindingEvidence] {
        guard let details = item.details else {
            return [
                FindingEvidence(
                    id: "plist-details",
                    title: "Autostart-Details",
                    summary: "Die plist-Datei war sichtbar, aber die App konnte keine einfachen Startdetails daraus lesen.",
                    detail: "Das kann passieren, wenn die Datei leer, fehlerhaft oder anders aufgebaut ist, als dieser erste Leser versteht. Der Dateipfad bleibt trotzdem als Beleg erhalten."
                ),
            ]
        }

        var lines: [String] = []

        if let label = details.label {
            lines.append("Label: \(label)")
        }

        if let program = details.program {
            lines.append("Program: \(program)")
        }

        if !details.programArguments.isEmpty {
            lines.append("Program arguments: \(details.programArguments.joined(separator: " "))")
        }

        if let runAtLoad = details.runAtLoad {
            lines.append("Run at load: \(runAtLoad ? "yes" : "no")")
        }

        if let keepAliveSummary = details.keepAliveSummary {
            lines.append("Keep alive: \(keepAliveSummary)")
        }

        if lines.isEmpty {
            lines.append("Keine einfachen Werte für Label, Program, ProgramArguments, RunAtLoad oder KeepAlive vorhanden.")
        }

        return [
            FindingEvidence(
                id: "plist-details",
                title: "Autostart-Details",
                summary: "Die plist-Datei enthält lesbare Startdetails für diesen Autostart-Hinweis.",
                detail: lines.joined(separator: "\n")
            ),
        ]
    }

    private func makeAddedSinceBaselineFinding(
        for item: LaunchAgentItem,
        baseline: StartupItemBaselineSnapshot
    ) -> Finding {
        let scopeTitle = item.scope.title
        let baselineTimestamp = formattedTimestamp(baseline.capturedAt)

        return Finding(
            id: "baseline-diff::added::\(item.id)",
            title: "\(scopeTitle) Autostart-Hinweis ist seit dem gemerkten Zustand neu",
            source: FindingSource(
                kind: .baselineDiff,
                title: "Autostart-Änderung seit gemerktem Zustand",
                detail: "Vergleicht die aktuell sichtbaren Autostart-Hinweise mit dem lokal gemerkten Zustand."
            ),
            severity: item.scope.defaultSeverity,
            confidence: .supported,
            summary: "\(item.fileName) war nicht Teil des gemerkten Autostart-Zustands und ist jetzt an einem Autostart-Ort sichtbar.",
            userImpact: "Ein neuer sichtbarer Autostart-Hinweis ist nach Installation oder Update oft normal. Er verdient trotzdem eine ruhige Prüfung, weil er beeinflussen kann, was im Hintergrund starten darf.",
            nextStep: "Prüfe, ob du diese Software-Änderung erwartet hast. Wenn ja, kannst du den aktuellen Autostart-Zustand als erwartet merken. Wenn nicht, beobachte sie weiter.",
            evidence: startupEvidence(for: item, scopeTitle: scopeTitle) + [
                FindingEvidence(
                    id: "baseline-comparison",
                    title: "Änderung seit gemerktem Zustand",
                    summary: "Der gemerkte Zustand vom \(baselineTimestamp) enthielt diesen Autostart-Hinweis nicht.",
                    detail: "Die App hat die aktuell sichtbaren Autostart-Hinweise mit einem früher lokal gespeicherten Zustand dieses Macs verglichen."
                ),
                FindingEvidence(
                    id: "current-path",
                    title: "Aktuell beobachtete Datei",
                    summary: "Eine plist-Datei ist aktuell unter \(item.path) sichtbar.",
                    detail: "Das bedeutet: Der Eintrag ist jetzt sichtbar, obwohl er nicht Teil des gemerkten Zustands war."
                ),
                FindingEvidence(
                    id: "scope",
                    title: "Autostart-Bereich",
                    summary: "Der Hinweis liegt im Bereich: \(scopeTitle).",
                    detail: item.scope.userExplanation
                ),
            ],
            recommendations: [
                FindingRecommendation(
                    id: "trust-startup-change",
                    title: "Diese Autostart-Änderung als erwartet merken",
                    explanation: "Nutze das, wenn du den neuen Eintrag kennst und er nicht weiter als Überraschung auftauchen soll.",
                    action: .trustItem
                ),
                FindingRecommendation(
                    id: "validate-startup-change",
                    title: "Diese Änderung weiter beobachten",
                    explanation: "Nutze später einen begrenzten Prüfschritt, wenn du mehr Belege brauchst, bevor du die Änderung einordnest.",
                    action: .runSafeValidation
                ),
            ]
        )
    }

    private func makeRemovedSinceBaselineFinding(
        for item: LaunchAgentItem,
        baseline: StartupItemBaselineSnapshot
    ) -> Finding {
        let scopeTitle = item.scope.title
        let baselineTimestamp = formattedTimestamp(baseline.capturedAt)

        return Finding(
            id: "baseline-diff::removed::\(item.id)",
            title: "\(scopeTitle) Autostart-Hinweis ist seit dem gemerkten Zustand verschwunden",
            source: FindingSource(
                kind: .baselineDiff,
                title: "Autostart-Änderung seit gemerktem Zustand",
                detail: "Vergleicht die aktuell sichtbaren Autostart-Hinweise mit dem lokal gemerkten Zustand."
            ),
            severity: item.scope.removalSeverity,
            confidence: .supported,
            summary: "\(item.fileName) war im gemerkten Autostart-Zustand vorhanden und ist am früheren Autostart-Ort nicht mehr sichtbar.",
            userImpact: "Ein verschwundener Autostart-Hinweis ist nach Deinstallation oder Update oft harmlos. Er bedeutet zuerst nur, dass sich die sichtbare Autostart-Liste geändert hat.",
            nextStep: "Wenn du die zugehörige Software kürzlich entfernt oder aktualisiert hast, ist das wahrscheinlich erwartet. Wenn nicht, beobachte, ob der Eintrag wieder auftaucht oder sich Startverhalten verändert.",
            evidence: [
                FindingEvidence(
                    id: "baseline-comparison",
                    title: "Änderung seit gemerktem Zustand",
                    summary: "Der gemerkte Zustand vom \(baselineTimestamp) enthielt diesen Autostart-Hinweis, der aktuelle Zustand nicht mehr.",
                    detail: "Das ist ein Verschwinden relativ zum lokal gemerkten Zustand, für sich allein aber kein Beweis für schädliches Verhalten."
                ),
                FindingEvidence(
                    id: "previous-path",
                    title: "Früher beobachtete Datei",
                    summary: "Der gemerkte Zustand hatte den Eintrag unter \(item.path) gespeichert.",
                    detail: "Der aktuelle Sensorlauf sieht an diesem gemerkten Autostart-Pfad keine plist-Datei mehr."
                ),
                FindingEvidence(
                    id: "scope",
                    title: "Autostart-Bereich",
                    summary: "Der fehlende Hinweis gehörte zum Bereich: \(scopeTitle).",
                    detail: item.scope.userExplanation
                ),
            ],
            recommendations: [
                FindingRecommendation(
                    id: "trust-startup-removal",
                    title: "Dieses Verschwinden als erwartet merken",
                    explanation: "Nutze das, wenn der fehlende Autostart-Hinweis zu einer erwarteten Software-Änderung passt, etwa Deinstallation oder Aufräumen.",
                    action: .trustItem
                ),
                FindingRecommendation(
                    id: "validate-startup-removal",
                    title: "Dieses Verschwinden weiter beobachten",
                    explanation: "Nutze später einen begrenzten Prüfschritt, wenn das Verschwinden unerwartet wirkt und du mehr Belege brauchst.",
                    action: .runSafeValidation
                ),
            ]
        )
    }

    private func makeNotes(
        for items: [LaunchAgentItem],
        directories: [URL],
        baselineState: StartupItemBaselineState
    ) -> [String] {
        var notes: [String] = []

        if items.isEmpty {
            let joinedDirectories = directories.map(\.path).joined(separator: ", ")
            notes.append("Keine sichtbaren Autostart-plist-Dateien gefunden in: \(joinedDirectories).")
        } else {
            notes.append("\(items.count) sichtbare Autostart-plist-Datei(en) gefunden.")
        }

        notes.append(baselineNote(for: baselineState, currentItems: items))

        return notes
    }

    private func makeFallbackNotes(
        for items: [LaunchAgentItem],
        directories: [URL],
        error: Error
    ) -> [String] {
        var notes: [String] = []

        if items.isEmpty {
            let joinedDirectories = directories.map(\.path).joined(separator: ", ")
            notes.append("Keine sichtbaren Autostart-plist-Dateien gefunden in: \(joinedDirectories).")
        } else {
            notes.append("\(items.count) sichtbare Autostart-plist-Datei(en) gefunden.")
        }

        notes.append("Die Autostart-Änderungserkennung ist in diesem Lauf eingeschränkt, weil der lokal gemerkte Zustand nicht geladen oder gespeichert werden konnte: \(error.localizedDescription)")
        return notes
    }

    private func baselineNote(
        for state: StartupItemBaselineState,
        currentItems: [LaunchAgentItem]
    ) -> String {
        switch state.status {
        case .createdInitialSnapshot:
            return "Ersten lokalen Autostart-Zustand mit \(state.snapshot.items.count) Eintrag/Einträgen gemerkt. Spätere Läufe können damit vergleichen."
        case .loadedExistingSnapshot:
            let diff = compare(items: currentItems, against: state.snapshot.items)
            if diff.added.isEmpty && diff.removed.isEmpty {
                return "Der aktuelle Autostart-Zustand entspricht dem lokal gemerkten Zustand."
            }

            return "Mit dem lokal gemerkten Zustand verglichen: \(diff.added.count) neue Einträge, \(diff.removed.count) verschwundene Einträge."
        }
    }

    private func compare(
        items currentItems: [LaunchAgentItem],
        against baselineItems: [LaunchAgentItem]
    ) -> StartupItemBaselineDiff {
        let currentByID = Dictionary(uniqueKeysWithValues: currentItems.map { ($0.id, $0) })
        let baselineByID = Dictionary(uniqueKeysWithValues: baselineItems.map { ($0.id, $0) })
        let currentIDs = Set(currentByID.keys)
        let baselineIDs = Set(baselineByID.keys)

        let added = currentIDs
            .subtracting(baselineIDs)
            .compactMap { currentByID[$0] }
            .sorted { $0.id < $1.id }

        let removed = baselineIDs
            .subtracting(currentIDs)
            .compactMap { baselineByID[$0] }
            .sorted { $0.id < $1.id }

        let unchanged = currentIDs
            .intersection(baselineIDs)
            .compactMap { currentByID[$0] }
            .sorted { $0.id < $1.id }

        return StartupItemBaselineDiff(
            added: added,
            removed: removed,
            unchanged: unchanged
        )
    }

    private func formattedTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

private typealias LaunchAgentItem = StartupItemRecord

private struct StartupItemBaselineDiff: Hashable, Sendable {
    let added: [LaunchAgentItem]
    let removed: [LaunchAgentItem]
    let unchanged: [LaunchAgentItem]
}

private extension StartupItemScope {
    var title: String {
        switch self {
        case .userAgent:
            return "Benutzer"
        case .sharedAgent:
            return "Gemeinsam"
        case .sharedDaemon:
            return "Systemweit"
        }
    }

    var defaultSeverity: FindingSeverity {
        switch self {
        case .userAgent:
            return .medium
        case .sharedAgent:
            return .medium
        case .sharedDaemon:
            return .high
        }
    }

    var removalSeverity: FindingSeverity {
        switch self {
        case .userAgent:
            return .low
        case .sharedAgent:
            return .low
        case .sharedDaemon:
            return .medium
        }
    }

    var userExplanation: String {
        switch self {
        case .userAgent:
            return "Autostart-Hinweise für den Benutzer betreffen normalerweise das angemeldete Konto und werden oft von installierten Apps angelegt."
        case .sharedAgent:
            return "Gemeinsame Autostart-Hinweise können mehrere Benutzer dieses Macs betreffen und verdienen deshalb etwas mehr Aufmerksamkeit."
        case .sharedDaemon:
            return "Systemweite Hintergrunddienste können in einem stärkeren systemweiten Bereich starten und sollten deshalb genauer angesehen werden."
        }
    }
}
