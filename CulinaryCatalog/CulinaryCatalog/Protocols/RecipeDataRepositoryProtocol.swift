//
//  RecipeDataRepositoryProtocol.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

/// A protocol defining the contract for recipe data retrieval and management.
///
/// This protocol abstracts the data source interactions for recipe-related operations,
/// providing a clean, consistent interface for fetching and updating recipe data.
///
/// The repository pattern separates the logic of data access from the rest of the application,
/// allowing for easy swapping of data sources and improved testability.
///
/// - Note: Implementations can vary between network, local database, or mock data sources
/// - Important: All methods are asynchronous and can throw errors
protocol RecipeDataRepositoryProtocol {
    /// Retrieves recipes from the local data store.
    ///
    /// - Returns: An array of `RecipeModel` objects representing the recipes stored locally.
    /// - Throws: An error if there's an issue with fetching data from Core Data.
    func fetchRecipes() async throws -> [RecipeModel]

    /// Updates the local recipe database with the latest data from the network.
    ///
    /// - Returns: An array of `RecipeModel` objects reflecting the newly fetched and stored recipes.
    /// - Throws: An error if there are issues with network requests or local data persistence.
    func refreshRecipes() async throws -> [RecipeModel]
}
