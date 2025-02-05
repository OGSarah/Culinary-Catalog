//
//  MockNetworkManager.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 2/4/25.
//

import Testing
import Foundation
@testable import CulinaryCatalog

class MockNetworkManager: NetworkManagerProtocol {
    var mockURLSession: MockURLSession
    var responseType: MockResponseType
    var mockRecipes: [RecipeModel] = []
    var shouldThrowError: Bool = false

    enum MockResponseType {
        case invalidURL
        case invalidResponse
        case validResponse
    }

    init(responseType: MockResponseType = .validResponse) {
        self.mockURLSession = MockURLSession()
        self.responseType = responseType
        setupMockResponse()
    }

    private func setupMockResponse() {
        switch responseType {
        case .invalidResponse:
            mockURLSession.response = HTTPURLResponse(
                url: URL(string: "https://test.com")!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )

        case .invalidURL, .validResponse:
            // No setup needed for invalid URL or when we assume a valid response for testing
            break
        }
    }

    func fetchRecipesFromNetwork() async throws -> [RecipeModel] {
        // If shouldThrowError is true, we'll ignore responseType and throw an error
        if shouldThrowError {
            throw NetworkError.invalidResponse
        }

        switch responseType {
        case .invalidURL:
            throw NetworkError.invalidURL

        case .invalidResponse:
            throw NetworkError.invalidResponse

        case .validResponse:
            // Return mock recipes for a valid response
            return mockRecipes
        }
    }

}
