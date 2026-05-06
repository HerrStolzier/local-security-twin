import Foundation

extension Finding {
    static let samples: [Finding] = [
        Finding(
            id: "startup-behavior-detected",
            title: "New startup behavior detected",
            source: FindingSource(
                kind: .baselineDiff,
                title: "Baseline Diff",
                detail: "Compared the latest login-item snapshot with the last trusted baseline."
            ),
            severity: .medium,
            confidence: .supported,
            summary: "A new item appears to run automatically when the Mac starts.",
            userImpact: "Startup behavior matters because software that launches on its own can stay active quietly and keep seeing the system long after you forget about it.",
            nextStep: "Check whether you installed this item intentionally. If yes, you can trust it. If not, investigate first before letting it keep launching.",
            evidence: [
                FindingEvidence(
                    id: "startup-added-item",
                    title: "New login item",
                    summary: "A launch item called HelperAgent was not present in the previous baseline.",
                    detail: "The current snapshot lists HelperAgent in the startup set, while the last trusted snapshot did not."
                ),
                FindingEvidence(
                    id: "startup-first-seen",
                    title: "First seen recently",
                    summary: "The item first appeared after the last baseline refresh.",
                    detail: "The app would later use timestamps and install traces to show when the item first became visible."
                ),
            ],
            recommendations: [
                FindingRecommendation(
                    id: "trust-startup-item",
                    title: "Mark this startup behavior as expected",
                    explanation: "Use this if you recognize the item and want future views to stay calmer about it.",
                    action: .trustItem
                ),
                FindingRecommendation(
                    id: "validate-startup-item",
                    title: "Run a safe validation later",
                    explanation: "Use a tightly bounded validation step before making a stronger claim about whether this startup behavior is suspicious.",
                    action: .runSafeValidation
                ),
            ]
        ),
        Finding(
            id: "sensitive-permission-spread",
            title: "Sensitive permission spread",
            source: FindingSource(
                kind: .privacyPermissions,
                title: "Privacy Permissions",
                detail: "Reviewed the set of apps with access to a sensitive privacy area."
            ),
            severity: .high,
            confidence: .strong,
            summary: "An app currently has access to a sensitive permission area that deserves review.",
            userImpact: "Sensitive permissions can expose screen content, microphone input, or wider control over the machine. Even a real app may no longer need that level of access.",
            nextStep: "Open the relevant settings area, confirm whether the app still needs the permission, and remove access if the reason no longer makes sense.",
            evidence: [
                FindingEvidence(
                    id: "permission-grant",
                    title: "Sensitive access is active",
                    summary: "A granted permission was found in a high-impact privacy category.",
                    detail: "The future sensor would name the exact permission area and the app that currently holds it."
                ),
                FindingEvidence(
                    id: "permission-review-gap",
                    title: "Review gap",
                    summary: "There is no recent trust decision attached to this permission in the local model yet.",
                    detail: "That means the app should ask instead of assuming the permission is still expected."
                ),
            ],
            recommendations: [
                FindingRecommendation(
                    id: "open-permission-settings",
                    title: "Open the settings area for review",
                    explanation: "Take the user directly to the relevant settings page so they can confirm or revoke access with context.",
                    action: .openSensitiveSettings
                ),
                FindingRecommendation(
                    id: "trust-permission-state",
                    title: "Mark the current state as expected",
                    explanation: "Use this if the app and permission still make sense and should not keep surfacing as a surprise.",
                    action: .trustItem
                ),
            ]
        ),
    ]
}
