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
/// This class manages both the fetching of recipes from a network source and their persistence in local storage via Core Data.
final class RecipeDataRepository: RecipeDataRepositoryProtocol {
    /// The network manager responsible for API calls to fetch recipe data from remote services.
    private let networkManager: NetworkManagerProtocol

    /// The Core Data managed object context used for local data persistence.
    private let viewContext: NSManagedObjectContext

    /// Sets up the repository with its dependencies for network and local storage operations.
    ///
    /// - Parameters:
    ///   - networkManager: An instance of `NetworkManagerProtocol` for fetching recipes from the network. Defaults to `NetworkManager.shared`.
    ///   - viewContext: The `NSManagedObjectContext` for local storage operations using Core Data.
    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        viewContext: NSManagedObjectContext
    ) {
        self.networkManager = networkManager
        self.viewContext = viewContext
    }

    /// Retrieves all recipes currently stored in Core Data.
    ///
    /// This method fetches all `Recipe` entities from the local database and converts them to `RecipeModel` objects for use in the UI layer.
    ///
    /// - Returns: An array of alphabetically sorted`RecipeModel` objects representing all recipes in local storage.
    /// - Throws: An error if there's an issue with fetching data from Core Data.
    func fetchRecipes() async throws -> [RecipeModel] {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        do {
            let entities = try viewContext.fetch(fetchRequest)
            return entities
                .map { RecipeModel(entity: $0) }
                .sorted { $0.recipeName.localizedCaseInsensitiveCompare($1.recipeName) == .orderedAscending }
        } catch {
            throw error
        }
    }

    /// Synchronizes local data with the latest from the server.
    ///
    /// This method performs a full refresh by:
    /// 1. Clearing all existing recipes from Core Data.
    /// 2. Fetching new recipes from the network.
    /// 3. Saving these new recipes to Core Data.
    ///
    /// - Returns: An array of `RecipeModel` objects representing the updated set of recipes.
    /// - Throws: An error if network fetching fails, or if there's a problem saving to or clearing from Core Data.
    func refreshRecipes() async throws -> [RecipeModel] {
        let newRecipes = try await networkManager.fetchRecipesFromNetwork()

        try await viewContext.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Recipe.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            // Execute batch delete on the correct context
            let batchDeleteResult = try self.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult

            // Refresh the context after batch delete
            if let result = batchDeleteResult?.result as? [AnyObject],
                let persistentStore = batchDeleteResult?.result {
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: result], into: [self.viewContext])
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

            // Save context with error handling
            try self.viewContext.save()
        }

        return newRecipes
    }

}
