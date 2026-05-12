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
                    .background(finding.severity.color.opacity(0.16), in: Capsule())
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
    var color: Color {
        switch self {
        case .low:
            return .blue
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}
