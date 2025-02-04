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

    enum MockResponseType {
        case invalidURL
        case invalidResponse
    }

    init(responseType: MockResponseType) {
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

        case .invalidURL:
            break
        }
    }

    func fetchRecipesFromNetwork() async throws -> [RecipeModel] {
        switch responseType {
        case .invalidURL:
            throw NetworkError.invalidURL

        case .invalidResponse:
            throw NetworkError.invalidResponse
        }
    }
}
