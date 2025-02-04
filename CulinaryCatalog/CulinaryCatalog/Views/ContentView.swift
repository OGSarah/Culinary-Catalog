//
//  ContentView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: RecipeListViewModel
    @State private var isRotating = false

    /// Initializes the view with a recipe repository
    /// - Parameter viewContext: The Core Data managed object context
    init(viewContext: NSManagedObjectContext) {
        let recipeRepository = RecipeDataRepository(
            networkManager: NetworkManager.shared,
            viewContext: viewContext
        )
        _viewModel = StateObject(wrappedValue: RecipeListViewModel(recipeRepository: recipeRepository, viewContext: viewContext, networkManager: NetworkManager.shared))
    }

    /// Background gradient for the view
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
                    RecipeListView(recipeRepository: viewModel.recipeRepository, viewContext: viewModel.viewContext)
                }
            }
            .navigationTitle("Recipes")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                refreshButton
            }
            .task {
                await viewModel.loadRecipes()
            }
        }
    }

    /// Refresh button with animated rotation
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

    /// Refreshes recipes with animated loading state
    ///
    /// - Note: Manages the rotation animation and calls the view model's refresh method
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
#Preview("Light Mode") {
    ContentView(viewContext: CoreDataController.preview.container.viewContext)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView(viewContext: CoreDataController.preview.container.viewContext)
        .preferredColorScheme(.dark)
}

#Preview("Empty Recipes - Light Mode") {
    let emptyContext = CoreDataController(inMemory: true).container.viewContext
    let emptyViewModel = RecipeListViewModel(
        recipeRepository: EmptyMockRecipeRepository(),
        viewContext: emptyContext,
        networkManager: MockNetworkManager()
    )

    return ContentView(viewContext: emptyContext)
        .environmentObject(emptyViewModel)
        .preferredColorScheme(.light)
}

#Preview("Empty Recipes - Dark Mode") {
    let emptyContext = CoreDataController(inMemory: true).container.viewContext
    let emptyViewModel = RecipeListViewModel(
        recipeRepository: EmptyMockRecipeRepository(),
        viewContext: emptyContext,
        networkManager: MockNetworkManager()
    )

    return ContentView(viewContext: emptyContext)
        .environmentObject(emptyViewModel)
        .preferredColorScheme(.dark)
}

// MARK: - Mock Repository for Empty Recipes
#if DEBUG
struct EmptyMockRecipeRepository: RecipeDataRepositoryProtocol {
    func fetchRecipes() async throws -> [RecipeModel] {
        return []
    }

    func refreshRecipes() async throws -> [RecipeModel] {
        return []
    }
}

struct MockNetworkManager: NetworkManagerProtocol {
    func fetchRecipesFromNetwork() async throws -> [RecipeModel] {
        return []
    }
}
#endif
