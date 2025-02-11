//
//  NetworkError.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/29/25.
//

/// Defines possible network-related errors that can occur during network operations.
///
/// This enum encapsulates common network errors for consistent error handling across network operations in an application. It conforms to the `Error` protocol for use in do-catch blocks or error propagation.
enum NetworkError: Error {
    /// The provided URL is invalid.
    ///
    /// This error is thrown when attempting to create or use a URL that does not conform to the correct format or is otherwise malformed.
    case invalidURL

    /// The network response is invalid.
    ///
    /// Indicates that the response received from the server was not in the expected format or contained errors that prevent further processing.
    case invalidResponse

    /// An error occurred during JSON decoding.
    ///
    /// This error case is used when the JSON data received from the network cannot be parsed into the expected data structure, often due to malformed JSON or schema mismatches.
    case decodingError

    /// A generic network error.
    ///
    /// Captures any other network-related errors not explicitly defined above, wrapping them in this case for general handling. This includes but is not limited to connectivity issues, server-side errors, or timeout scenarios.
    ///
    /// - Parameter Error: The underlying error that was encountered.
    case networkError(Error)
}

// For unit testing to check for equality.
extension NetworkError {
    /// Checks if two `NetworkError` instances are considered the same for testing purposes.
    ///
    /// This method simplifies unit testing by allowing comparison of `NetworkError` instances without needing to check underlying error details, especially useful for cases where only the type of error matters for test assertions.
    ///
    /// - Parameter other: Another `NetworkError` to compare against.
    /// - Returns: `true` if the errors match in type, `false` otherwise. Note that for `networkError`, it does not compare the wrapped errors for equality.
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
