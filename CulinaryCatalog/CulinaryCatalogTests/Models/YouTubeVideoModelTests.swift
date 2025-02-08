//
//  YouTubeVideoModelTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/8/25.
//

import Testing
@testable import CulinaryCatalog

struct YouTubeVideoModelTests {

    @Test func testEmbedURLCreation() {
        let videoID = "dQw4w9WgXcQ"
        let model = YouTubeVideoModel(videoID: videoID)

        #expect(model.embedURL != nil)
        #expect(model.embedURL?.absoluteString == "https://www.youtube.com/embed/\(videoID)")
    }

    @Test func testEmbedURLWithSpecialCharactersInID() {
        let videoIDWithSpecialChars = "dQw4w9WgXcQ-!"
        let model = YouTubeVideoModel(videoID: videoIDWithSpecialChars)

        #expect(model.embedURL != nil)
        #expect(model.embedURL?.absoluteString == "https://www.youtube.com/embed/\(videoIDWithSpecialChars)")
    }

}
