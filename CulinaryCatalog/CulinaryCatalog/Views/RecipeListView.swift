//
//  RecipeListView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData
import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel: RecipeListViewModel
    @State private var searchText = ""
    @State private var recipes: [RecipeModel] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    init(recipeRepository: RecipeDataRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: RecipeListViewModel(recipeRepository: recipeRepository))
    }

    // MARK: Main View
    var body: some View {
        List {
            ForEach(recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
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
