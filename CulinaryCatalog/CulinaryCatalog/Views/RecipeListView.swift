//
//  RecipeListView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData
import SwiftUI

/// A view that displays a list of recipes with search functionality.
///
/// This view uses SwiftUI's `List` to show recipes, supports searching, refreshing, and error handling. It interacts with a `RecipeListViewModel` to manage the data and state of the recipe list.
struct RecipeListView: View {
    /// Holds the current search text for filtering recipes.
    @State private var searchText = ""

    /// The view model managing the list of recipes, including loading and refreshing operations.
    ///
    /// Owned by the parent (`ContentView`) and passed in so the entire screen graph shares a single
    /// view model. This avoids a race on fresh install where a second, separate view model would
    /// read from Core Data before the initial network fetch had finished persisting.
    let viewModel: RecipeListViewModel

    /// Indicates whether the list is currently loading more recipes.
    @State private var isLoading = false

    /// Stores any error messages that should be displayed to the user.
    @State private var errorMessage: String?

    var body: some View {
        List {
            ForEach(viewModel.filteredRecipes(searchText: searchText)) { recipe in
                NavigationLink(destination: RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))) {
                    RecipeRowView(recipe: recipe)
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.RecipeList.row(for: recipe.recipeName))
            }
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.RecipeList.list)
        /// Adds search functionality to the list, allowing users to filter recipes.
        .searchable(text: $searchText, prompt: "Search")
        /// Reacts to changes in the search text, updating the list accordingly.
        .onChange(of: searchText) { _, newValue in
            Task {
                do {
                    if newValue.isEmpty {
                        try await viewModel.loadSortedRecipesFromCoreData()
                    } else {
                        viewModel.recipes = viewModel.filteredRecipes(searchText: newValue)
                    }
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }
        /// Implements pull-to-refresh functionality to update the recipe list.
        .refreshable {
            do {
                _ = try await viewModel.refreshRecipes()
                // If there's a search text, re-filter after refresh
                if !searchText.isEmpty {
                    viewModel.recipes = viewModel.filteredRecipes(searchText: searchText)
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
        /// Shows a loading indicator overlay when refreshing recipes.
        .overlay {
            if viewModel.isRefreshing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .accessibilityIdentifier(AccessibilityIdentifiers.RecipeList.loadingOverlay)
                    .accessibilityLabel("Loading recipes")
            }
        }
        /// Displays an alert with any error messages encountered during operations.
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "")
        }
    }
}

// MARK: - Previews
/// Provides preview configurations for `RecipeListView` in different UI appearances.
///
/// These previews use mock data to simulate the view's appearance without needing a real backend or database.
#Preview("Light Mode") {
    let inMemoryController = CoreDataController(.inMemory)
    let viewModel = RecipeListViewModel(
        viewContext: inMemoryController.persistentContainer.viewContext,
        networkManager: NetworkManager.shared
    )
    return RecipeListView(viewModel: viewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let inMemoryController = CoreDataController(.inMemory)
    let viewModel = RecipeListViewModel(
        viewContext: inMemoryController.persistentContainer.viewContext,
        networkManager: NetworkManager.shared
    )
    return RecipeListView(viewModel: viewModel)
        .preferredColorScheme(.dark)
}

// MARK: - Mock Repository for Previews
#if DEBUG
struct MockRecipeRepository {
    /// Returns a predefined list of recipes for testing or preview purposes.
    func fetchRecipes() async throws -> [RecipeModel] {
        return [
            RecipeModel(
                cuisineType: "British",
                recipeName: "Apple & Blackberry Crumble",
                photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                recipeImageSmall: Data(),
                recipeImageLarge: Data(),
                sourceURL: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                id: UUID(),
                youTubeURL: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
            )
        ]
    }

    /// Simulates refreshing the recipes by returning a different predefined list for testing or preview.
    func refreshRecipes() async throws -> [RecipeModel] {
        return [
            RecipeModel(
                cuisineType: "British",
                recipeName: "Blackberry Fool",
                photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/large.jpg",
                photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/small.jpg",
                recipeImageSmall: Data(),
                recipeImageLarge: Data(),
                sourceURL: "https://www.bbc.co.uk/food/recipes/blackberry_fool_with_11859",
                id: UUID(),
                youTubeURL: "https://www.youtube.com/watch?v=kniRGjDLFrQ"
            )
        ]
    }
}
#endif
