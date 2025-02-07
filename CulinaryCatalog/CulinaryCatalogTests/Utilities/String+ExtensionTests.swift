//
//  String+ExtensionTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/6/25.
//

import Testing
@testable import CulinaryCatalog

struct StringExtensionTests {

    @Test func testStandardYouTubeURL() {
        let url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        let id = url.extractYouTubeID()
        #expect(id == "dQw4w9WgXcQ")
    }

    @Test func testShortenedYouTubeURL() {
        let url = "https://youtu.be/dQw4w9WgXcQ"
        let id = url.extractYouTubeID()
        #expect(id == "dQw4w9WgXcQ")
    }

    @Test func testEmbeddedYouTubeURL() {
        let url = "https://www.youtube.com/embed/dQw4w9WgXcQ"
        let id = url.extractYouTubeID()
        #expect(id == "dQw4w9WgXcQ")
    }

    @Test func testYouTubeURLWithAdditionalParameters() {
        let url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=youtu.be"
        let id = url.extractYouTubeID()
        #expect(id == "dQw4w9WgXcQ")
    }

    @Test func testYouTubeURLWithDifferentCase() {
        let url = "HTTPs://WWW.yOuTuBE.cOm/WaTcH?V=DQW4W9wGXcQ"
        let id = url.extractYouTubeID()
        #expect(id == "DQW4W9wGXcQ")
    }

    @Test func testInvalidURL() {
        let url = "https://example.com"
        let id = url.extractYouTubeID()
        #expect(id == nil)
    }

    @Test func testURLWithNoVideoID() {
        let url = "https://www.youtube.com/user/IngridMichaelsonVEVO"
        let id = url.extractYouTubeID()
        #expect(id == nil)
    }

    @Test func testMalformedYouTubeURL() {
        let url = "https://www.youtube.com/watch?v="
        let id = url.extractYouTubeID()
        #expect(id == nil)
    }

    @Test func testURLWithTooShortID() {
        let url = "https://www.youtube.com/watch?v=12345"
        let id = url.extractYouTubeID()
        #expect(id == nil)
    }

    @Test func testURLWithExtendedParameters() {
        let url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ12345"
        let id = url.extractYouTubeID()
        #expect(id == "dQw4w9WgXcQ")
    }

}
