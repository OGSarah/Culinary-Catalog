//
//  ContentView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData
import SwiftUI

/// The main view of the application displaying the list of recipes.
///
/// This view uses SwiftUI's declarative approach to define the UI, managing both the display of recipes and the interaction for refreshing them. It integrates with Core Data for local storage and uses a custom view model (`RecipeListViewModel`) for managing the list state.
struct ContentView: View {
    /// The environment's managed object context from Core Data.
    @Environment(\.managedObjectContext) private var viewContext

    /// The view model that handles the recipe list logic.
    @StateObject private var viewModel: RecipeListViewModel

    /// State for controlling the refresh button's animation.
    @State private var isRotating = false

    /// Initializes the view with a managed object context from Core Data.
    ///
    /// This initializer sets up the necessary dependencies for displaying and managing recipes:
    /// - A `RecipeDataRepository` for data operations.
    /// - A `RecipeListViewModel` for managing the UI state of the recipe list.
    ///
    /// - Parameter viewContext: The Core Data managed object context provided by the environment.
    init(viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: RecipeListViewModel(viewContext: viewContext, networkManager: NetworkManager.shared))
    }

    /// Defines the background gradient for the content view.
    ///
    /// This gradient creates a subtle visual effect, enhancing the aesthetic appeal of the recipe list.
    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .blue.opacity(0.6), location: 0),
            Gradient.Stop(color: .blue.opacity(0.3), location: 0.256),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: Main View
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.recipes.isEmpty {
                    ContentUnavailableView(
                        "No Recipes",
                        systemImage: "fork.knife",
                        description: Text("Try tapping on the Refresh button to reload recipes.")
                    )
                } else {
                    RecipeListView(viewContext: viewModel.viewContext)
                }
            }
            .navigationTitle("Recipes")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                refreshButton
            }
            .task {
                do {
                    try await viewModel.loadSortedRecipesFromCoreData()
                    if viewModel.recipes.isEmpty {
                        try await viewModel.getRecipesFromNetwork()
                    }
                } catch {
                    print("Error loading recipes: \(error.localizedDescription)")
                }
            }

        }
    }

    /// Defines the appearance and behavior of the refresh button in the toolbar.
    ///
    /// The button features an animated icon that rotates when refreshing, providing visual feedback to the user.
    private var refreshButton: some View {
        Image(systemName: "arrow.clockwise.circle")
            .foregroundStyle(
                isRotating ? .blue : .blue.opacity(0.5),
                isRotating ? .white : .gray
            )
            .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
            .shadow(color: isRotating ? .white : .clear, radius: isRotating ? 15 : 0)
            .scaleEffect(isRotating ? 1.3 : 1)
            .animation(.linear(duration: 1), value: isRotating)
            .onTapGesture {
                Task {
                    await self.refreshRecipes()
                }
            }
    }

    /// Handles the refresh operation for recipes, including managing the animation state.
    ///
    /// This method:
    /// - Starts the rotation animation for the refresh button.
    /// - Calls the view model to refresh the recipe list.
    /// - Ensures the animation completes at least one full rotation even if the refresh is quick.
    /// - Stops the animation when the refresh is complete or on error.
    private func refreshRecipes() async {
        // Start the rotation
        await MainActor.run {
            isRotating = true
        }

        do {
            try await viewModel.refreshRecipes()
        } catch {
            print("Refresh failed: \(error.localizedDescription)")
        }

        // Create a small delay to ensure the rotation completes at least one full turn
        try? await Task.sleep(for: .seconds(1))

        // Stop the rotation
        await MainActor.run {
            isRotating = false
        }
    }

}

// MARK: - Preview
/// Previews for different scenarios and UI modes.
///
/// These previews simulate various states of the `ContentView`:
/// - Light and dark mode for general functionality.
/// - Empty recipe states in both light and dark modes, using mock data to test the "No Recipes" UI.

#Preview("Light Mode") {
    ContentView(viewContext: CoreDataController.preview.persistentContainer.viewContext)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView(viewContext: CoreDataController.preview.persistentContainer.viewContext)
        .preferredColorScheme(.dark)
}

#Preview("Empty Recipes - Light Mode") {
    let emptyController = CoreDataController(.inMemory)
    let emptyViewModel = RecipeListViewModel(
        viewContext: emptyController.persistentContainer.viewContext,
        networkManager: MockNetworkManager()
    )

    return ContentView(viewContext: emptyController.persistentContainer.viewContext)
        .environmentObject(emptyViewModel)
        .preferredColorScheme(.light)
}

#Preview("Empty Recipes - Dark Mode") {
    let emptyController = CoreDataController(.inMemory)
    let emptyViewModel = RecipeListViewModel(
        viewContext: emptyController.persistentContainer.viewContext,
        networkManager: MockNetworkManager()
    )

    return ContentView(viewContext: emptyController.persistentContainer.viewContext)
        .environmentObject(emptyViewModel)
        .preferredColorScheme(.dark)
}

/// A mock implementation of `NetworkManagerProtocol` for testing network operations in debug mode.
struct MockNetworkManager: NetworkManagerProtocol {
    func fetchRecipesFromNetwork() async throws -> [RecipeModel] {
        return []
    }
}
