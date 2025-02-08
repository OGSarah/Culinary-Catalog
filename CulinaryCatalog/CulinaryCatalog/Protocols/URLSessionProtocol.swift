//
//  URLSessionProtocol.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 2/4/25.
//

import Foundation

/// A protocol that mimics the `URLSession` data task interface for network operations.
///
/// This protocol is designed to abstract away the specific implementation of network requests, allowing for easier testing and dependency injection. By conforming to this protocol, different network layer implementations can be used interchangeably without changing the rest of the codebase.
///
/// - Note: This protocol assumes asynchronous operations with error handling, aligning with modern Swift practices for network calls.
protocol URLSessionProtocol {
    /// Performs an asynchronous data task to fetch data from a specified URL.
    ///
    /// This method mirrors the `data(for:delegate:)` method of `URLSession`, but it's designed to work asynchronously with Swift's `async/await` syntax. It allows for a more straightforward, sequential handling of network operations in your code.
    ///
    /// - Parameter url: The URL from which to fetch the data.
    /// - Returns: A tuple containing the `Data` fetched from the URL and the corresponding `URLResponse`.
    /// - Throws: An error if the network request fails, including but not limited to:
    ///   - Network connectivity issues
    ///   - Server errors
    ///   - Invalid URL
    ///   - Data parsing or decoding errors
    func data(from url: URL) async throws -> (Data, URLResponse)
}
