//
//  RecipeListViewModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData

@MainActor
final class RecipeListViewModel: RecipeListViewModelProtocol {
    /// The list of recipes to be displayed in the view
    @Published private(set) var recipes: [RecipeModel] = []

    /// Indicates whether a recipe refresh is currently in progress
    @Published private(set) var isRefreshing = false

    /// Stores any error messages that occur during recipe loading or refreshing
    @Published private(set) var errorMessage: String?

    /// The repository responsible for fetching and managing recipe data
    private let recipeRepository: RecipeRepositoryProtocol

    /// Initializes the view model with a recipe repository
    /// - Parameter recipeRepository: The repository for managing recipe data
    init(recipeRepository: RecipeRepositoryProtocol) {
        self.recipeRepository = recipeRepository
    }

    /// Loads recipes from the repository
    ///
    /// Attempts to fetch recipes and updates the view model's state accordingly.
    /// Clears any previous error messages on successful load.
    ///
    /// - Note: This method is safe to call multiple times
    func loadRecipes() async {
        do {
            // Attempt to fetch recipes from the repository
            recipes = try await recipeRepository.fetchRecipes()

            // Clear any previous error messages
            errorMessage = nil
        } catch {
            // Handle and store any errors that occur during fetching
            handleError(error)
        }
    }

    /// Refreshes the list of recipes
    ///
    /// Prevents multiple simultaneous refresh operations.
    /// Attempts to fetch and update recipes from the repository.
    ///
    /// - Note: Sets `isRefreshing` to manage UI state during refresh
    func refreshRecipes() async {
        // Prevent multiple simultaneous refresh attempts
        guard !isRefreshing else { return }

        // Indicate that a refresh is starting
        isRefreshing = true

        // Ensure isRefreshing is set to false when the method completes
        defer { isRefreshing = false }

        do {
            // Attempt to refresh recipes through the repository
            recipes = try await recipeRepository.refreshRecipes()

            // Clear any previous error messages
            errorMessage = nil
        } catch {
            // Handle and store any errors that occur during refresh
            handleError(error)
        }
    }

    /// Filters recipes based on a search text
    ///
    /// - Parameter searchText: The text to use for filtering recipes
    /// - Returns: A filtered list of recipes matching the search text
    func filteredRecipes(searchText: String) async -> [RecipeModel] {
        // Return all recipes if search text is empty
        guard !searchText.isEmpty else { return recipes }

        // Filter recipes based on recipe name or cuisine type
        return recipes.filter { recipe in
            recipe.recipeName.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisineType.localizedCaseInsensitiveContains(searchText)
        }
    }

    /// Handles errors that occur during recipe loading or refreshing
    ///
    /// - Parameter error: The error that occurred
    private func handleError(_ error: Error) {
        // Log the error for debugging purposes
        print("Recipe List Error: \(error.localizedDescription)")

        // Set the error message for user feedback
        errorMessage = error.localizedDescription
    }

}
