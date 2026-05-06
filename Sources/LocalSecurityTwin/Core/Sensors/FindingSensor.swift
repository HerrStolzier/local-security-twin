import Foundation

struct SensorDescriptor: Hashable, Codable, Sendable {
    let id: String
    let title: String
    let summary: String
}

struct SensorContext: Sendable {
    let homeDirectoryURL: URL
    let now: Date

    static func live(
        fileManager: FileManager = .default,
        now: Date = Date()
    ) -> SensorContext {
        SensorContext(
            homeDirectoryURL: fileManager.homeDirectoryForCurrentUser,
            now: now
        )
    }
}

struct SensorRun: Identifiable, Hashable, Sendable {
    let sensor: SensorDescriptor
    let findings: [Finding]
    let notes: [String]
    let completedAt: Date

    var id: String {
        sensor.id
    }
}

protocol FindingSensor {
    var descriptor: SensorDescriptor { get }
    func run(in context: SensorContext) -> SensorRun
}
