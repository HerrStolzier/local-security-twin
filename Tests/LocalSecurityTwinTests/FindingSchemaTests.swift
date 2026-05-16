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
        #expect(finding.startupKeepAliveText == "Soll im Hintergrund verfuegbar bleiben")
        #expect(finding.startupFilePath == "/Library/LaunchDaemons/com.example.agent.plist")
    }

    @Test func dashboardPresentationExplainsNextStepForStartupChanges() throws {
        let finding = Finding(
            id: "baseline-diff::added::sharedDaemon::/Library/LaunchDaemons/com.example.agent.plist",
            title: "Systemweit Autostart-Hinweis ist seit dem gemerkten Zustand neu",
            source: FindingSource(
                kind: .baselineDiff,
                title: "Autostart-Aenderung seit gemerktem Zustand",
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

        #expect(presentation.headlineText.contains("Autostart-Aenderung"))
        #expect(presentation.statusTitle == "Bitte kurz pruefen")
        #expect(presentation.buddyMessageText.contains("Veraenderung im Autostart"))
        #expect(presentation.primaryActionTitle == "Neue Aenderung ansehen")
        #expect(presentation.nextStepText.contains("Pruefe zuerst"))
        #expect(presentation.visibilityText.contains("kein Beweis"))
        #expect(presentation.showsRememberCurrentStartupStateAction)
        #expect(presentation.guardianTone == "Aufmerksam")
        #expect(presentation.missions.first?.title == "Autostart einordnen")
        #expect(presentation.missions.first?.findingID == finding.id)
        #expect(presentation.activityItems.first?.title.contains("neue Autostart-Aenderung") == true)
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
            summary: "com.example.one.plist liegt an einem Ort, den macOS fuer automatischen Hintergrundstart nutzen kann.",
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
            summary: "com.example.two.plist liegt an einem Ort, den macOS fuer automatischen Hintergrundstart nutzen kann.",
            userImpact: "Test",
            nextStep: "Test",
            evidence: [],
            recommendations: []
        )

        let presentation = DashboardPresentation(findings: [first, second])

        #expect(presentation.statusTitle == "Zur Beobachtung")
        #expect(presentation.primaryActionTitle == "Hinweise ansehen")
        #expect(presentation.buddyMessageText.contains("bekannte Autostart-Hinweise"))
        #expect(presentation.knownStartupSummaryText == "2 bekannte Autostart-Hinweise zusammengefasst. Oeffne die Einzelhinweise nur, wenn du eine bestimmte App genauer ansehen willst.")
        #expect(presentation.guardianTone == "Beobachtet")
        #expect(presentation.missions.first?.title == "Autostart verstehen")
        #expect(presentation.missions.first?.findingID == first.id)
        #expect(presentation.missions.map(\.title).contains("Digitaler Fussabdruck"))
        #expect(presentation.missions.map(\.title).contains("App-Risiken pruefen"))
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
}
