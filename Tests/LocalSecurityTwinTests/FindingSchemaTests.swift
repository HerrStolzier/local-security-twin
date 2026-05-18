import Foundation
import Testing
@testable import LocalSecurityTwin

struct FindingSchemaTests {
    @Test func findingSchemaRoundTripsThroughJSON() throws {
        let finding = try #require(Finding.samples.first)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(finding)
        let decoded = try decoder.decode(Finding.self, from: data)

        #expect(decoded == finding)
    }

    @Test func findingPolicyRequestUsesSeverityRiskAndEvidence() throws {
        let finding = try #require(Finding.samples.last)
        let recommendation = try #require(finding.recommendations.first)

        let request = finding.policyRequest(for: recommendation)

        #expect(request.risk == .high)
        #expect(request.subject.identifier == finding.id)
        #expect(request.reason == recommendation.explanation)
        #expect(request.evidenceSummary.contains("granted permission"))
    }

    @Test func startupFindingPresentationExtractsUsefulDetails() throws {
        let finding = Finding(
            id: "launch-item::sharedDaemon::/Library/LaunchDaemons/com.example.agent.plist",
            title: "Shared daemon background startup hint is visible",
            source: FindingSource(
                kind: .launchAgentInventory,
                title: "Visible Startup Hints",
                detail: "Test"
            ),
            severity: .high,
            confidence: .supported,
            summary: "com.example.agent.plist is visible in a location macOS can use for automatic background startup.",
            userImpact: "Test",
            nextStep: "Test",
            evidence: [
                FindingEvidence(
                    id: "plist-details",
                    title: "Startup file details",
                    summary: "Readable",
                    detail: """
                    Label: com.example.agent
                    Program arguments: /usr/bin/true --background
                    Run at load: yes
                    Keep alive: Always tries to stay available
                    """
                ),
                FindingEvidence(
                    id: "path",
                    title: "Observed file",
                    summary: "A plist file was found at /Library/LaunchDaemons/com.example.agent.plist.",
                    detail: "Test"
                ),
            ],
            recommendations: []
        )

        #expect(finding.displayTitle == "Systemweiter Autostart-Hinweis")
        #expect(finding.displaySubject == "com.example.agent.plist")
        #expect(finding.startupLabel == "com.example.agent")
        #expect(finding.startupProgramArguments == "/usr/bin/true --background")
        #expect(finding.startupRunAtLoadText == "Kann beim Laden automatisch starten")
        #expect(finding.startupKeepAliveText == "Soll im Hintergrund verfügbar bleiben")
        #expect(finding.startupFilePath == "/Library/LaunchDaemons/com.example.agent.plist")
    }

    @Test func dashboardPresentationExplainsNextStepForStartupChanges() throws {
        let finding = Finding(
            id: "baseline-diff::added::sharedDaemon::/Library/LaunchDaemons/com.example.agent.plist",
            title: "Systemweit Autostart-Hinweis ist seit dem gemerkten Zustand neu",
            source: FindingSource(
                kind: .baselineDiff,
                title: "Autostart-Änderung seit gemerktem Zustand",
                detail: "Test"
            ),
            severity: .high,
            confidence: .supported,
            summary: "com.example.agent.plist ist seit dem gemerkten Zustand neu sichtbar.",
            userImpact: "Test",
            nextStep: "Test",
            evidence: [],
            recommendations: []
        )

        let presentation = DashboardPresentation(findings: [finding])

        #expect(presentation.headlineText.contains("Autostart-Änderung"))
        #expect(presentation.statusTitle == "Bitte kurz prüfen")
        #expect(presentation.buddyMessageText.contains("Veränderung im Autostart"))
        #expect(presentation.primaryActionTitle == "Neue Änderung ansehen")
        #expect(presentation.nextStepText.contains("Prüfe zuerst"))
        #expect(presentation.visibilityText.contains("kein Beweis"))
        #expect(presentation.showsRememberCurrentStartupStateAction)
        #expect(presentation.guardianTone == "Aufmerksam")
        #expect(presentation.missions.first?.title == "Autostart einordnen")
        #expect(presentation.missions.first?.findingID == finding.id)
        #expect(presentation.activityItems.first?.title.contains("neue Autostart-Änderung") == true)
    }

    @Test func dashboardPresentationSummarizesRepeatedKnownStartupHints() throws {
        let first = Finding(
            id: "launch-item::sharedDaemon::/Library/LaunchDaemons/com.example.one.plist",
            title: "Systemweiter Autostart-Hinweis",
            source: FindingSource(
                kind: .launchAgentInventory,
                title: "Sichtbare Autostart-Hinweise",
                detail: "Test"
            ),
            severity: .medium,
            confidence: .supported,
            summary: "com.example.one.plist liegt an einem Ort, den macOS für automatischen Hintergrundstart nutzen kann.",
            userImpact: "Test",
            nextStep: "Test",
            evidence: [],
            recommendations: []
        )
        let second = Finding(
            id: "launch-item::sharedDaemon::/Library/LaunchDaemons/com.example.two.plist",
            title: "Systemweiter Autostart-Hinweis",
            source: FindingSource(
                kind: .launchAgentInventory,
                title: "Sichtbare Autostart-Hinweise",
                detail: "Test"
            ),
            severity: .medium,
            confidence: .supported,
            summary: "com.example.two.plist liegt an einem Ort, den macOS für automatischen Hintergrundstart nutzen kann.",
            userImpact: "Test",
            nextStep: "Test",
            evidence: [],
            recommendations: []
        )

        let presentation = DashboardPresentation(findings: [first, second])

        #expect(presentation.statusTitle == "Zur Beobachtung")
        #expect(presentation.primaryActionTitle == "Hinweise ansehen")
        #expect(presentation.buddyMessageText.contains("bekannte Autostart-Hinweise"))
        #expect(presentation.knownStartupSummaryText == "2 bekannte Autostart-Hinweise zusammengefasst. Öffne die Einzelhinweise nur, wenn du eine bestimmte App genauer ansehen willst.")
        #expect(presentation.guardianTone == "Beobachtet")
        #expect(presentation.missions.first?.title == "Autostart verstehen")
        #expect(presentation.missions.first?.findingID == first.id)
        #expect(presentation.missions.map(\.title).contains("Digitaler Fußabdruck"))
        #expect(presentation.missions.map(\.title).contains("App-Risiken prüfen"))
        #expect(presentation.activityItems.contains { $0.id == "known-startup" })
    }

    @Test func dashboardPresentationCreatesCalmBuddyHomeWhenNoFindingsExist() {
        let presentation = DashboardPresentation(findings: [])

        #expect(presentation.statusTitle == "Alles ruhig")
        #expect(presentation.guardianTone == "Stabil")
        #expect(presentation.primaryActionTitle == "Nichts zu tun")
        #expect(presentation.missions.first?.status == "Ruhig")
        #expect(presentation.missions.first?.findingID == nil)
        #expect(presentation.activityItems.first?.id == "startup-stable")
    }

    @Test func dashboardPresentationSurfacesHygieneEvidenceTypesWithoutClaimingChecks() throws {
        let presentation = DashboardPresentation(findings: [])
        let hygieneMission = try #require(presentation.missions.first { $0.id == "hygiene" })

        #expect(hygieneMission.status == "Erste Orientierung")
        #expect(hygieneMission.summary.contains("lokal"))
        #expect(hygieneMission.summary.contains("bewusst"))
        #expect(hygieneMission.findingID == nil)
    }

    @Test func dashboardPresentationGroupsHygieneOverviewByEvidenceKind() throws {
        let presentation = DashboardPresentation(findings: [])

        let local = try #require(presentation.hygieneOverviewItems.first { $0.id == SecurityHygieneEvidenceKind.observedLocally.rawValue })
        #expect(local.title == "Kann Sento lokal sehen")
        #expect(local.checks.contains { $0.title == "macOS-Updates" && $0.status == "Noch kein Vergleich" })
        #expect(local.checks.contains { $0.title == "FileVault" && $0.status == "Noch nicht geprüft" })
        #expect(local.checks.contains { $0.title == "Firewall" && $0.status == "Noch nicht geprüft" })
        #expect(local.checks.contains { $0.title == "Gatekeeper" && $0.status == "Noch nicht geprüft" })
        #expect(local.checks.contains { $0.title == "SIP" && $0.status == "Noch nicht geprüft" })

        let userAnswered = try #require(presentation.hygieneOverviewItems.first { $0.id == SecurityHygieneEvidenceKind.userAnswered.rawValue })
        #expect(userAnswered.title == "Fragt Sento dich")
        #expect(userAnswered.checks.contains { $0.title == "2FA für wichtige Konten" && $0.status == "Fragt dich noch" })
        #expect(userAnswered.checks.contains { $0.title == "Passwortmanager" && $0.status == "Fragt dich noch" })
        #expect(userAnswered.checks.contains { $0.title == "VPN-Sinnhaftigkeit" && $0.status == "Fragt dich noch" })

        let notVerifiable = try #require(presentation.hygieneOverviewItems.first { $0.id == SecurityHygieneEvidenceKind.notVerifiable.rawValue })
        #expect(notVerifiable.title == "Kann Sento noch nicht prüfen")
        #expect(notVerifiable.checks.contains { $0.title == "System Extensions" && $0.status == "Bleibt offen" })
    }

    @Test func dashboardPresentationDerivesLocalHygieneStateFromExistingFindings() throws {
        let presentation = DashboardPresentation(
            findings: [
                Self.updateAwarenessFinding(),
                Self.systemProfileFindingWithSIP(),
                Self.gatekeeperFinding(),
            ]
        )

        let local = try #require(presentation.hygieneOverviewItems.first { $0.id == SecurityHygieneEvidenceKind.observedLocally.rawValue })

        #expect(local.checks.contains { $0.title == "macOS-Updates" && $0.status == "Erkannt" })
        #expect(local.checks.contains { $0.title == "FileVault" && $0.status == "Erkannt" })
        #expect(local.checks.contains { $0.title == "Firewall" && $0.status == "Erkannt" })
        #expect(local.checks.contains { $0.title == "Gatekeeper" && $0.status == "Erkannt" })
        #expect(local.checks.contains { $0.title == "SIP" && $0.status == "Erkannt" })
    }

    @Test func dashboardPresentationNamesHygieneMissionAsEvidenceWork() {
        let presentation = DashboardPresentation(findings: [])
        let hygieneMission = presentation.missions.first { $0.id == "hygiene" }

        #expect(hygieneMission?.primaryActionTitle == "Noch begrenzt")
        #expect(hygieneMission?.status == "Erste Orientierung")
    }

    @Test func dashboardPresentationShowsSavedHygieneAnswersAsUserAnswers() throws {
        let presentation = DashboardPresentation(
            findings: [],
            hygieneAnswers: [
                SecurityHygieneAnswerRecord(
                    checkID: .passwordManager,
                    answer: .yes,
                    updatedAt: Date(timeIntervalSince1970: 100)
                ),
            ]
        )

        let userAnswered = try #require(presentation.hygieneOverviewItems.first { $0.id == SecurityHygieneEvidenceKind.userAnswered.rawValue })
        #expect(userAnswered.checks.contains { $0.title == "Passwortmanager" && $0.status == "Von dir bestätigt" })

        let question = try #require(presentation.guidedHygieneQuestions.first { $0.id == .passwordManager })
        #expect(question.answer == .yes)

        let vpnQuestion = try #require(presentation.guidedHygieneQuestions.first { $0.id == .vpnUsefulness })
        #expect(vpnQuestion.question.contains("konkreten VPN-Grund"))
        #expect(vpnQuestion.reason.contains("Kontextfrage"))
        #expect(vpnQuestion.boundary.contains("Rundumschutz"))
    }

    @Test func guidedHygieneQuestionsExplainWhySentoAsks() throws {
        let presentation = DashboardPresentation(findings: [])

        let passwordManager = try #require(presentation.guidedHygieneQuestions.first { $0.id == .passwordManager })
        #expect(passwordManager.reason.contains("bewusste Nutzerangabe"))
        #expect(passwordManager.boundary.contains("keine Passwortqualität"))
    }

    @Test func dashboardPresentationHighlightsUpdateAwarenessAfterRefresh() throws {
        let finding = Self.updateAwarenessFinding()

        let presentation = DashboardPresentation(findings: [finding])

        #expect(presentation.updateAwarenessFinding?.id == finding.id)
        #expect(presentation.buddyMessageText.contains("macOS-Update-Stand"))
        #expect(presentation.missions.first(where: { $0.id == "system" })?.status == "Update geprüft")
        #expect(presentation.missions.first(where: { $0.id == "system" })?.findingID == finding.id)
        #expect(presentation.activityItems.contains(where: { $0.id == "update-awareness" }))
    }

    private static func updateAwarenessFinding() -> Finding {
        Finding(
            id: "update-awareness::macos-15",
            title: "macOS wirkt nach Quellenstand aktuell",
            source: FindingSource(
                kind: .updateAwareness,
                title: "macOS-Update-Stand",
                detail: "Test"
            ),
            severity: .low,
            confidence: .supported,
            summary: "Die lokale Version 15.7.7 ist nach dem letzten SOFA-Stand nicht älter als 15.7.7.",
            userImpact: "Das ist ein Schutzsignal, aber kein Gesamturteil.",
            nextStep: "Behalte im Blick, von wann der Quellenstand ist.",
            evidence: [],
            recommendations: []
        )
    }

    private static func systemProfileFindingWithSIP() -> Finding {
        Finding(
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
            evidence: [
                FindingEvidence(
                    id: "sip-status",
                    title: "System Integrity Protection",
                    summary: "System Integrity Protection ist sichtbar aktiv.",
                    detail: "Rohmeldung: System Integrity Protection status: enabled."
                ),
                FindingEvidence(
                    id: "filevault-status",
                    title: "FileVault",
                    summary: "FileVault meldet: Laufwerksverschlüsselung aktiv.",
                    detail: "Rohmeldung: FileVault is On."
                ),
                FindingEvidence(
                    id: "firewall-status",
                    title: "Firewall",
                    summary: "Firewall meldet: eingehende Verbindungen werden gefiltert.",
                    detail: "Rohmeldung: Firewall is enabled. (State = 1)"
                ),
            ],
            recommendations: []
        )
    }

    private static func gatekeeperFinding() -> Finding {
        Finding(
            id: "system-profile::gatekeeper-enabled",
            title: "Mac-App-Prüfung ist aktiv",
            source: FindingSource(
                kind: .systemInventory,
                title: "Mac-Systemprofil",
                detail: "Test"
            ),
            severity: .low,
            confidence: .supported,
            summary: "macOS meldet, dass die App-Prüfung aktiv ist.",
            userImpact: "Test",
            nextStep: "Test",
            evidence: [
                FindingEvidence(
                    id: "gatekeeper-status",
                    title: "Gatekeeper-Status",
                    summary: "Gatekeeper meldet: App-Prüfung aktiv.",
                    detail: "Rohmeldung: assessments enabled"
                ),
            ],
            recommendations: []
        )
    }
}
