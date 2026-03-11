import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = .init()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView().infinityFrame()
            } else if viewModel.items.isEmpty {
                emptyState
            } else {
                itemsList
            }
        }
        .navigationTitle("PlanTasks")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.showAddItem) {
                    Image(systemName: "plus")
                }
            }
        }
        .showError(item: $viewModel.error)
        .showAlert(item: $viewModel.alert)
        .sheet(isPresented: $viewModel.isAddingItem) {
            Text("Add Task") // TODO: replace with real form
        }
        .task { await viewModel.loadItems() }
    }

    private var itemsList: some View {
        List {
            ForEach(viewModel.items) { item in
                HStack {
                    Button(action: { viewModel.toggleCompletion(item) }) {
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(item.isCompleted ? .green : .secondary)
                    }
                    .buttonStyle(.plain)
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .strikethrough(item.isCompleted)
                        if let desc = item.description {
                            Text(desc).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .onDelete(perform: viewModel.deleteItems)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No tasks yet").font(.title3)
            Text("Tap + to add your first task").font(.subheadline).foregroundStyle(.secondary)
        }
        .infinityFrame()
    }
}

#Preview {
    NavigationStack { HomeView() }
}
