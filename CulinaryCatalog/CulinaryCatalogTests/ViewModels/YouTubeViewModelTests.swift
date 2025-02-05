//
//  YouTubeViewModelTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/4/25.
//

import Testing
@testable import CulinaryCatalog

struct YouTubeViewModelTests {

    @Test func testValidVideoIDInitialization() async throws {
        let viewModel = YouTubeVideoViewModel(videoID: "dQw4w9WgXcQ")

        #expect(viewModel.embedURL != nil)
        #expect(viewModel.error == nil)
    }

    @Test func testInvalidVideoIDInitialization() async throws {
        let viewModel = YouTubeVideoViewModel(videoID: "invalidID")

        #expect(viewModel.embedURL == nil)
        #expect(viewModel.error != nil)
        #expect((viewModel.error as? YouTubeVideoError) == .invalidVideoID)
    }

    @Test func testVideoIDValidationWithValidID() async throws {
        let viewModel = YouTubeVideoViewModel(videoID: "dQw4w9WgXcQ")

        viewModel.validateVideoID("dQw4w9WgXcQ")
        #expect(viewModel.error == nil)
    }

    @Test func testVideoIDValidationWithEmptyID() async throws {
        let viewModel = YouTubeVideoViewModel(videoID: "dQw4w9WgXcQ")

        viewModel.validateVideoID("")
        #expect(viewModel.error != nil)
        #expect((viewModel.error as? YouTubeVideoError) == .invalidVideoID)
    }

    @Test func testVideoIDValidationWithShortID() async throws {
        let viewModel = YouTubeVideoViewModel(videoID: "dQw4w9WgXcQ")

        viewModel.validateVideoID("dQw4w9WgXc")
        #expect(viewModel.error != nil)
        #expect((viewModel.error as? YouTubeVideoError) == .invalidVideoID)
    }

    @Test func testVideoIDValidationWithLongID() async throws {
        let viewModel = YouTubeVideoViewModel(videoID: "dQw4w9WgXcQ")

        viewModel.validateVideoID("dQw4w9WgXcQQ")
        #expect(viewModel.error != nil)
        #expect((viewModel.error as? YouTubeVideoError) == .invalidVideoID)
    }

}
