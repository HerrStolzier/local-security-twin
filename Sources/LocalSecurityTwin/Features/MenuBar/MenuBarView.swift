import SwiftUI

struct MenuBarView: View {
    let findings: [Finding]
    let rememberedPolicyCount: Int
    let sensorCount: Int
    let lastRefreshAt: Date?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Local Security Twin")
                .font(.headline)

            Text("\(findings.count) sample findings loaded")
                .foregroundStyle(.secondary)

            Divider()

            Text("Default posture")
                .font(.subheadline)
                .fontWeight(.semibold)
            Text("Inspect, explain, and recommend. No silent changes.")
                .foregroundStyle(.secondary)

            Divider()

            Text("\(rememberedPolicyCount) remembered policy decisions")
                .font(.subheadline)
            Text("Trusted and denied actions stay visible so the user can review them later.")
                .foregroundStyle(.secondary)

            Divider()

            Text("\(sensorCount) local sensor(s) connected")
                .font(.subheadline)
            Text(lastRefreshText)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(width: 300)
    }

    private var lastRefreshText: String {
        guard let lastRefreshAt else {
            return "No local sensor refresh has finished yet."
        }

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return "Last refresh \(formatter.localizedString(for: lastRefreshAt, relativeTo: Date()))."
    }
}
