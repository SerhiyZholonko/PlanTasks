import Foundation
import Combine
import Factory

@MainActor
final class HomeViewModel: ObservableObject, ErrorDisplayable, AlertDisplayable {

    @Published var items: [Home] = []
    @Published var isLoading: Bool = false
    @Published var isAddingItem: Bool = false
    @Published var error: Error?
    @Published var alert: AppAlert?

    @Injected(\.dataStore) private var store

    func loadItems() async {
        Task(handlingError: self) {
            self.isLoading = true
            defer { self.isLoading = false }
            self.items = try await self.store.getAll()
        }
    }

    func showAddItem() {
        isAddingItem = true
    }

    func toggleCompletion(_ item: Home) {
        var updated = item
        updated.isCompleted.toggle()
        Task(handlingError: self) {
            try await self.store.update(updated)
            self.items = try await self.store.getAll()
        }
    }

    func deleteItems(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { index in self.items[index] }
        Task(handlingError: self) {
            for item in itemsToDelete {
                try await self.store.delete(item)
            }
            self.items = try await self.store.getAll()
        }
    }
}
