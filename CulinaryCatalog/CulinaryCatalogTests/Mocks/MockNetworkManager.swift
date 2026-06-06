//
//  MockNetworkManager.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 2/4/25.
//

import Foundation
@testable import CulinaryCatalog

/// A test double for `NetworkManagerProtocol`.
///
/// Configure `mockRecipes`, `responseType`, or `shouldThrowError` to drive the desired branch
/// in tests that exercise `RecipeListViewModel` or other consumers of the network layer.
final class MockNetworkManager: NetworkManagerProtocol {
    var mockRecipes: [RecipeModel] = []
    var shouldThrowError: Bool = false
    var responseType: MockResponseType

    enum MockResponseType {
        case invalidURL
        case invalidResponse
        case validResponse
    }

    init(responseType: MockResponseType = .validResponse) {
        self.responseType = responseType
    }

    func fetchRecipesFromNetwork() async throws -> [RecipeModel] {
        if shouldThrowError {
            throw NetworkError.invalidResponse
        }

        switch responseType {
        case .invalidURL:
            throw NetworkError.invalidURL
        case .invalidResponse:
            throw NetworkError.invalidResponse
        case .validResponse:
            return mockRecipes
        }
    }

}
