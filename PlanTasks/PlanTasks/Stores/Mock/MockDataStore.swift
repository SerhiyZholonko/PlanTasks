import Foundation

@MainActor
final class MockDataStore: DataStoreProtocol {
    var mockItems: [Home] = Home.mocks

    func getAll() async throws -> [Home] { mockItems }
    func add(_ item: Home) async throws { mockItems.append(item) }
    func update(_ item: Home) async throws {
        if let i = mockItems.firstIndex(where: { element in element.id == item.id }) {
            mockItems[i] = item
        }
    }
    func delete(_ item: Home) async throws {
        mockItems.removeAll(where: { element in element.id == item.id })
    }
}
