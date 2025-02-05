//
//  RecipeDetailViewModelTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/4/25.
//

import SwiftUI
import Testing
@testable import CulinaryCatalog

struct RecipeDetailViewModelTests {

    @Test func testInitialization() throws {
        let recipe = RecipeModel(
            cuisineType: "Italian",
            recipeName: "Test Recipe",
            photoLarge: "example.com/big.jpg",
            photoSmall: "example.com/small.jpg",
            sourceURL: "example.com",
            id: UUID(),
            youTubeURL: "youtube.com/watch?v=dQw4w9WgXcQ"
        )
        let viewModel = RecipeDetailViewModel(recipe: recipe)

        #expect(viewModel.recipeDetails.recipeName == "Test Recipe")
        #expect(viewModel.recipeDetails.cuisineType == "Italian")
        #expect(viewModel.recipeDetails.photoLarge == "example.com/big.jpg")
        #expect(viewModel.recipeDetails.sourceURL == "example.com")
        #expect(viewModel.recipeDetails.youtubeVideoID == "dQw4w9WgXcQ")
    }

    @Test func testYouTubeIDExtraction() throws {
        let recipe = RecipeModel(
            cuisineType: "Italian",
            recipeName: "Test Recipe",
            photoLarge: "example.com/big.jpg",
            photoSmall: "example.com/small.jpg",
            sourceURL: "example.com",
            id: UUID(),
            youTubeURL: "youtube.com/watch?v=dQw4w9WgXcQ"
        )
        let viewModel = RecipeDetailViewModel(recipe: recipe)

        #expect(viewModel.recipeDetails.youtubeVideoID == "dQw4w9WgXcQ")
    }

    @Test func testGetCountryFlag() throws {
        let viewModel = RecipeDetailViewModel(recipe: RecipeModel(
            cuisineType: "Italian",
            recipeName: "Placeholder",
            photoLarge: "example.com/big.jpg",
            photoSmall: "example.com/small.jpg",
            sourceURL: "example.com",
            id: UUID(),
            youTubeURL: "youtube.com/watch?v=dQw4w9WgXcQ"
        ))

        // Test known cuisine types
        #expect(viewModel.getCountryFlag(for: "Italian") == "🇮🇹")
        #expect(viewModel.getCountryFlag(for: "American") == "🇺🇸")
        #expect(viewModel.getCountryFlag(for: "British") == "🇬🇧")
        #expect(viewModel.getCountryFlag(for: "Malaysian") == "🇲🇾")

        // Test case insensitivity
        #expect(viewModel.getCountryFlag(for: "italian") == "🇮🇹")

        // Test default case
        #expect(viewModel.getCountryFlag(for: "Unknown") == "🌍")
    }

    @Test func testGetCountryFlagDefaultCase() throws {
        let viewModel = RecipeDetailViewModel(recipe: RecipeModel(
            cuisineType: "Unknown",
            recipeName: "Placeholder",
            photoLarge: "example.com/big.jpg",
            photoSmall: "example.com/small.jpg",
            sourceURL: "example.com",
            id: UUID(),
            youTubeURL: "youtube.com/watch?v=dQw4w9WgXcQ"
        ))

        #expect(viewModel.getCountryFlag(for: "NonExistentCuisine") == "🌍")
    }

}
