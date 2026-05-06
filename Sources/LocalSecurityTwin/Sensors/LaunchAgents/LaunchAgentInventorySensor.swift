import Foundation

struct LaunchAgentInventorySensor: StartupBaselineRefreshingSensor {
    let descriptor = SensorDescriptor(
        id: "launch-agent-inventory",
        title: "Launch Agent Inventory",
        summary: "Looks for visible startup item plist files in user and shared launch-agent folders."
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
            return bool ? "Always tries to stay available" : "Does not request constant launchd keep-alive"
        case let dictionary as [String: Any]:
            if dictionary.isEmpty {
                return nil
            }

            return "Uses conditional keep-alive rules: \(dictionary.keys.sorted().joined(separator: ", "))"
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
            title: "\(scopeTitle) background startup hint is visible",
            source: FindingSource(
                kind: .launchAgentInventory,
                title: "Visible Startup Hints",
                detail: "Looks for visible startup item plist files in user and shared launch-agent folders."
            ),
            severity: item.scope.defaultSeverity,
            confidence: .supported,
            summary: "\(fileName) is visible in a location macOS can use for automatic background startup.",
            userImpact: "This is a startup hint, not proof that the software is running or dangerous. It matters because items in these locations can make software available in the background after login or boot.",
            nextStep: "Check whether this item belongs to software you expected. If yes, you can mark it as expected. If not, keep it under review before treating it as normal.",
            evidence: startupEvidence(for: item, scopeTitle: scopeTitle) + [
                FindingEvidence(
                    id: "path",
                    title: "Observed file",
                    summary: "A plist file was found at \(item.path).",
                    detail: "This sensor reports visible filesystem evidence. It does not prove the item is currently loaded or running."
                ),
                FindingEvidence(
                    id: "scope",
                    title: "Startup scope",
                    summary: "The item sits in the \(scopeTitle.lowercased()) scope.",
                    detail: item.scope.userExplanation
                ),
            ],
            recommendations: [
                FindingRecommendation(
                    id: "trust-launch-item",
                    title: "Mark this startup item as expected",
                    explanation: "Use this if you recognize the item and do not want it to keep surfacing as a surprise.",
                    action: .trustItem
                ),
                FindingRecommendation(
                    id: "validate-launch-item",
                    title: "Keep this item under review",
                    explanation: "Use a bounded validation step later if you want stronger proof before trusting or escalating this startup item.",
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
                    title: "Startup file details",
                    summary: "The plist file was visible, but the app could not read simple launch details from it.",
                    detail: "This can happen when the file is empty, malformed, or uses a shape this first reader does not understand yet. The file path evidence is still preserved."
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
            lines.append("No simple Label, Program, ProgramArguments, RunAtLoad, or KeepAlive values were present.")
        }

        return [
            FindingEvidence(
                id: "plist-details",
                title: "Startup file details",
                summary: "The plist file contains readable launch details for this \(scopeTitle.lowercased()) startup hint.",
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
            title: "\(scopeTitle) startup hint is new since the remembered state",
            source: FindingSource(
                kind: .baselineDiff,
                title: "Startup change since remembered state",
                detail: "Compared the latest visible startup hints with the stored local known state."
            ),
            severity: item.scope.defaultSeverity,
            confidence: .supported,
            summary: "\(item.fileName) was not part of the remembered startup state and is now visible in an automatic startup location.",
            userImpact: "A newly visible startup hint is often normal after an install or update. It still deserves a calm review because it may affect what can start in the background.",
            nextStep: "Check whether you expected this software change. If yes, you can mark the current startup state as expected. If not, keep it under review before treating it as normal.",
            evidence: startupEvidence(for: item, scopeTitle: scopeTitle) + [
                FindingEvidence(
                    id: "baseline-comparison",
                    title: "Change since remembered state",
                    summary: "The remembered state from \(baselineTimestamp) did not include this startup hint.",
                    detail: "The app compared the current visible startup set against a local known state saved earlier on this Mac."
                ),
                FindingEvidence(
                    id: "current-path",
                    title: "Current observed file",
                    summary: "A plist file is currently visible at \(item.path).",
                    detail: "This means the item is visible now, even though it was not part of the remembered baseline snapshot."
                ),
                FindingEvidence(
                    id: "scope",
                    title: "Startup scope",
                    summary: "The item sits in the \(scopeTitle.lowercased()) scope.",
                    detail: item.scope.userExplanation
                ),
            ],
            recommendations: [
                FindingRecommendation(
                    id: "trust-startup-change",
                    title: "Mark this startup change as expected",
                    explanation: "Use this if you recognize the new startup item and do not want it to keep surfacing as a surprise.",
                    action: .trustItem
                ),
                FindingRecommendation(
                    id: "validate-startup-change",
                    title: "Keep this change under review",
                    explanation: "Use a bounded validation step later if you want stronger proof before trusting or escalating this startup change.",
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
            title: "\(scopeTitle) startup hint disappeared since the remembered state",
            source: FindingSource(
                kind: .baselineDiff,
                title: "Startup change since remembered state",
                detail: "Compared the latest visible startup hints with the stored local known state."
            ),
            severity: item.scope.removalSeverity,
            confidence: .supported,
            summary: "\(item.fileName) was present in the remembered startup state but is no longer visible in its previous startup location.",
            userImpact: "A disappeared startup hint is often harmless after an uninstall or update. It simply means the visible startup set changed since the app last remembered it.",
            nextStep: "If you recently removed or updated the related software, this is likely expected. If not, keep an eye on whether the item returns or whether other startup behavior changes around it.",
            evidence: [
                FindingEvidence(
                    id: "baseline-comparison",
                    title: "Change since remembered state",
                    summary: "The remembered state from \(baselineTimestamp) included this startup hint, but the current snapshot does not.",
                    detail: "This is a disappearance relative to the remembered local state, not proof of malicious behavior on its own."
                ),
                FindingEvidence(
                    id: "previous-path",
                    title: "Previously observed file",
                    summary: "The baseline recorded the item at \(item.path).",
                    detail: "The current sensor run no longer sees a plist file at that stored startup path."
                ),
                FindingEvidence(
                    id: "scope",
                    title: "Startup scope",
                    summary: "The missing item belonged to the \(scopeTitle.lowercased()) scope.",
                    detail: item.scope.userExplanation
                ),
            ],
            recommendations: [
                FindingRecommendation(
                    id: "trust-startup-removal",
                    title: "Mark this disappearance as expected",
                    explanation: "Use this if the missing startup item matches a software change you expected, such as an uninstall or cleanup.",
                    action: .trustItem
                ),
                FindingRecommendation(
                    id: "validate-startup-removal",
                    title: "Keep this disappearance under review",
                    explanation: "Use a bounded validation step later if the disappearance feels unexpected and you want more proof before escalating.",
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
            notes.append("No visible startup plist files were found in: \(joinedDirectories).")
        } else {
            notes.append("Detected \(items.count) visible startup plist file(s).")
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
            notes.append("No visible startup plist files were found in: \(joinedDirectories).")
        } else {
            notes.append("Detected \(items.count) visible startup plist file(s).")
        }

        notes.append("Startup change detection is limited in this run because the remembered local state could not be loaded or saved: \(error.localizedDescription)")
        return notes
    }

    private func baselineNote(
        for state: StartupItemBaselineState,
        currentItems: [LaunchAgentItem]
    ) -> String {
        switch state.status {
        case .createdInitialSnapshot:
            return "Saved the first local startup baseline with \(state.snapshot.items.count) item(s). Later runs can compare against this remembered starting point."
        case .loadedExistingSnapshot:
            let diff = compare(items: currentItems, against: state.snapshot.items)
            if diff.added.isEmpty && diff.removed.isEmpty {
                return "Current startup snapshot matches the stored local baseline."
            }

            return "Compared against the stored local baseline: \(diff.added.count) new item(s), \(diff.removed.count) missing item(s)."
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
            return "User"
        case .sharedAgent:
            return "Shared"
        case .sharedDaemon:
            return "Shared daemon"
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
            return "User launch agents normally affect the logged-in user account and are often created by installed apps."
        case .sharedAgent:
            return "Shared launch agents can affect multiple users on the Mac and deserve a slightly stronger review."
        case .sharedDaemon:
            return "Shared launch daemons can start in a more privileged system-wide scope, so they deserve closer attention."
        }
    }
}
