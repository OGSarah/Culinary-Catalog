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

    private func loadInitialRecipes() async {
        isLoading = true
        do {
            await viewModel.loadRecipes()
            recipes = await viewModel.filteredRecipes(searchText: searchText)
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
            await viewModel.refreshRecipes()
            recipes = await viewModel.filteredRecipes(searchText: searchText)
            isLoading = false
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    private func filterRecipes(searchText: String) async {
        do {
            recipes = await viewModel.filteredRecipes(searchText: searchText)
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
        // Return sample recipes for preview
        return [
            RecipeModel(
                cuisineType: "Italian",
                recipeName: "Pasta Carbonara",
                photoLarge: "",
                photoSmall: "",
                sourceURL: "",
                id: UUID(),
                youTubeURL: ""
            )
        ]
    }

    func refreshRecipes() async throws -> [RecipeModel] {
        // Return sample recipes for refresh
        return [
            RecipeModel(
                cuisineType: "French",
                recipeName: "Coq au Vin",
                photoLarge: "",
                photoSmall: "",
                sourceURL: "",
                id: UUID(),
                youTubeURL: ""
            )
        ]
    }
}
#endif
