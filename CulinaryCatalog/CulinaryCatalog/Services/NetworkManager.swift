//
//  NetworkManager.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/29/25.
//

import Foundation

/// Manages network requests for recipe data
actor NetworkManager: NetworkManagerProtocol {
    /// Shared singleton instance
    static let shared = NetworkManager()

    /// Base URL for fetching recipes
    private let baseURL: String

    /// Optional dependency injection for URLSession
    private let urlSession: URLSession

    /// Initializes the NetworkManager
    ///
    /// - Parameters:
    ///   - baseURL: The URL to fetch recipes from
    ///   - urlSession: A custom URLSession (defaults to shared session)
    init(
        baseURL: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json",
        urlSession: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }

    /// Fetches recipes from the network
    ///
    /// - Returns: An array of recipe models
    /// - Throws: Specific network-related errors
    func fetchRecipesFromNetwork() async throws -> [RecipeModel] {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await urlSession.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(RecipesResponse.self, from: data)
            return response.recipes.map { $0.toDomain() }
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
}
