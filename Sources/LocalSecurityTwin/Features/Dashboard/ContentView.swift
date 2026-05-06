import SwiftUI

struct ContentView: View {
    let findings: [Finding]
    @State private var selection: Finding.ID?

    var body: some View {
        NavigationSplitView {
            List(findings, selection: $selection) { finding in
                FindingRowView(finding: finding)
                    .tag(finding.id)
            }
            .navigationTitle("Findings")
        } detail: {
            if findings.isEmpty {
                ContentUnavailableView(
                    "No findings yet",
                    systemImage: "checkmark.shield",
                    description: Text("The first local sensor stays quiet unless it finds visible startup items. That means the app is not seeing anything worth surfacing right now.")
                )
            } else if let selectedFinding = findings.first(where: { $0.id == selection }) {
                FindingDetailView(finding: selectedFinding)
            } else {
                ContentUnavailableView(
                    "Select a finding",
                    systemImage: "shield",
                    description: Text("The future app will show live evidence, user guidance, and policy decisions here.")
                )
            }
        }
        .frame(minWidth: 1020, minHeight: 640)
        .onAppear {
            if selection == nil {
                selection = findings.first?.id
            }
        }
        .onChange(of: findings) { _, newFindings in
            if newFindings.contains(where: { $0.id == selection }) {
                return
            }

            selection = newFindings.first?.id
        }
    }
}
