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
    /// Indicates if the view is currently loading data.
    @State private var isLoading = false
    /// Stores any error message to be shown to the user.
    @State private var errorMessage: String?

    /// Initializes the `RecipeListView` with a repository and view context for accessing recipe data.
    ///
    /// - Parameters:
    ///   - recipeRepository: The protocol-conforming object for fetching and managing recipe data.
    ///   - viewContext: The Core Data managed object context for local data operations.
    init(recipeRepository: RecipeDataRepositoryProtocol, viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: RecipeListViewModel(recipeRepository: recipeRepository, viewContext: viewContext, networkManager: NetworkManager.shared))
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
                do {
                    try await viewModel.filteredRecipes(searchText: newValue)
            } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }
        .task {
            await viewModel.loadRecipes()
        }
        .refreshable {
            do {
                try await viewModel.refreshRecipes()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
        .overlay {
            if viewModel.isRefreshing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
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
#Preview("Light Mode") {
    let inMemoryContainer = CoreDataController(inMemory: true).container
    let mockRepository = MockRecipeRepository()
    return RecipeListView(recipeRepository: mockRepository, viewContext: inMemoryContainer.viewContext)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let inMemoryContainer = CoreDataController(inMemory: true).container
    let mockRepository = MockRecipeRepository()
    return RecipeListView(recipeRepository: mockRepository, viewContext: inMemoryContainer.viewContext)
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
