//
//  NetworkManagerTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/4/25.
//

import Testing
@testable import CulinaryCatalog

struct NetworkManagerTests {

    @Test func testFetchRecipesFromNetwork() async throws {
        let networkManager = NetworkManager(baseURL: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
        let recipes = try await networkManager.fetchRecipesFromNetwork()

        #expect(recipes.count == 63)
        #expect(recipes.first?.recipeName != nil)
    }

    @Test func testDecodingError() async throws {
        let networkManager = NetworkManager(baseURL: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")

        do {
            _ = try await networkManager.fetchRecipesFromNetwork()
            #expect(Bool(false))
        } catch NetworkError.decodingError {
            #expect(Bool(true))
        }
    }

    @Test func testInvalidResponse() async throws {
        let networkManager = MockNetworkManager(responseType: .invalidResponse)

        do {
            _ = try await networkManager.fetchRecipesFromNetwork()
            #expect(Bool(false))
        } catch {
            #expect((error as? NetworkError)?.isSameAs(.invalidResponse) ?? false)
        }
    }

    @Test func testInvalidURL() async throws {
        let networkManager = MockNetworkManager(responseType: .invalidURL)

        do {
            _ = try await networkManager.fetchRecipesFromNetwork()
            #expect(Bool(false))
        } catch {
            #expect((error as? NetworkError)?.isSameAs(.invalidURL) ?? false)
        }
    }

}
