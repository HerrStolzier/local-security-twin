import Foundation

struct SystemProfileSensor: FindingSensor {
    let descriptor = SensorDescriptor(
        id: "system-profile",
        title: "Mac-Systemprofil",
        summary: "Liest lokale Basisdaten und sichtbare Schutzsignale ohne Zusatzrechte."
    )

    private let snapshotProvider: any SystemProfileSnapshotProviding

    init(snapshotProvider: any SystemProfileSnapshotProviding = LiveSystemProfileSnapshotProvider()) {
        self.snapshotProvider = snapshotProvider
    }

    func run(in context: SensorContext) -> SensorRun {
        let snapshot = snapshotProvider.snapshot()
        let findings = makeFindings(from: snapshot)
        let notes = makeNotes(from: snapshot)

        return SensorRun(
            sensor: descriptor,
            findings: findings,
            notes: notes,
            completedAt: context.now
        )
    }

    private func makeFindings(from snapshot: SystemProfileSnapshot) -> [Finding] {
        [makeProfileFinding(from: snapshot)] + makeGatekeeperFinding(from: snapshot)
    }

    private func makeProfileFinding(from snapshot: SystemProfileSnapshot) -> Finding {
        Finding(
            id: "system-profile::local-context",
            title: "Mac-Grunddaten sind sichtbar",
            source: source,
            severity: .low,
            confidence: .supported,
            summary: "Die App konnte lokale Basisdaten dieses Macs lesen.",
            userImpact: "Diese Angaben helfen, spätere Hinweise richtig einzuordnen. Sie beweisen nicht, dass der Mac vollständig geschützt ist.",
            nextStep: "Keine schnelle Aktion nötig. Behalte die Hinweise im Blick und prüfe Abweichungen in Ruhe.",
            evidence: [
                FindingEvidence(
                    id: "system-profile",
                    title: "Lokales Systemprofil",
                    summary: "macOS \(snapshot.operatingSystemVersion), Architektur \(snapshot.architecture).",
                    detail: profileDetail(from: snapshot)
                ),
            ] + sipEvidence(from: snapshot),
            recommendations: [
                FindingRecommendation(
                    id: "review-system-profile",
                    title: "Systemprofil in Ruhe prüfen",
                    explanation: "Nutze das, wenn du die lokalen Basisdaten als Orientierung ansehen möchtest. Die App ändert dabei nichts am System.",
                    action: .runSafeValidation
                ),
            ]
        )
    }

    private func makeGatekeeperFinding(from snapshot: SystemProfileSnapshot) -> [Finding] {
        guard let gatekeeperStatus = snapshot.gatekeeperStatus else {
            return []
        }

        switch gatekeeperStatus.state {
        case .enabled:
            return [
                Finding(
                    id: "system-profile::gatekeeper-enabled",
                    title: "Mac-App-Prüfung ist aktiv",
                    source: source,
                    severity: .low,
                    confidence: .supported,
                    summary: "macOS meldet, dass die App-Prüfung für heruntergeladene Apps aktiv ist.",
                    userImpact: "Diese Prüfung kann helfen, bekannte unsichere oder nicht vertrauenswürdige Apps vor dem Öffnen zu blockieren. Sie ist aber kein vollständiger Schutz für alles, was auf dem Mac passiert.",
                    nextStep: "Keine schnelle Aktion nötig. Wichtig ist nur, dass diese Sicht ein Schutzsignal ist, kein Gesamturteil über den Mac.",
                    evidence: [gatekeeperEvidence(from: gatekeeperStatus)],
                    recommendations: [
                        FindingRecommendation(
                            id: "review-gatekeeper-status",
                            title: "App-Prüfung als sichtbares Schutzsignal merken",
                            explanation: "Nutze das als lokale Einordnung. Die App ändert die Gatekeeper-Einstellung nicht.",
                            action: .runSafeValidation
                        ),
                    ]
                ),
            ]
        case .disabled:
            return [
                Finding(
                    id: "system-profile::gatekeeper-disabled",
                    title: "Mac-App-Prüfung ist deaktiviert",
                    source: source,
                    severity: .high,
                    confidence: .supported,
                    summary: "macOS meldet, dass die App-Prüfung für heruntergeladene Apps nicht aktiv ist.",
                    userImpact: "Wenn diese Einstellung nicht bewusst so gewählt wurde, können heruntergeladene Apps weniger stark vor dem Öffnen eingeordnet werden.",
                    nextStep: "Prüfe in den macOS-Systemeinstellungen, ob diese Einstellung bewusst so gewählt wurde. Die App ändert sie nicht automatisch.",
                    evidence: [gatekeeperEvidence(from: gatekeeperStatus)],
                    recommendations: [
                        FindingRecommendation(
                            id: "review-disabled-gatekeeper",
                            title: "Einstellung manuell prüfen",
                            explanation: "Nutze das, um die sichtbare Einstellung bewusst einzuordnen. Die App nimmt keine Systemänderung vor.",
                            action: .runSafeValidation
                        ),
                    ]
                ),
            ]
        case .unknown:
            return [
                Finding(
                    id: "system-profile::gatekeeper-unknown",
                    title: "Mac-App-Prüfung konnte nicht eindeutig gelesen werden",
                    source: source,
                    severity: .low,
                    confidence: .tentative,
                    summary: "Die lokale Gatekeeper-Meldung war sichtbar, aber nicht eindeutig genug für eine klare Einordnung.",
                    userImpact: "Das ist zuerst nur eine Sichtgrenze. Es bedeutet nicht automatisch, dass die App-Prüfung aus ist.",
                    nextStep: "Behandle diesen Hinweis als eingeschränkte Sicht und prüfe ihn später erneut, wenn er wichtig wird.",
                    evidence: [gatekeeperEvidence(from: gatekeeperStatus)],
                    recommendations: []
                ),
            ]
        }
    }

    private var source: FindingSource {
        FindingSource(
            kind: .systemInventory,
            title: "Mac-Systemprofil",
            detail: "Liest lokale Basisdaten und sichtbare Schutzsignale ohne Zusatzrechte."
        )
    }

    private func profileDetail(from snapshot: SystemProfileSnapshot) -> String {
        var lines = [
            "macOS: \(snapshot.operatingSystemVersion)",
            "Architektur: \(snapshot.architecture)",
        ]

        if let computerName = snapshot.computerName {
            lines.append("Computername: \(computerName)")
        }

        if let sipStatus = snapshot.sipStatus {
            lines.append("SIP: \(sipStatus.summary)")
        }

        if !snapshot.unavailableChecks.isEmpty {
            lines.append("Nicht verfügbar: \(snapshot.unavailableChecks.joined(separator: ", "))")
        }

        return lines.joined(separator: "\n")
    }

    private func gatekeeperEvidence(from status: GatekeeperStatus) -> FindingEvidence {
        FindingEvidence(
            id: "gatekeeper-status",
            title: "Gatekeeper-Status",
            summary: status.summary,
            detail: "Rohmeldung: \(status.rawOutput)"
        )
    }

    private func sipEvidence(from snapshot: SystemProfileSnapshot) -> [FindingEvidence] {
        guard let sipStatus = snapshot.sipStatus else {
            return []
        }

        return [
            FindingEvidence(
                id: "sip-status",
                title: "System Integrity Protection",
                summary: sipStatus.summary,
                detail: "Rohmeldung: \(sipStatus.rawOutput)"
            ),
        ]
    }

    private func makeNotes(from snapshot: SystemProfileSnapshot) -> [String] {
        var notes = [
            "Lokales Systemprofil gelesen: macOS \(snapshot.operatingSystemVersion), \(snapshot.architecture).",
        ]

        if !snapshot.unavailableChecks.isEmpty {
            notes.append("Einige optionale Systemprofil-Checks waren nicht verfügbar: \(snapshot.unavailableChecks.joined(separator: ", ")).")
        }

        return notes
    }
}

protocol SystemProfileSnapshotProviding {
    func snapshot() -> SystemProfileSnapshot
}

struct SystemProfileSnapshot: Hashable, Sendable {
    let operatingSystemVersion: String
    let architecture: String
    let computerName: String?
    let gatekeeperStatus: GatekeeperStatus?
    let sipStatus: SystemProtectionStatus?
    let unavailableChecks: [String]
}

struct GatekeeperStatus: Hashable, Sendable {
    enum State: Hashable, Sendable {
        case enabled
        case disabled
        case unknown
    }

    let state: State
    let rawOutput: String

    var summary: String {
        switch state {
        case .enabled:
            return "Gatekeeper meldet: App-Prüfung aktiv."
        case .disabled:
            return "Gatekeeper meldet: App-Prüfung deaktiviert."
        case .unknown:
            return "Gatekeeper meldet keinen eindeutig verstandenen Status."
        }
    }

    static func parse(_ output: String) -> GatekeeperStatus {
        let normalized = output.lowercased()

        if normalized.contains("assessments enabled") {
            return GatekeeperStatus(state: .enabled, rawOutput: output)
        }

        if normalized.contains("assessments disabled") {
            return GatekeeperStatus(state: .disabled, rawOutput: output)
        }

        return GatekeeperStatus(state: .unknown, rawOutput: output)
    }
}

struct SystemProtectionStatus: Hashable, Sendable {
    let summary: String
    let rawOutput: String
}

struct LiveSystemProfileSnapshotProvider: SystemProfileSnapshotProviding {
    func snapshot() -> SystemProfileSnapshot {
        var unavailableChecks: [String] = []

        let gatekeeperStatus: GatekeeperStatus?
        if let output = try? runCommand(path: "/usr/sbin/spctl", arguments: ["--status"]), !output.isEmpty {
            gatekeeperStatus = GatekeeperStatus.parse(output)
        } else {
            gatekeeperStatus = nil
            unavailableChecks.append("Gatekeeper-Status")
        }

        let sipStatus: SystemProtectionStatus?
        if let output = try? runCommand(path: "/usr/bin/csrutil", arguments: ["status"]), !output.isEmpty {
            sipStatus = SystemProtectionStatus(summary: readableSIPSummary(from: output), rawOutput: output)
        } else {
            sipStatus = nil
            unavailableChecks.append("SIP-Status")
        }

        return SystemProfileSnapshot(
            operatingSystemVersion: ProcessInfo.processInfo.operatingSystemVersionString,
            architecture: machineArchitecture(),
            computerName: Host.current().localizedName,
            gatekeeperStatus: gatekeeperStatus,
            sipStatus: sipStatus,
            unavailableChecks: unavailableChecks
        )
    }

    private func runCommand(path: String, arguments: [String], timeout: TimeInterval = 2) throws -> String {
        let process = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()

        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = arguments
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        try process.run()

        let deadline = Date().addingTimeInterval(timeout)
        while process.isRunning && Date() < deadline {
            Thread.sleep(forTimeInterval: 0.02)
        }

        if process.isRunning {
            process.terminate()
            throw SystemProfileCommandError.timedOut(path)
        }

        let output = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorOutput = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let combined = output + errorOutput

        return String(decoding: combined, as: UTF8.self)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func machineArchitecture() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)

        return withUnsafePointer(to: &systemInfo.machine) { pointer in
            pointer.withMemoryRebound(to: CChar.self, capacity: 1) { cString in
                String(cString: cString)
            }
        }
    }

    private func readableSIPSummary(from output: String) -> String {
        let normalized = output.lowercased()

        if normalized.contains("enabled") {
            return "System Integrity Protection ist sichtbar aktiv."
        }

        if normalized.contains("disabled") {
            return "System Integrity Protection ist sichtbar deaktiviert."
        }

        return "System Integrity Protection konnte nicht eindeutig eingeordnet werden."
    }
}

private enum SystemProfileCommandError: LocalizedError {
    case timedOut(String)

    var errorDescription: String? {
        switch self {
        case let .timedOut(path):
            return "\(path) hat nicht rechtzeitig geantwortet."
        }
    }
}
