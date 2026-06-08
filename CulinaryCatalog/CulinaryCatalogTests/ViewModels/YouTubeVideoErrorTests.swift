//
//  YouTubeVideoErrorTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/8/25.
//

import Testing
@testable import CulinaryCatalog

struct YouTubeVideoErrorTests {

    @Test func testConformanceToErrorProtocol() {
        let errorCases: [Error] = [
            YouTubeVideoError.invalidVideoID,
            YouTubeVideoError.networkError
        ]

        for error in errorCases {
            #expect((error as Any) is Error)
        }
    }

    @Test func testErrorCases() {
        let invalidVideoIDError = YouTubeVideoError.invalidVideoID
        let networkError = YouTubeVideoError.networkError

        #expect(invalidVideoIDError == .invalidVideoID)
        #expect(invalidVideoIDError != .networkError)
        #expect(networkError == .networkError)
        #expect(networkError != .invalidVideoID)
    }

}
