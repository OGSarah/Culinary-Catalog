//
//  RecipeDataRepository.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import CoreData
import Network

/// A concrete implementation of `RecipeDataRepositoryProtocol` for handling recipe data operations.
///
/// This class orchestrates the interaction between network data fetching and local persistence using Core Data. It manages the lifecycle of recipe data from retrieval from a remote API to storage and retrieval from the local database, ensuring data consistency across different parts of the application.
final class RecipeDataRepository: RecipeDataRepositoryProtocol {
    /// The network manager responsible for API calls to fetch recipe data from remote services.
    ///
    /// This dependency allows the class to interact with network resources, abstracting away the specifics of how data is retrieved from the server.
    private let networkManager: NetworkManagerProtocol

    /// The Core Data managed object context used for local data persistence.
    ///
    /// This context is used for all Core Data operations related to recipes, ensuring thread-safe access to the database.
    private let viewContext: NSManagedObjectContext

    /// Sets up the repository with its dependencies for network and local storage operations.
    ///
    /// - Parameters:
    ///   - networkManager: An instance of `NetworkManagerProtocol` for fetching recipes from the network. Defaults to `NetworkManager.shared` for easy setup with the shared instance.
    ///   - viewContext: The `NSManagedObjectContext` for local storage operations using Core Data. This context should generally be the main context for UI updates.
    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        viewContext: NSManagedObjectContext
    ) {
        self.networkManager = networkManager
        self.viewContext = viewContext
    }

    /// Retrieves all recipes currently stored in Core Data.
    ///
    /// This method queries the local database for all `Recipe` entities, transforms them into `RecipeModel` objects, and sorts them alphabetically by name for presentation or further processing.
    ///
    /// - Returns: An array of `RecipeModel` objects representing all recipes in local storage, sorted alphabetically by recipe name.
    /// - Throws: An error if there's an issue with fetching data from Core Data, such as database corruption or access issues.
    func fetchRecipes() async throws -> [RecipeModel] {
        let fetchRequest: NSFetchRequest = Recipe.fetchRequest()

        do {
            let entities = try viewContext.fetch(fetchRequest)
            return entities
                .compactMap { RecipeModel(entity: $0) }
                .sorted { $0.recipeName.localizedCaseInsensitiveCompare($1.recipeName) == .orderedAscending }
        } catch {
            throw error
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
            let fetchRequest: NSFetchRequest = Recipe.fetchRequest()
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

}
