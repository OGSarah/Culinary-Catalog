//
//  NetworkError.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/29/25.
//

/// Defines possible network-related errors
enum NetworkError: Error {
    /// The provided URL is invalid
    case invalidURL

    /// The network response is invalid
    case invalidResponse

    /// An error occurred during JSON decoding
    case decodingError

    /// A generic network error
    case networkError(Error)
}

// For unit testing to check for equality.
extension NetworkError {
    func isSameAs(_ other: NetworkError) -> Bool {
        switch (self, other) {
            case (.invalidURL, .invalidURL),
                (.invalidResponse, .invalidResponse):
                return true
            default:
                return false
        }
    }
}
