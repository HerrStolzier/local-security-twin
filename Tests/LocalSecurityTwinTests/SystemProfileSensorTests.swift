import Foundation
import Testing
@testable import LocalSecurityTwin

struct SystemProfileSensorTests {
    @Test func completeSnapshotCreatesCalmSystemProfileFinding() throws {
        let sensor = SystemProfileSensor(
            snapshotProvider: StubSystemProfileProvider(
                snapshot: SystemProfileSnapshot(
                    operatingSystemVersion: "Version 15.5",
                    architecture: "arm64",
                    computerName: "Test-Mac",
                    gatekeeperStatus: GatekeeperStatus.parse("assessments enabled"),
                    sipStatus: SystemProtectionStatus(
                        summary: "System Integrity Protection ist sichtbar aktiv.",
                        rawOutput: "System Integrity Protection status: enabled."
                    ),
                    fileVaultStatus: FileVaultStatus.parse("FileVault is On."),
                    firewallStatus: FirewallStatus.parse("Firewall is enabled. (State = 1)"),
                    unavailableChecks: []
                )
            )
        )

        let run = sensor.run(
            in: SensorContext(
                homeDirectoryURL: URL(fileURLWithPath: "/tmp/test-home", isDirectory: true),
                now: Date(timeIntervalSince1970: 1_000)
            )
        )

        #expect(run.sensor.id == "system-profile")
        #expect(run.findings.count == 2)
        #expect(run.findings.allSatisfy { $0.source.kind == .systemInventory })
        #expect(run.findings.contains(where: { $0.id == "system-profile::local-context" }))
        #expect(run.findings.contains(where: { $0.id == "system-profile::gatekeeper-enabled" }))
        #expect(run.findings.first { $0.id == "system-profile::local-context" }?.evidence.contains { $0.id == "sip-status" } == true)
        #expect(run.findings.first { $0.id == "system-profile::local-context" }?.evidence.contains { $0.id == "filevault-status" } == true)
        #expect(run.findings.first { $0.id == "system-profile::local-context" }?.evidence.contains { $0.id == "firewall-status" } == true)
        #expect(run.findings.allSatisfy { !$0.userImpact.contains("vollständig geschützt ist.") || $0.severity == .low })
        #expect(run.notes.contains(where: { $0.contains("Lokales Systemprofil gelesen") }))
    }

    @Test func disabledGatekeeperCreatesClearButBoundedFinding() throws {
        let sensor = SystemProfileSensor(
            snapshotProvider: StubSystemProfileProvider(
                snapshot: SystemProfileSnapshot(
                    operatingSystemVersion: "Version 15.5",
                    architecture: "arm64",
                    computerName: nil,
                    gatekeeperStatus: GatekeeperStatus.parse("assessments disabled"),
                    sipStatus: nil,
                    fileVaultStatus: nil,
                    firewallStatus: nil,
                    unavailableChecks: ["SIP-Status"]
                )
            )
        )

        let run = sensor.run(
            in: SensorContext(
                homeDirectoryURL: URL(fileURLWithPath: "/tmp/test-home", isDirectory: true),
                now: Date(timeIntervalSince1970: 1_000)
            )
        )

        let gatekeeperFinding = try #require(
            run.findings.first { $0.id == "system-profile::gatekeeper-disabled" }
        )
        #expect(gatekeeperFinding.severity == .high)
        #expect(gatekeeperFinding.confidence == .supported)
        #expect(gatekeeperFinding.title == "Mac-App-Prüfung ist deaktiviert")
        #expect(gatekeeperFinding.nextStep.contains("Die App ändert sie nicht automatisch"))
        #expect(!gatekeeperFinding.summary.localizedCaseInsensitiveContains("kompromittiert"))
        #expect(run.notes.contains(where: { $0.contains("SIP-Status") }))
    }

    @Test func unavailableOptionalChecksStayAsNotes() throws {
        let sensor = SystemProfileSensor(
            snapshotProvider: StubSystemProfileProvider(
                snapshot: SystemProfileSnapshot(
                    operatingSystemVersion: "Version 15.5",
                    architecture: "arm64",
                    computerName: nil,
                    gatekeeperStatus: nil,
                    sipStatus: nil,
                    fileVaultStatus: nil,
                    firewallStatus: nil,
                    unavailableChecks: ["Gatekeeper-Status", "SIP-Status"]
                )
            )
        )

        let run = sensor.run(
            in: SensorContext(
                homeDirectoryURL: URL(fileURLWithPath: "/tmp/test-home", isDirectory: true),
                now: Date(timeIntervalSince1970: 1_000)
            )
        )

        #expect(run.findings.count == 1)
        #expect(run.findings.first?.id == "system-profile::local-context")
        #expect(run.notes.contains(where: { $0.contains("Gatekeeper-Status") }))
    }

    @Test func livePipelineContainsStartupAndSystemProfileSensors() {
        let sensorIDs = SensorPipeline.live().sensors.map(\.descriptor.id)

        #expect(sensorIDs.contains("launch-agent-inventory"))
        #expect(sensorIDs.contains("system-profile"))
    }

    @Test func fileVaultAndFirewallParsersStayBounded() {
        #expect(FileVaultStatus.parse("FileVault is On.").state == .enabled)
        #expect(FileVaultStatus.parse("FileVault is Off.").state == .disabled)
        #expect(FileVaultStatus.parse("Something else").state == .unknown)

        #expect(FirewallStatus.parse("Firewall is enabled. (State = 1)").state == .enabled)
        #expect(FirewallStatus.parse("Firewall is disabled. (State = 0)").state == .disabled)
        #expect(FirewallStatus.parse("Something else").state == .unknown)
    }

    @Test func dashboardPresentationHandlesSystemOnlyFindings() {
        let finding = Finding(
            id: "system-profile::local-context",
            title: "Mac-Grunddaten sind sichtbar",
            source: FindingSource(
                kind: .systemInventory,
                title: "Mac-Systemprofil",
                detail: "Test"
            ),
            severity: .low,
            confidence: .supported,
            summary: "Die App konnte lokale Basisdaten dieses Macs lesen.",
            userImpact: "Test",
            nextStep: "Test",
            evidence: [],
            recommendations: []
        )

        let presentation = DashboardPresentation(findings: [finding])

        #expect(presentation.headlineText.contains("lokale Systemhinweis"))
        #expect(presentation.summaryText.contains("kein vollständiges Sicherheitsurteil"))
        #expect(finding.displayTitle == "Mac-Grunddaten sind sichtbar")
        #expect(finding.displaySourceTitle == "Mac-Systemprofil")
    }
}

private struct StubSystemProfileProvider: SystemProfileSnapshotProviding {
    let storedSnapshot: SystemProfileSnapshot

    init(snapshot: SystemProfileSnapshot) {
        self.storedSnapshot = snapshot
    }

    func snapshot() -> SystemProfileSnapshot {
        storedSnapshot
    }
}
