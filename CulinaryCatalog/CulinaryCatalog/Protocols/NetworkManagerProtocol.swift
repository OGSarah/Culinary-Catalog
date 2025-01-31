//
//  NetworkManagerProtocol.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation

/// Protocol defining the contract for network operations
protocol NetworkManagerProtocol {
    /// Fetches recipes from a network source
    ///
    /// - Returns: An array of recipe models retrieved from the network
    /// - Throws: A network-related error if the request fails
    func fetchRecipesFromNetwork() async throws -> [RecipeModel]
}
