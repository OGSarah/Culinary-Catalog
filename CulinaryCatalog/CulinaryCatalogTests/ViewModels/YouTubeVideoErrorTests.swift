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
            #expect(error as Error != nil)
        }
    }

    @Test func testErrorCases() {
        let invalidVideoIDError = YouTubeVideoError.invalidVideoID
        let networkError = YouTubeVideoError.networkError

        switch invalidVideoIDError {
        case .invalidVideoID:
            #expect(Bool(true))
        case .networkError:
            Issue.record("Should not be networkError")
        }

        switch networkError {
        case .invalidVideoID:
            Issue.record("Should not be invalidVideoID")
        case .networkError:
            #expect(Bool(true))
        }
    }

}
