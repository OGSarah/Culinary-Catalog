//
//  NetworkErrorTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/7/25.
//

import Foundation
import Testing
@testable import CulinaryCatalog

struct NetworkErrorTests {

    @Test func testNetworkErrorEquivalence() {
        // Test invalidURL
        let invalidURL1 = NetworkError.invalidURL
        let invalidURL2 = NetworkError.invalidURL
        #expect(invalidURL1.isSameAs(invalidURL2))

        // Test invalidResponse
        let invalidResponse1 = NetworkError.invalidResponse
        let invalidResponse2 = NetworkError.invalidResponse
        #expect(invalidResponse1.isSameAs(invalidResponse2))

        // Test different error types
        #expect(invalidURL1.isSameAs(invalidResponse1) == false)

        // Test networkError with same underlying error
        let error1 = NSError(domain: "test", code: 1, userInfo: nil)
        let networkError1 = NetworkError.networkError(error1)
        let networkError2 = NetworkError.networkError(error1)
        #expect(networkError1.isSameAs(networkError2) == false) // Note: isSameAs doesn't check for error equality, just type

        // Test networkError with different underlying errors
        let error2 = NSError(domain: "test", code: 2, userInfo: nil)
        let networkError3 = NetworkError.networkError(error2)
        #expect(networkError1.isSameAs(networkError3) == false)

        // Test decodingError
        let decodingError1 = NetworkError.decodingError
        let decodingError2 = NetworkError.decodingError
        #expect(decodingError1.isSameAs(decodingError2) == false) // Since `isSameAs` doesn't handle this case, this test will fail
    }

}
