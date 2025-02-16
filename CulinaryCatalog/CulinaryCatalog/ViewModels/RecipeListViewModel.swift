//
//  RecipeListViewModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData
import Combine

/// Manages the view model logic for a list of recipes.
///
/// This class implements `RecipeListViewModelProtocol`, providing functionality for:
/// - Loading recipes from a local data source.
/// - Refreshing recipes from a network source.
/// - Filtering recipes based on user input.
/// - Downloading and caching images from URLs to Core Data.
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

    /// A set of cancellables for managing Combine subscriptions.
    ///
    /// This set is used to store and manage any Combine publishers used within the view model.
    private var cancellables = Set<AnyCancellable>()

    /// Initializes the view model with necessary dependencies.
    ///
    /// - Parameters:
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
            print("Failed to return recipes: \(error.localizedDescription)")
        }
    }

    /// Fetches recipes from the network and updates the local data store.
    ///
    /// This method fetches recipes from the network, updates the local Core Data store, and then updates the UI with the new data.
    ///
    /// - Throws: An error if there's an issue with fetching data from the network or updating Core Data.
    func getRecipesFromNetwork() async throws {
        do {
            let fetchedRecipes = try await networkManager.fetchRecipesFromNetwork()
            await MainActor.run {
                self.recipes = fetchedRecipes
                self.errorMessage = nil
            }

            try await saveRecipesToCoreData(fetchedRecipes)
            await downloadAndCacheImages(for: fetchedRecipes)
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
    /// 4. Downloading and caching images for the new recipes.
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
                newRecipe.photoURLSmall = recipeModel.photoURLSmall
                newRecipe.photoURLLarge = recipeModel.photoURLLarge
                newRecipe.sourceURL = recipeModel.sourceURL
                newRecipe.youTubeURL = recipeModel.youTubeURL
            }
            try self.viewContext.save()
        }

        await MainActor.run {
            self.recipes = newRecipes
            self.errorMessage = nil
        }

        await downloadAndCacheImages(for: newRecipes)

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

    /// Saves the given recipes to Core Data.
    ///
    /// This method saves the provided recipes to the local Core Data store.
    ///
    /// - Parameter recipes: The array of `RecipeModel` objects to be saved.
    /// - Throws: An error if there's an issue with saving data to Core Data.
    private func saveRecipesToCoreData(_ recipes: [RecipeModel]) async throws {
        try await viewContext.perform {
            for recipeModel in recipes {
                let newRecipe = Recipe(context: self.viewContext)
                newRecipe.id = recipeModel.id
                newRecipe.recipeName = recipeModel.recipeName
                newRecipe.cuisineType = recipeModel.cuisineType
                newRecipe.photoURLSmall = recipeModel.photoURLSmall
                newRecipe.photoURLLarge = recipeModel.photoURLLarge
                newRecipe.recipeImageSmall = recipeModel.recipeImageSmall
                newRecipe.recipeImageLarge = recipeModel.recipeImageLarge
                newRecipe.sourceURL = recipeModel.sourceURL
                newRecipe.youTubeURL = recipeModel.youTubeURL
            }
            try self.viewContext.save()
        }
    }

    /// Downloads and caches images for the given recipes.
    ///
    /// This method downloads the small and large photo URLs for each recipe and saves them to Core Data.
    ///
    /// - Parameter recipes: The array of `RecipeModel` objects for which to download and cache images.
    private func downloadAndCacheImages(for recipes: [RecipeModel]) async {
        for recipe in recipes {
            await downloadAndCacheImage(from: recipe.photoURLSmall, for: recipe, isLarge: false)
            await downloadAndCacheImage(from: recipe.photoURLLarge, for: recipe, isLarge: true)
        }
    }

    /// Downloads an image from a given URL and caches it in Core Data.
    ///
    /// This method uses `URLSession` to download the image and then saves it to Core Data.
    /// It updates the `recipes` property with the new image data once the download is complete.
    ///
    /// - Parameters:
    ///   - urlString: The URL string from which to download the image.
    ///   - recipe: The `RecipeModel` object for which the image is being downloaded.
    ///   - isLarge: A boolean indicating whether the image should be saved as the large image.
    private func downloadAndCacheImage(from urlString: String, for recipe: RecipeModel, isLarge: Bool) async {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            try await saveImageData(data, for: recipe, isLarge: isLarge)
        } catch {
            print("Failed to download image: \(error.localizedDescription)")
        }
    }

    /// Saves the image data to Core Data and updates the recipe details.
    ///
    /// This method saves the provided image data to the corresponding `Recipe` entity in Core Data
    /// and updates the `recipes` property with the new image data.
    ///
    /// - Parameters:
    ///   - data: The image data to be saved.
    ///   - recipe: The `RecipeModel` object for which the image data is being saved.
    ///   - isLarge: A boolean indicating whether the image should be saved as the large image.
    private func saveImageData(_ data: Data, for recipe: RecipeModel, isLarge: Bool) async throws {
        try await viewContext.perform {
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", recipe.id as CVarArg)

            do {
                let results = try self.viewContext.fetch(fetchRequest)
                if let existingRecipe = results.first {
                    if isLarge {
                        existingRecipe.recipeImageLarge = data
                    } else {
                        existingRecipe.recipeImageSmall = data
                    }
                    try self.viewContext.save()

                    // Update the recipes array with the new image data
                    if let index = self.recipes.firstIndex(where: { $0.id == recipe.id }) {
                        var updatedRecipe = self.recipes[index]
                        if isLarge {
                            updatedRecipe.recipeImageLarge = data
                        } else {
                            updatedRecipe.recipeImageSmall = data
                        }
                        self.recipes[index] = updatedRecipe
                    }
                }
            } catch {
                print("Failed to save image data: \(error.localizedDescription)")
                throw error
            }
        }
    }

}
