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

            Text("\(findings.count) lokale Hinweise geladen")
                .foregroundStyle(.secondary)

            Divider()

            Text("Grundhaltung")
                .font(.subheadline)
                .fontWeight(.semibold)
            Text("Erst pruefen und erklaeren. Keine stillen Systemaenderungen.")
                .foregroundStyle(.secondary)

            Divider()

            Text("\(rememberedPolicyCount) gemerkte Entscheidungen")
                .font(.subheadline)
            Text("Erlaubte und abgelehnte Schritte bleiben lokal nachvollziehbar.")
                .foregroundStyle(.secondary)

            Divider()

            Text("\(sensorCount) lokale Sensoren verbunden")
                .font(.subheadline)
            Text(lastRefreshText)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(width: 300)
    }

    private var lastRefreshText: String {
        guard let lastRefreshAt else {
            return "Noch kein lokaler Sensorlauf abgeschlossen."
        }

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return "Letzter Lauf \(formatter.localizedString(for: lastRefreshAt, relativeTo: Date()))."
    }
}
