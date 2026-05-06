import Testing
@testable import LocalSecurityTwin

@Test func sampleFindingsExist() async throws {
    #expect(!Finding.samples.isEmpty)
}
