import Foundation

@MainActor
final class LocalDataStore: DataStoreProtocol {
    private let key = "Home_storage"

    func getAll() async throws -> [Home] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? JSONDecoder().decode([Home].self, from: data) else {
            return []
        }
        return items
    }

    func add(_ item: Home) async throws {
        var items = try await getAll()
        items.append(item)
        try save(items)
    }

    func update(_ item: Home) async throws {
        var items = try await getAll()
        guard let index = items.firstIndex(where: { element in element.id == item.id }) else {
            throw AppError.notFound
        }
        items[index] = item
        try save(items)
    }

    func delete(_ item: Home) async throws {
        var items = try await getAll()
        items.removeAll(where: { element in element.id == item.id })
        try save(items)
    }

    private func save(_ items: [Home]) throws {
        guard let data = try? JSONEncoder().encode(items) else {
            throw AppError.saveFailed("Encoding failed")
        }
        UserDefaults.standard.set(data, forKey: key)
    }
}
