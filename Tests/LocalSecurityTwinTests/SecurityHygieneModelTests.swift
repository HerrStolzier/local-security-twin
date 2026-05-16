import Testing
@testable import LocalSecurityTwin

struct SecurityHygieneModelTests {
    @Test func initialCatalogSeparatesEvidenceKindsHonestly() {
        let catalog = SecurityHygieneCheck.initialCatalog

        #expect(catalog.contains { $0.id == .macOSUpdates && $0.evidenceKind == .observedLocally })
        #expect(catalog.contains { $0.id == .gatekeeper && $0.evidenceKind == .observedLocally })
        #expect(catalog.contains { $0.id == .twoFactorAuthentication && $0.evidenceKind == .userAnswered })
        #expect(catalog.contains { $0.id == .passwordManager && $0.evidenceKind == .userAnswered })
        #expect(catalog.contains { $0.id == .fileVault && $0.evidenceKind == .notVerifiable })
        #expect(catalog.contains { $0.id == .systemExtensions && $0.evidenceKind == .notVerifiable })
    }

    @Test func initialCatalogKeepsSafetyBoundariesVisible() throws {
        for check in SecurityHygieneCheck.initialCatalog {
            #expect(!check.title.isEmpty)
            #expect(!check.summary.isEmpty)
            #expect(!check.boundary.isEmpty)
        }

        let vpn = try #require(SecurityHygieneCheck.initialCatalog.first { $0.id == .vpnUsefulness })
        #expect(vpn.boundary.contains("Rundumschutz"))

        let passwordManager = try #require(SecurityHygieneCheck.initialCatalog.first { $0.id == .passwordManager })
        #expect(passwordManager.boundary.contains("keine Passwörter"))
    }

    @Test func userAnsweredEvidenceSpeaksDirectlyToTheUser() {
        #expect(SecurityHygieneEvidenceKind.userAnswered.explanation.contains("deiner bewussten Antwort"))
    }
}
