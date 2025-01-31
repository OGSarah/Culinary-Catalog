//
//  RecipeRepository.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import CoreData
import Network

/// Repository for managing recipe data retrieval
final class RecipeRepository: RecipeRepositoryProtocol {
    /// Network manager for fetching recipes
    private let networkManager: NetworkManagerProtocol

    /// Core Data context for persistence
    private let viewContext: NSManagedObjectContext

    /// Initializes the repository
    ///
    /// - Parameters:
    ///   - networkManager: The network manager to fetch recipes
    ///   - viewContext: The Core Data context for storage
    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        viewContext: NSManagedObjectContext
    ) {
        self.networkManager = networkManager
        self.viewContext = viewContext
    }

    /// Fetches recipes from local storage
    ///
    /// - Returns: An array of recipe models from Core Data
    /// - Throws: Core Data related errors
    func fetchRecipes() async throws -> [RecipeModel] {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        do {
            let entities = try viewContext.fetch(fetchRequest)
            return entities.map { RecipeModel(entity: $0) }
        } catch {
            throw error
        }
    }

    /// Refreshes recipes by fetching from network and updating local storage
    ///
    /// - Returns: An updated array of recipe models
    /// - Throws: Network or Core Data related errors
    func refreshRecipes() async throws -> [RecipeModel] {
        // Fetch from network
        let newRecipes = try await networkManager.fetchRecipesFromNetwork()

        // Clear existing recipes
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Recipe.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try viewContext.execute(batchDeleteRequest)

        // Save new recipes
        for recipeModel in newRecipes {
            let newRecipe = Recipe(context: viewContext)
            newRecipe.id = recipeModel.id
            newRecipe.recipeName = recipeModel.recipeName
            newRecipe.cuisineType = recipeModel.cuisineType
            newRecipe.photoSmall = recipeModel.photoSmall
            newRecipe.photoLarge = recipeModel.photoLarge
            newRecipe.sourceURL = recipeModel.sourceURL
            newRecipe.youTubeURL = recipeModel.youTubeURL
        }

        try viewContext.save()

        return newRecipes
    }

}
