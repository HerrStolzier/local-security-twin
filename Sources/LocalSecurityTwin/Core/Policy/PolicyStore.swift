import Combine
import Foundation

@MainActor
final class PolicyStore: ObservableObject {
    @Published private(set) var rememberedPolicies: [PolicyRecord]

    private var sessionPolicies: [PolicyKey: PolicyRecord]
    private let storageURL: URL
    private let fileManager: FileManager
    private let now: @Sendable () -> Date
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(
        storageURL: URL = PolicyStore.defaultStorageURL(),
        fileManager: FileManager = .default,
        now: @escaping @Sendable () -> Date = Date.init
    ) {
        self.storageURL = storageURL
        self.fileManager = fileManager
        self.now = now
        self.rememberedPolicies = []
        self.sessionPolicies = [:]
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder.dateDecodingStrategy = .iso8601
        loadRememberedPolicies()
    }

    func resolution(for request: PolicyRequest) -> PolicyResolution {
        if let record = sessionPolicies[request.key] {
            return record.decision == .allow ? .allowed(.session) : .denied(.session)
        }

        if let record = rememberedPolicies.first(where: { $0.key == request.key }) {
            return record.decision == .allow ? .allowed(.remembered) : .denied(.remembered)
        }

        return .needsConsent(request.confirmationRequirement)
    }

    func record(
        decision: PolicyDecision,
        for request: PolicyRequest,
        scope: PolicyPersistenceScope,
        explicitConfirmation: Bool = false
    ) throws {
        if request.confirmationRequirement == .explicitApproval && !explicitConfirmation {
            throw PolicyStoreError.explicitConfirmationRequired(actionTitle: request.action.title)
        }

        let timestamp = now()
        let record = PolicyRecord(
            key: request.key,
            actionTitle: request.action.title,
            actionExplanation: request.action.explanation,
            subjectName: request.subject.displayName,
            decision: decision,
            scope: scope,
            risk: request.risk,
            reason: request.reason,
            evidenceSummary: request.evidenceSummary,
            createdAt: existingRecord(for: request.key, scope: scope)?.createdAt ?? timestamp,
            updatedAt: timestamp
        )

        switch scope {
        case .session:
            sessionPolicies[request.key] = record
        case .remembered:
            upsertRemembered(record)
            try persistRememberedPolicies()
        }
    }

    func resetRememberedPolicy(for key: PolicyKey) throws {
        rememberedPolicies.removeAll { $0.key == key }
        try persistRememberedPolicies()
    }

    func resetAllRememberedPolicies() throws {
        rememberedPolicies.removeAll()
        try persistRememberedPolicies()
    }

    func clearSessionPolicies() {
        sessionPolicies.removeAll()
    }

    private func existingRecord(for key: PolicyKey, scope: PolicyPersistenceScope) -> PolicyRecord? {
        switch scope {
        case .session:
            return sessionPolicies[key]
        case .remembered:
            return rememberedPolicies.first(where: { $0.key == key })
        }
    }

    private func upsertRemembered(_ record: PolicyRecord) {
        rememberedPolicies.removeAll { $0.key == record.key }
        rememberedPolicies.append(record)
        rememberedPolicies.sort { $0.updatedAt > $1.updatedAt }
    }

    private func loadRememberedPolicies() {
        guard fileManager.fileExists(atPath: storageURL.path) else {
            rememberedPolicies = []
            return
        }

        do {
            let data = try Data(contentsOf: storageURL)
            rememberedPolicies = try decoder.decode([PolicyRecord].self, from: data)
                .sorted { $0.updatedAt > $1.updatedAt }
        } catch {
            rememberedPolicies = []
        }
    }

    private func persistRememberedPolicies() throws {
        let directoryURL = storageURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        let data = try encoder.encode(rememberedPolicies)
        try data.write(to: storageURL, options: .atomic)
    }
}

extension PolicyStore {
    static func defaultStorageURL(fileManager: FileManager = .default) -> URL {
        let baseDirectory =
            fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fileManager.homeDirectoryForCurrentUser
                .appendingPathComponent("Library", isDirectory: true)
                .appendingPathComponent("Application Support", isDirectory: true)

        return baseDirectory
            .appendingPathComponent("LocalSecurityTwin", isDirectory: true)
            .appendingPathComponent("policies.json", isDirectory: false)
    }
}
