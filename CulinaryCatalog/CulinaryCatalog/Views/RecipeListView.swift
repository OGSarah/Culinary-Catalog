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
/// This view manages the display of recipes, including searching, loading, and refreshing capabilities.
struct RecipeListView: View {
    /// The view model responsible for managing the list of recipes and related operations.
    @StateObject private var viewModel: RecipeListViewModel
    /// The current search text used for filtering recipes.
    @State private var searchText = ""
    /// The list of recipes to display, which can be filtered based on the search text.
    @State private var recipes: [RecipeModel] = []
    /// Indicates if the view is currently loading data.
    @State private var isLoading = false
    /// Stores any error message to be shown to the user.
    @State private var errorMessage: String?

    /// Initializes the `RecipeListView` with a repository for accessing recipe data.
    ///
    /// - Parameter recipeRepository: The protocol-conforming object for fetching and managing recipe data.
    init(recipeRepository: RecipeDataRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: RecipeListViewModel(recipeRepository: recipeRepository))
    }

    // MARK: Main View
    var body: some View {
        List {
            ForEach(viewModel.recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))) {
                    RecipeRowView(recipe: recipe)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search")
        .onChange(of: searchText) { _, newValue in
            Task {
                await filterRecipes(searchText: newValue)
            }
        }
        .task {
            await loadInitialRecipes()
        }
        .refreshable {
            await refreshRecipes()
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    // MARK: - Private Functions
    /// Loads the initial set of recipes when the view appears.
    ///
    /// This method is called when the view first loads to populate the list with recipes.
    private func loadInitialRecipes() async {
        isLoading = true
        do {
            await viewModel.loadRecipes()
            recipes = try await viewModel.filteredRecipes(searchText: searchText)
            isLoading = false
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    /// Refreshes the recipe list, potentially fetching new or updated data.
    ///
    /// This method is invoked when the user performs a pull-to-refresh action.
    private func refreshRecipes() async {
        isLoading = true
        do {
            try await viewModel.refreshRecipes()
            recipes = try await viewModel.filteredRecipes(searchText: searchText)
            isLoading = false
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    /// Filters the list of recipes based on the current search text.
    ///
    /// - Parameter searchText: The text used to filter recipes by name or other attributes.
    private func filterRecipes(searchText: String) async {
        do {
            recipes = try await viewModel.filteredRecipes(searchText: searchText)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    RecipeListView(recipeRepository: MockRecipeRepository())
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    RecipeListView(recipeRepository: MockRecipeRepository())
        .preferredColorScheme(.dark)
}

// MARK: - Mock Repository for Previews
#if DEBUG
struct MockRecipeRepository: RecipeDataRepositoryProtocol {
    func fetchRecipes() async throws -> [RecipeModel] {
        return [
            RecipeModel(
                cuisineType: "British",
                recipeName: "Apple & Blackberry Crumble",
                photoLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                photoSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                sourceURL: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                id: UUID(),
                youTubeURL: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
            )
        ]
    }

    func refreshRecipes() async throws -> [RecipeModel] {
        return [
            RecipeModel(
                cuisineType: "British",
                recipeName: "Blackberry Fool",
                photoLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/large.jpg",
                photoSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/small.jpg",
                sourceURL: "https://www.bbc.co.uk/food/recipes/blackberry_fool_with_11859",
                id: UUID(),
                youTubeURL: "https://www.youtube.com/watch?v=kniRGjDLFrQ"
            )
        ]
    }
}
#endif
