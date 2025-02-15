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
@MainActor
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
    /// - Throws: An error if there's an issue with fetching data from Core Data, such as database corruption or access issues.
    func loadSortedRecipesFromCoreData() async throws {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            let entities = try viewContext.fetch(fetchRequest)
            self.recipes = entities.compactMap { RecipeModel(entity: $0) }
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

    /// Synchronizes local data with the latest from the server.
    ///
    /// This method ensures that the local database reflects the most current state from the server by:
    /// 1. Deleting all existing recipes from Core Data to start fresh.
    /// 2. Fetching the latest recipes from the network.
    /// 3. Saving these new recipes into Core Data.
    ///
    /// - Returns: An array of `RecipeModel` objects representing the newly fetched and stored recipes, useful for immediate UI updates or confirmation of the refresh operation.
    /// - Throws: An error if:
    ///   - Network fetching fails due to connectivity issues, server errors, or data decoding problems.
    ///   - There's a problem clearing or saving to Core Data, such as permission issues, storage errors, or if the context save fails.
    func refreshRecipes() async throws -> [RecipeModel] {
        let newRecipes = try await networkManager.fetchRecipesFromNetwork()

        try await viewContext.perform {
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            let objects = try self.viewContext.fetch(fetchRequest)
            for object in objects {
                self.viewContext.delete(object)
            }

            // Create and save new recipes
            for recipeModel in newRecipes {
                let newRecipe = Recipe(context: self.viewContext)
                newRecipe.id = recipeModel.id
                newRecipe.recipeName = recipeModel.recipeName
                newRecipe.cuisineType = recipeModel.cuisineType
                newRecipe.photoSmall = recipeModel.photoSmall
                newRecipe.photoLarge = recipeModel.photoLarge
                newRecipe.sourceURL = recipeModel.sourceURL
                newRecipe.youTubeURL = recipeModel.youTubeURL
            }
            try self.viewContext.save()
        }
        return newRecipes
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
