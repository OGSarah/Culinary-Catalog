//
//  RecipeListViewModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData

/// Manages the view model logic for a list of recipes.
///
/// This class implements `RecipeListViewModelProtocol`, providing functionality for:
/// - Loading recipes from a local data source.
/// - Refreshing recipes from a network source.
/// - Filtering recipes based on user input.
/// It ensures thread-safe updates by running operations on the `MainActor`, which is crucial for SwiftUI updates.
///
/// - Note: All operations that update UI state are performed on the main thread to ensure SwiftUI can react to state changes immediately.
final class RecipeListViewModel: RecipeListViewModelProtocol {
    /// The list of recipes to be displayed in the view.
    ///
    /// This property is automatically published, triggering UI updates whenever its value changes.
    @Published var recipes: [RecipeModel] = []

    /// Indicates whether a recipe refresh operation is currently in progress.
    ///
    /// This state is used to show loading indicators or manage UI behavior during asynchronous operations.
    @Published private(set) var isRefreshing = false

    /// Stores any error messages that occur during recipe operations.
    ///
    /// This property can be used to display error messages in the UI or for internal error tracking.
    @Published private(set) var errorMessage: String?

    /// The managed object context for Core Data operations.
    ///
    /// Essential for performing local data store operations, like fetching or saving recipes.
    let viewContext: NSManagedObjectContext

    /// The network manager for fetching recipes from the network.
    ///
    /// Manages network requests, allowing for dependency injection or testing with mock network responses.
    private let networkManager: NetworkManagerProtocol

    /// Initializes the view model with necessary dependencies.
    ///
    /// - Parameters:
    ///   - recipeRepository: The repository for managing recipe data.
    ///   - viewContext: The Core Data managed object context for local storage operations.
    ///   - networkManager: The network manager for handling API calls to fetch or update data.
    init(viewContext: NSManagedObjectContext, networkManager: NetworkManagerProtocol) {
        self.viewContext = viewContext
        self.networkManager = networkManager
    }

    /// Retrieves all recipes currently stored in Core Data.
    ///
    /// This method queries the local database for all `Recipe` entities, transforms them into `RecipeModel` objects, and sorts them alphabetically by name for presentation or further processing.
    ///
    /// - Returns: An array of `RecipeModel` objects representing all recipes in local storage, sorted alphabetically by recipe name.
    /// - Throws: An error if there's an issue with fetching data from Core Data, such as database corruption or access issues.
    func loadSortedRecipesFromCoreData() async throws -> [RecipeModel] {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            let entities = try viewContext.fetch(fetchRequest)
            return entities.compactMap { RecipeModel(entity: $0) }
                .sorted { $0.recipeName.localizedCaseInsensitiveCompare($1.recipeName) == .orderedAscending }
        } catch {
            throw error
        }
    }

    func getRecipesFromNetwork() async throws {
        do {
            let fetchedRecipes = try await networkManager.fetchRecipesFromNetwork()
            await MainActor.run {
                self.recipes = fetchedRecipes
                self.errorMessage = nil
            }
        } catch {
            await handleError(error)
        }
    }

    /// Refreshes the list of recipes, potentially fetching new or updated data from the network.
    ///
    /// This operation ensures that only one refresh is active at a time, managing the `isRefreshing` state for UI feedback. It fetches from the network and updates local storage.
    ///
    /// - Note: Throws an error if the refresh operation fails, allowing for error handling in calling contexts.
    func refreshRecipes() async throws {
        // Avoid multiple simultaneous refresh attempts
        guard !isRefreshing else { return }

        await MainActor.run {
            self.isRefreshing = true
        }

        defer {
            Task { @MainActor in
                self.isRefreshing = false
            }
        }

        do {
            // Refresh recipes from the repository
            let refreshedRecipes = try await recipeRepository.refreshRecipes()
            await MainActor.run {
                self.recipes = refreshedRecipes
                self.errorMessage = nil
            }
        } catch {
            // Handle errors that occur during refresh
            await handleError(error)
            throw error // Re-throw for error propagation if needed
        }
    }

    /// Filters recipes based on a search text.
    ///
    /// This method performs a case-insensitive search on both the recipe name and cuisine type.
    ///
    /// - Parameter searchText: The text to filter recipes by.
    /// - Returns: An array of `RecipeModel` objects matching the search criteria.
    /// - Note: Returns all recipes if the search text is empty.
    func filteredRecipes(searchText: String) -> [RecipeModel] {
        guard !searchText.isEmpty else { return recipes }

        return recipes.filter { recipe in
            recipe.recipeName.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisineType.localizedCaseInsensitiveContains(searchText)
        }
    }

    /// Handles errors by logging and updating the error message state for UI feedback.
    ///
    /// - Parameter error: The error to be handled, which will be displayed to the user and logged for debugging.
    private func handleError(_ error: Error) async {
        // Log the error for debugging
        print("Recipe List Error: \(error.localizedDescription)")

        await MainActor.run {
            // Update the error message for user feedback
            self.errorMessage = error.localizedDescription
        }
    }

}
