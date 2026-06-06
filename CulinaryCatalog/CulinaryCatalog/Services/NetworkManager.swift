//
//  NetworkManager.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/29/25.
//

import Foundation

/// Manages network requests for recipe data.
///
/// `NetworkManager` is an actor that ensures thread-safe handling of network operations. It conforms to `NetworkManagerProtocol`, facilitating dependency injection and unit testing. This class handles the fetching of recipe data from a remote server, providing a centralized point for all network-related activities concerning recipes.
///
/// - Note: As an `actor`, this class guarantees that its methods are executed sequentially, which is crucial for managing asynchronous network calls safely.
actor NetworkManager: NetworkManagerProtocol {
    /// Shared singleton instance for global access to network operations.
    ///
    /// Use this for accessing the `NetworkManager` throughout your application where a single, shared instance is beneficial for managing network requests.
    static let shared = NetworkManager()

    /// Base URL for fetching recipes.
    ///
    /// This string represents the endpoint from which recipe data will be fetched. It's configurable at initialization for flexibility in testing or different environments.
    private let baseURL: String

    /// Optional dependency injection for URLSession.
    ///
    /// Allows for injecting a custom `URLSessionProtocol` implementation, facilitating unit testing or using different network configurations without altering the rest of the class.
    private let urlSession: URLSessionProtocol

    /// Bundle searched for a fallback `recipes.json` when the network is unreachable.
    ///
    /// When `nil`, no fallback is attempted and network errors are propagated unchanged. Tests pass `nil` here to exercise error-propagation paths without picking up the app's bundled data.
    private let fallbackBundle: Bundle?

    /// Resource name (without extension) for the bundled fallback JSON file.
    private let fallbackResourceName: String

    /// Initializes the NetworkManager.
    ///
    /// - Parameters:
    ///   - baseURL: The URL to fetch recipes from. Defaults to a CloudFront-hosted JSON file containing recipe data.
    ///   - urlSession: A custom `URLSessionProtocol` conforming object for network operations. Defaults to `URLSession.shared` for standard network requests.
    ///   - fallbackBundle: Bundle searched for a bundled copy of the recipes JSON when the remote host is unreachable. Pass `nil` to disable the fallback (used by unit tests that assert error propagation).
    ///   - fallbackResourceName: Name of the bundled JSON resource (without extension) used as a fallback.
    init(
        baseURL: String = "https://OGSarah.github.io/Culinary-Catalog-Data/desserts.json",
        urlSession: URLSessionProtocol = URLSession.shared,
        fallbackBundle: Bundle? = .main,
        fallbackResourceName: String = "recipes"
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.fallbackBundle = fallbackBundle
        self.fallbackResourceName = fallbackResourceName
    }

    /// Fetches recipes from the network asynchronously.
    ///
    /// This method performs the following steps:
    /// 1. Validates the URL.
    /// 2. Uses the injected `URLSession` to fetch data.
    /// 3. Checks if the HTTP response is successful.
    /// 4. Decodes the JSON data into `RecipeModel` objects.
    /// 5. Falls back to a bundled `recipes.json` if step 2 fails with a transport error (e.g. DNS resolution failure, no connectivity).
    ///
    /// - Returns: An array of `RecipeModel` instances representing the recipes fetched from the network, or the bundled fallback when the network is unreachable.
    /// - Throws:
    ///   - `NetworkError.invalidURL`: If the `baseURL` cannot be converted to a valid `URL`.
    ///   - `NetworkError.invalidResponse`: If the server response is not in the 2xx status code range.
    ///   - `NetworkError.decodingError`: If there's an error decoding the JSON data into `RecipesResponse`.
    func fetchRecipesFromNetwork() async throws -> [RecipeModel] {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await urlSession.data(from: url)
        } catch {
            if let bundled = loadBundledRecipes() {
                print("NetworkManager: remote fetch failed (\(error.localizedDescription)) — using bundled recipes.json")
                return bundled
            }
            throw error
        }

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

    /// Loads and decodes the bundled fallback recipes file.
    ///
    /// - Returns: The decoded recipes, or `nil` if no fallback bundle is configured or the file cannot be read/decoded.
    private func loadBundledRecipes() -> [RecipeModel]? {
        guard let bundle = fallbackBundle,
              let url = bundle.url(forResource: fallbackResourceName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(RecipesResponse.self, from: data) else {
            return nil
        }
        return decoded.recipes.map { $0.toDomain() }
    }

}
