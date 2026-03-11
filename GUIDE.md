# PlanTasks — Developer Guide

## How to Add a New Screen

### 1. Create `Core/ScreenNameView.swift`

~~~swift
import SwiftUI

struct ScreenNameView: View {
    @StateObject var viewModel: ScreenNameViewModel = .init()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView().infinityFrame()
            } else {
                content
            }
        }
        .navigationTitle("Screen Title")
        .showError(item: $viewModel.error)
        .showAlert(item: $viewModel.alert)
        .task { await viewModel.onAppear() }
    }

    private var content: some View {
        Text("Content here")
    }
}

#Preview {
    NavigationStack { ScreenNameView() }
}
~~~

### 2. Create `Core/ScreenNameViewModel.swift`

~~~swift
import Foundation
import Combine
import Factory

@MainActor
final class ScreenNameViewModel: ObservableObject, ErrorDisplayable, AlertDisplayable {

    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var alert: AppAlert?

    @Injected(\.dataStore) private var store

    func onAppear() async {
        Task(handlingError: self) {
            self.isLoading = true
            defer { self.isLoading = false }
            // load data here
        }
    }
}
~~~

### 3. Navigate to the new screen

~~~swift
NavigationLink(destination: ScreenNameView()) {
    Text("Go to Screen")
}
~~~

---

## Colors — `Color.appTheme`

| Property                   | Usage                         |
|----------------------------|-------------------------------|
| `.appTheme.accent`         | Brand color, primary buttons  |
| `.appTheme.viewBackground` | Main screen background        |
| `.appTheme.cellBackground` | List rows, cards              |
| `.appTheme.text`           | Primary text                  |
| `.appTheme.secondaryText`  | Subtitles, captions           |
| `.appTheme.primaryAction`  | Action buttons (green)        |
| `.appTheme.destructive`    | Delete, danger actions        |
| `.appTheme.success`        | Success states                |
| `.appTheme.warning`        | Warning states                |
| `.appTheme.error`          | Error states                  |
| `.appTheme.divider`        | Separators                    |
| `.appTheme.inProgress`     | In-progress indicators        |

~~~swift
Text("Hello")
    .foregroundStyle(Color.appTheme.text)
    .background(Color.appTheme.viewBackground)

Button("Save") { }
    .tint(Color.appTheme.primaryAction)
~~~

---

## Error Handling — `Task(handlingError:)`

~~~swift
func loadData() {
    Task(handlingError: self) {
        self.isLoading = true
        defer { self.isLoading = false }
        self.items = try await store.getAll()
    }
}
~~~

---

## Confirmation Alerts — `AppAlert`

~~~swift
func confirmDelete(_ item: Home) {
    alert = AppAlert(
        title: "Delete task?",
        message: "This cannot be undone.",
        actionTitle: "Delete",
        action: {
            Task(handlingError: self) {
                try await self.store.delete(item)
                self.items = try await self.store.getAll()
            }
        }
    )
}
~~~

---

## View Helpers

~~~swift
.infinityFrame()                   // frame(maxWidth: .infinity, maxHeight: .infinity)
.infinityWidth()                   // frame(maxWidth: .infinity)
.isHidden(condition)               // conditionally hide a view
.loadingRedacted(when: isLoading)  // skeleton/placeholder loading effect
~~~
