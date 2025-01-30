//
//  NetworkManager.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/29/25.
//

import Foundation

actor NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"

    private init() {}

    func fetchRecipesFromNetwork() async throws -> [RecipeModel] {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

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
