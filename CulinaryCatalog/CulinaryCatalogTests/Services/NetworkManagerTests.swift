//
//  NetworkManagerTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/4/25.
//

import Foundation
import Testing
@testable import CulinaryCatalog

struct NetworkManagerTests {

    private let validURL = "https://example.com/recipes.json"

    private func makeHTTPResponse(statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    private func validRecipesJSON() -> Data {
        let jsonString = """
        {
            "recipes": [
                {
                    "cuisine": "Italian",
                    "name": "Pizza Margherita",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg",
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "source_url": "https://example.com/source",
                    "youtube_url": "https://youtu.be/dQw4w9WgXcQ"
                },
                {
                    "cuisine": "French",
                    "name": "Baguette",
                    "photo_url_large": "https://example.com/large2.jpg",
                    "photo_url_small": "https://example.com/small2.jpg",
                    "uuid": "223e4567-e89b-12d3-a456-426614174000",
                    "source_url": "https://example.com/source2",
                    "youtube_url": "https://youtu.be/abcdefghijk"
                }
            ]
        }
        """
        return Data(jsonString.utf8)
    }

    @Test func testFetchRecipesSuccess() async throws {
        let mockSession = MockURLSession()
        mockSession.data = validRecipesJSON()
        mockSession.response = makeHTTPResponse(statusCode: 200)

        let networkManager = NetworkManager(baseURL: validURL, urlSession: mockSession)
        let recipes = try await networkManager.fetchRecipesFromNetwork()

        #expect(recipes.count == 2)
        #expect(recipes.first?.recipeName == "Pizza Margherita")
        #expect(recipes.first?.cuisineType == "Italian")
    }

    @Test func testFetchRecipesEmptyResponse() async throws {
        let mockSession = MockURLSession()
        mockSession.data = Data("{\"recipes\": []}".utf8)
        mockSession.response = makeHTTPResponse(statusCode: 200)

        let networkManager = NetworkManager(baseURL: validURL, urlSession: mockSession)
        let recipes = try await networkManager.fetchRecipesFromNetwork()

        #expect(recipes.isEmpty)
    }

    @Test func testInvalidURLThrowsInvalidURLError() async {
        let networkManager = NetworkManager(baseURL: "", urlSession: MockURLSession())

        await #expect(throws: NetworkError.self) {
            _ = try await networkManager.fetchRecipesFromNetwork()
        }
    }

    @Test func testNon200StatusThrowsInvalidResponse() async {
        let mockSession = MockURLSession()
        mockSession.data = Data()
        mockSession.response = makeHTTPResponse(statusCode: 500)

        let networkManager = NetworkManager(baseURL: validURL, urlSession: mockSession)

        do {
            _ = try await networkManager.fetchRecipesFromNetwork()
            Issue.record("Expected invalidResponse error to be thrown")
        } catch let error as NetworkError {
            #expect(error.isSameAs(.invalidResponse))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test func testMalformedJSONThrowsDecodingError() async {
        let mockSession = MockURLSession()
        mockSession.data = Data("{ not valid json".utf8)
        mockSession.response = makeHTTPResponse(statusCode: 200)

        let networkManager = NetworkManager(baseURL: validURL, urlSession: mockSession)

        do {
            _ = try await networkManager.fetchRecipesFromNetwork()
            Issue.record("Expected decodingError to be thrown")
        } catch let error as NetworkError {
            #expect(error.isSameAs(.decodingError))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test func testUnderlyingNetworkErrorIsPropagated() async {
        let mockSession = MockURLSession()
        mockSession.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)

        let networkManager = NetworkManager(baseURL: validURL, urlSession: mockSession)

        await #expect(throws: (any Error).self) {
            _ = try await networkManager.fetchRecipesFromNetwork()
        }
    }

}
