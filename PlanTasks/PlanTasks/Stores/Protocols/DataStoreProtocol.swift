import Foundation

@MainActor
protocol DataStoreProtocol: AnyObject {
    func getAll() async throws -> [Home]
    func add(_ item: Home) async throws
    func update(_ item: Home) async throws
    func delete(_ item: Home) async throws
}
