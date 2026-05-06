import Foundation

struct StartupItemRecord: Identifiable, Hashable, Codable, Sendable {
    let path: String
    let scope: StartupItemScope
    let details: StartupItemDetails?

    init(path: String, scope: StartupItemScope, details: StartupItemDetails? = nil) {
        self.path = StartupItemRecord.normalizedPath(path)
        self.scope = scope
        self.details = details
    }

    var id: String {
        "\(scope.rawValue)::\(path)"
    }

    var fileURL: URL {
        URL(fileURLWithPath: path)
    }

    var fileName: String {
        fileURL.lastPathComponent
    }

    private static func normalizedPath(_ path: String) -> String {
        URL(fileURLWithPath: path)
            .resolvingSymlinksInPath()
            .standardizedFileURL
            .path
    }
}

struct StartupItemDetails: Hashable, Codable, Sendable {
    let label: String?
    let program: String?
    let programArguments: [String]
    let runAtLoad: Bool?
    let keepAliveSummary: String?
}

enum StartupItemScope: String, Hashable, Codable, Sendable {
    case userAgent
    case sharedAgent
    case sharedDaemon
}

struct StartupItemBaselineSnapshot: Hashable, Codable, Sendable {
    let sensorID: String
    let capturedAt: Date
    let items: [StartupItemRecord]
}

enum StartupItemBaselineStatus: String, Hashable, Sendable {
    case createdInitialSnapshot
    case loadedExistingSnapshot
}

struct StartupItemBaselineState: Hashable, Sendable {
    let snapshot: StartupItemBaselineSnapshot
    let status: StartupItemBaselineStatus
}

enum StartupItemBaselineStoreError: Error, Equatable, LocalizedError {
    case sensorMismatch(expected: String, actual: String)

    var errorDescription: String? {
        switch self {
        case let .sensorMismatch(expected, actual):
            return "Stored baseline belongs to \(actual), but \(expected) was expected."
        }
    }
}

struct StartupItemBaselineStore {
    private let storageURL: URL
    private let fileManager: FileManager

    init(
        storageURL: URL = StartupItemBaselineStore.defaultStorageURL(),
        fileManager: FileManager = .default
    ) {
        self.storageURL = storageURL
        self.fileManager = fileManager
    }

    func load() throws -> StartupItemBaselineSnapshot? {
        guard fileManager.fileExists(atPath: storageURL.path) else {
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let data = try Data(contentsOf: storageURL)
        let snapshot = try decoder.decode(StartupItemBaselineSnapshot.self, from: data)
        return StartupItemBaselineSnapshot(
            sensorID: snapshot.sensorID,
            capturedAt: snapshot.capturedAt,
            items: normalized(snapshot.items)
        )
    }

    func load(expectedSensorID: String) throws -> StartupItemBaselineSnapshot? {
        guard let snapshot = try load() else {
            return nil
        }

        guard snapshot.sensorID == expectedSensorID else {
            throw StartupItemBaselineStoreError.sensorMismatch(
                expected: expectedSensorID,
                actual: snapshot.sensorID
            )
        }

        return snapshot
    }

    func initializeIfNeeded(
        sensorID: String,
        items: [StartupItemRecord],
        capturedAt: Date
    ) throws -> StartupItemBaselineState {
        if let snapshot = try load(expectedSensorID: sensorID) {
            return StartupItemBaselineState(
                snapshot: snapshot,
                status: .loadedExistingSnapshot
            )
        }

        let snapshot = StartupItemBaselineSnapshot(
            sensorID: sensorID,
            capturedAt: capturedAt,
            items: normalized(items)
        )
        try save(snapshot)

        return StartupItemBaselineState(
            snapshot: snapshot,
            status: .createdInitialSnapshot
        )
    }

    @discardableResult
    func refresh(
        sensorID: String,
        items: [StartupItemRecord],
        capturedAt: Date
    ) throws -> StartupItemBaselineSnapshot {
        if let snapshot = try load() {
            guard snapshot.sensorID == sensorID else {
                throw StartupItemBaselineStoreError.sensorMismatch(
                    expected: sensorID,
                    actual: snapshot.sensorID
                )
            }
        }

        let snapshot = StartupItemBaselineSnapshot(
            sensorID: sensorID,
            capturedAt: capturedAt,
            items: normalized(items)
        )
        try save(snapshot)
        return snapshot
    }

    func save(_ snapshot: StartupItemBaselineSnapshot) throws {
        let directoryURL = storageURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let normalizedSnapshot = StartupItemBaselineSnapshot(
            sensorID: snapshot.sensorID,
            capturedAt: snapshot.capturedAt,
            items: normalized(snapshot.items)
        )
        let data = try encoder.encode(normalizedSnapshot)
        try data.write(to: storageURL, options: .atomic)
    }

    private func normalized(_ items: [StartupItemRecord]) -> [StartupItemRecord] {
        items
            .map { StartupItemRecord(path: $0.path, scope: $0.scope, details: $0.details) }
            .sorted { lhs, rhs in
            lhs.id < rhs.id
        }
    }
}

extension StartupItemBaselineStore {
    static func defaultStorageURL(fileManager: FileManager = .default) -> URL {
        let baseDirectory =
            fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fileManager.homeDirectoryForCurrentUser
                .appendingPathComponent("Library", isDirectory: true)
                .appendingPathComponent("Application Support", isDirectory: true)

        return baseDirectory
            .appendingPathComponent("LocalSecurityTwin", isDirectory: true)
            .appendingPathComponent("startup-item-baseline.json", isDirectory: false)
    }
}
