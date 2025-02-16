//
//  RecipeDetailStateTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/7/25.
//

import Foundation
import Testing
@testable import CulinaryCatalog

struct RecipeDetailStateTests {

    @Test("Test RecipeDetailState Initialization")
    func testInitialization() throws {
        let state = RecipeDetailState(
            recipeName: "Blackberry Fool",
            cuisineType: "British",
            photoLarge: Data(),
            sourceURL: "example.com/blackberry-fool",
            youtubeVideoID: "dQw4w9WgXcQ"
        )

        #expect(state.recipeName == "Blackberry Fool")
        #expect(state.cuisineType == "British")
        #expect(state.photoLarge == Data())
        #expect(state.sourceURL == "example.com/blackberry-fool")
        #expect(state.youtubeVideoID == "dQw4w9WgXcQ")
    }

    @Test("Test RecipeDetailState with Optional YouTube ID")
    func testOptionalYouTubeID() throws {
        let stateWithNoVideo = RecipeDetailState(
            recipeName: "Apple Pie",
            cuisineType: "American",
            photoLarge: Data(),
            sourceURL: "example.com/apple-pie",
            youtubeVideoID: nil
        )

        #expect(stateWithNoVideo.recipeName == "Apple Pie")
        #expect(stateWithNoVideo.cuisineType == "American")
        #expect(stateWithNoVideo.photoLarge == Data())
        #expect(stateWithNoVideo.sourceURL == "example.com/apple-pie")
        #expect(stateWithNoVideo.youtubeVideoID == nil)
    }

    @Test("Test RecipeDetailState Property Access")
    func testPropertyAccess() throws {
        let state = RecipeDetailState(
            recipeName: "Sushi Roll",
            cuisineType: "Japanese",
            photoLarge: Data(),
            sourceURL: "example.com/sushi-roll",
            youtubeVideoID: "videoID"
        )

        // Check if all properties can be accessed correctly
        #expect(state.recipeName == "Sushi Roll")
        #expect(state.cuisineType == "Japanese")
        #expect(state.photoLarge == Data())
        #expect(state.sourceURL == "example.com/sushi-roll")
        #expect(state.youtubeVideoID == "videoID")
    }

}
