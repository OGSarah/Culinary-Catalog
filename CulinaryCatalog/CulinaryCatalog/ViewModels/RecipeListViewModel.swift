//
//  RecipeListViewModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData

/// Manages the view model logic for a list of recipes.
///
/// This class conforms to `RecipeListViewModelProtocol` and provides the implementation
/// for managing recipe data, including loading, refreshing, and filtering operations.
/// It ensures that all operations are performed on the main actor for SwiftUI compatibility.
@MainActor
final class RecipeListViewModel: RecipeListViewModelProtocol {
    /// The list of recipes to be displayed in the view.
    ///
    /// This property is automatically published for SwiftUI view updates.
    @Published private(set) var recipes: [RecipeModel] = []

    /// Indicates whether a recipe refresh operation is currently in progress.
    ///
    /// Used to manage UI states like showing loading indicators.
    @Published private(set) var isRefreshing = false

    /// Stores any error messages that occur during recipe loading or refreshing.
    ///
    /// This can be used to display user feedback or log errors.
    @Published private(set) var errorMessage: String?

    /// The repository responsible for fetching and managing recipe data.
    ///
    /// This abstraction allows for different data sources or mock data in testing scenarios.
    let recipeRepository: RecipeDataRepositoryProtocol

    /// The managed object context for Core Data operations.
    let viewContext: NSManagedObjectContext

    /// The network manager for fetching recipes from the network.
    private let networkManager: NetworkManagerProtocol

    /// Initializes the view model with necessary dependencies.
    ///
    /// - Parameters:
    ///   - recipeRepository: The repository for managing recipe data.
    ///   - viewContext: The Core Data managed object context.
    ///   - networkManager: The network manager for API calls.
    init(recipeRepository: RecipeDataRepositoryProtocol, viewContext: NSManagedObjectContext, networkManager: NetworkManagerProtocol) {
        self.recipeRepository = recipeRepository
        self.viewContext = viewContext
        self.networkManager = networkManager
    }

    /// Loads recipes from the repository into the view model.
    ///
    /// This method should be called to initially populate or update the list of recipes.
    /// It clears any existing error messages upon successful loading.
    ///
    /// - Note: Safe to call multiple times, will overwrite the current list of recipes.
    func loadRecipes() async {
        do {
            // Fetch recipes from the repository
            recipes = try await recipeRepository.fetchRecipes()

            // Clear any previous error messages on success
            errorMessage = nil
        } catch {
            // Handle errors by storing them for UI feedback
            handleError(error)
        }
    }

    /// Refreshes the list of recipes, potentially fetching new or updated data.
    ///
    /// Ensures only one refresh operation happens at a time to avoid multiple simultaneous requests.
    /// Updates the `isRefreshing` state for UI feedback during the operation.
    ///
    /// - Throws: An error if the refresh operation fails.
    func refreshRecipes() async throws {
        // Avoid multiple simultaneous refresh attempts
        guard !isRefreshing else { return }

        isRefreshing = true
        defer { isRefreshing = false }

        do {
            // Refresh recipes from the repository
            recipes = try await recipeRepository.refreshRecipes()

            // Clear any existing error messages
            errorMessage = nil
        } catch {
            // Handle errors that occur during refresh
            handleError(error)
            throw error // Re-throw for error propagation if needed
        }
    }

    /// Filters recipes based on a search text.
    ///
    /// - Parameter searchText: The text to use for filtering recipes by name or cuisine type.
    /// - Returns: A new array of `RecipeModel` objects that match the search criteria.
    /// - Throws: An error if the filtering process encounters an issue (unlikely in this simple implementation).
    func filteredRecipes(searchText: String) async throws -> [RecipeModel] {
        // If the search text is empty, return all recipes
        guard !searchText.isEmpty else { return recipes }

        // Filter recipes case-insensitively on name and cuisine type
        return recipes.filter { recipe in
            recipe.recipeName.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisineType.localizedCaseInsensitiveContains(searchText)
        }
    }

    /// Handles errors by logging and updating the error message state.
    ///
    /// - Parameter error: The error to be handled and potentially displayed to the user.
    private func handleError(_ error: Error) {
        // Log the error for debugging
        print("Recipe List Error: \(error.localizedDescription)")

        // Update the error message for user feedback
        errorMessage = error.localizedDescription
    }

}
