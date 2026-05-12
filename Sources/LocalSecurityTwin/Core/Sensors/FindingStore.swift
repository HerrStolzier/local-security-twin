import Foundation

@MainActor
final class FindingStore: ObservableObject {
    @Published private(set) var findings: [Finding]
    @Published private(set) var sensorRuns: [SensorRun]
    @Published private(set) var lastRefreshAt: Date?
    @Published private(set) var lastBaselineRefreshError: String?

    private let pipeline: SensorPipeline
    private let contextProvider: () -> SensorContext
    private var hasLoaded = false

    init(
        pipeline: SensorPipeline = .live(),
        contextProvider: @escaping () -> SensorContext = { .live() }
    ) {
        self.pipeline = pipeline
        self.contextProvider = contextProvider
        self.findings = []
        self.sensorRuns = []
    }

    func refreshIfNeeded() async {
        guard !hasLoaded else {
            return
        }

        hasLoaded = true
        refresh()
    }

    func refresh() {
        let runs = pipeline.collect(in: contextProvider())
        sensorRuns = runs
        findings = runs
            .flatMap(\.findings)
            .sorted(by: FindingStore.sortFindings)
        lastRefreshAt = runs.map(\.completedAt).max()
    }

    func rememberCurrentStartupState() {
        do {
            try pipeline.refreshRememberedStartupState(in: contextProvider())
            lastBaselineRefreshError = nil
            refresh()
        } catch {
            lastBaselineRefreshError = error.localizedDescription
        }
    }

    private static func sortFindings(lhs: Finding, rhs: Finding) -> Bool {
        if lhs.severity != rhs.severity {
            return lhs.severity > rhs.severity
        }

        if lhs.confidence != rhs.confidence {
            return lhs.confidence.sortOrder > rhs.confidence.sortOrder
        }

        return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
    }
}

private extension FindingConfidence {
    var sortOrder: Int {
        switch self {
        case .tentative:
            return 0
        case .supported:
            return 1
        case .strong:
            return 2
        }
    }
}
