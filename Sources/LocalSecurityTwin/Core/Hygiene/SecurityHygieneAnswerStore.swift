import Combine
import Foundation

@MainActor
final class SecurityHygieneAnswerStore: ObservableObject {
    @Published private(set) var answers: [SecurityHygieneAnswerRecord]
    @Published private(set) var localPersistenceNote: String?

    private let storageURL: URL
    private let fileManager: FileManager
    private let now: @Sendable () -> Date
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(
        storageURL: URL = SecurityHygieneAnswerStore.defaultStorageURL(),
        fileManager: FileManager = .default,
        now: @escaping @Sendable () -> Date = Date.init
    ) {
        self.storageURL = storageURL
        self.fileManager = fileManager
        self.now = now
        self.answers = []
        self.localPersistenceNote = nil
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder.dateDecodingStrategy = .iso8601
        loadAnswers()
    }

    func answer(for checkID: SecurityHygieneCheckID) -> SecurityHygieneAnswer? {
        answers.first { $0.checkID == checkID }?.answer
    }

    func record(answer: SecurityHygieneAnswer, for checkID: SecurityHygieneCheckID) throws {
        answers.removeAll { $0.checkID == checkID }
        answers.append(
            SecurityHygieneAnswerRecord(
                checkID: checkID,
                answer: answer,
                updatedAt: now()
            )
        )
        answers.sort { $0.updatedAt > $1.updatedAt }
        try persistAnswers()
    }

    private func loadAnswers() {
        guard fileManager.fileExists(atPath: storageURL.path) else {
            answers = []
            localPersistenceNote = nil
            return
        }

        do {
            let data = try Data(contentsOf: storageURL)
            answers = try decoder.decode([SecurityHygieneAnswerRecord].self, from: data)
                .sorted { $0.updatedAt > $1.updatedAt }
            localPersistenceNote = nil
        } catch {
            answers = []
            localPersistenceNote = "Gespeicherte Hygiene-Antworten konnten nicht gelesen werden. Sento fragt lieber erneut, statt alte Angaben still zu übernehmen."
        }
    }

    private func persistAnswers() throws {
        let directoryURL = storageURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        let data = try encoder.encode(answers)
        try data.write(to: storageURL, options: .atomic)
    }
}

extension SecurityHygieneAnswerStore {
    static func defaultStorageURL(fileManager: FileManager = .default) -> URL {
        let baseDirectory =
            fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fileManager.homeDirectoryForCurrentUser
                .appendingPathComponent("Library", isDirectory: true)
                .appendingPathComponent("Application Support", isDirectory: true)

        return baseDirectory
            .appendingPathComponent("LocalSecurityTwin", isDirectory: true)
            .appendingPathComponent("security-hygiene-answers.json", isDirectory: false)
    }
}
