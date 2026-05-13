import SwiftUI

struct FindingRowView: View {
    let finding: Finding

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(finding.displayTitle)
                    .font(.headline)
                Spacer()
                Text(finding.displayImportance)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .foregroundStyle(finding.severity.textColor)
                    .background(finding.severity.badgeFill, in: Capsule())
                    .overlay(
                        Capsule()
                            .stroke(finding.severity.badgeStroke)
                    )
            }

            Text(finding.displaySubject)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)

            Text(finding.displaySummary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            Text(finding.displaySourceTitle)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 6)
    }
}

private extension FindingSeverity {
    var textColor: Color {
        switch self {
        case .low:
            return .secondary
        case .medium:
            return .primary
        case .high:
            return .primary
        }
    }

    var badgeFill: Color {
        switch self {
        case .low:
            return .secondary.opacity(0.08)
        case .medium:
            return .secondary.opacity(0.12)
        case .high:
            return .orange.opacity(0.14)
        }
    }

    var badgeStroke: Color {
        switch self {
        case .low:
            return .secondary.opacity(0.16)
        case .medium:
            return .secondary.opacity(0.2)
        case .high:
            return .orange.opacity(0.28)
        }
    }
}
