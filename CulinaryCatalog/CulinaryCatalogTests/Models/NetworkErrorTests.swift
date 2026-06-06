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

    @Test func testInvalidURLMatchesItself() {
        #expect(NetworkError.invalidURL.isSameAs(.invalidURL))
    }

    @Test func testInvalidResponseMatchesItself() {
        #expect(NetworkError.invalidResponse.isSameAs(.invalidResponse))
    }

    @Test func testDecodingErrorMatchesItself() {
        #expect(NetworkError.decodingError.isSameAs(.decodingError))
    }

    @Test func testNetworkErrorMatchesAnotherNetworkErrorRegardlessOfUnderlying() {
        let error1 = NSError(domain: "test", code: 1)
        let error2 = NSError(domain: "test", code: 2)
        #expect(NetworkError.networkError(error1).isSameAs(.networkError(error2)))
    }

    @Test func testDifferentCasesDoNotMatch() {
        #expect(NetworkError.invalidURL.isSameAs(.invalidResponse) == false)
        #expect(NetworkError.decodingError.isSameAs(.invalidURL) == false)
        #expect(NetworkError.invalidResponse.isSameAs(.decodingError) == false)
        let underlying = NSError(domain: "test", code: 1)
        #expect(NetworkError.networkError(underlying).isSameAs(.invalidURL) == false)
    }

}
