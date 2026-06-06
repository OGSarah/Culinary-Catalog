//
//  RecipeDetailViewModelTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/4/25.
//

import SwiftUI
import Testing
@testable import CulinaryCatalog

@MainActor
struct RecipeDetailViewModelTests {

    private func makeRecipe(
        cuisineType: String = "Italian",
        recipeImageLarge: Data? = nil,
        youTubeURL: String = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    ) -> RecipeModel {
        RecipeModel(
            cuisineType: cuisineType,
            recipeName: "Test Recipe",
            photoURLLarge: "example.com/big.jpg",
            photoURLSmall: "example.com/small.jpg",
            recipeImageSmall: nil,
            recipeImageLarge: recipeImageLarge,
            sourceURL: "example.com",
            id: UUID(),
            youTubeURL: youTubeURL
        )
    }

    @Test func testInitialization() throws {
        let viewModel = RecipeDetailViewModel(recipe: makeRecipe())

        #expect(viewModel.recipeDetails.recipeName == "Test Recipe")
        #expect(viewModel.recipeDetails.cuisineType == "Italian")
        #expect(viewModel.recipeDetails.sourceURL == "example.com")
        #expect(viewModel.recipeDetails.youtubeVideoID == "dQw4w9WgXcQ")
    }

    @Test func testPhotoLargeUsesProvidedImageData() throws {
        let imageData = Data([0xDE, 0xAD, 0xBE, 0xEF])
        let viewModel = RecipeDetailViewModel(recipe: makeRecipe(recipeImageLarge: imageData))

        #expect(viewModel.recipeDetails.photoLarge == imageData)
    }

    @Test func testPhotoLargeDefaultsToEmptyDataWhenNil() throws {
        let viewModel = RecipeDetailViewModel(recipe: makeRecipe(recipeImageLarge: nil))

        #expect(viewModel.recipeDetails.photoLarge == Data())
    }

    @Test func testYouTubeIDExtraction() throws {
        let viewModel = RecipeDetailViewModel(recipe: makeRecipe(
            youTubeURL: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        ))

        #expect(viewModel.recipeDetails.youtubeVideoID == "dQw4w9WgXcQ")
    }

    @Test func testYouTubeIDExtractionWithShortenedURL() throws {
        let viewModel = RecipeDetailViewModel(recipe: makeRecipe(
            youTubeURL: "https://youtu.be/dQw4w9WgXcQ"
        ))

        #expect(viewModel.recipeDetails.youtubeVideoID == "dQw4w9WgXcQ")
    }

    @Test func testYouTubeIDIsNilForInvalidURL() throws {
        let viewModel = RecipeDetailViewModel(recipe: makeRecipe(
            youTubeURL: "https://example.com/no-video"
        ))

        #expect(viewModel.recipeDetails.youtubeVideoID == nil)
    }

    @Test func testYouTubeIDIsNilForEmptyURL() throws {
        let viewModel = RecipeDetailViewModel(recipe: makeRecipe(youTubeURL: ""))

        #expect(viewModel.recipeDetails.youtubeVideoID == nil)
    }

    @Test func testGetCountryFlagKnownCuisines() throws {
        let viewModel = RecipeDetailViewModel(recipe: makeRecipe())

        #expect(viewModel.getCountryFlag(for: "American") == "🇺🇸")
        #expect(viewModel.getCountryFlag(for: "British") == "🇬🇧")
        #expect(viewModel.getCountryFlag(for: "Malaysian") == "🇲🇾")
        #expect(viewModel.getCountryFlag(for: "Canadian") == "🇨🇦")
        #expect(viewModel.getCountryFlag(for: "Italian") == "🇮🇹")
        #expect(viewModel.getCountryFlag(for: "French") == "🇫🇷")
        #expect(viewModel.getCountryFlag(for: "Tunisian") == "🇹🇳")
        #expect(viewModel.getCountryFlag(for: "Greek") == "🇬🇷")
        #expect(viewModel.getCountryFlag(for: "Polish") == "🇵🇱")
        #expect(viewModel.getCountryFlag(for: "Portuguese") == "🇵🇹")
        #expect(viewModel.getCountryFlag(for: "Russian") == "🇷🇺")
        #expect(viewModel.getCountryFlag(for: "Croatian") == "🇭🇷")
    }

    @Test func testGetCountryFlagIsCaseInsensitive() throws {
        let viewModel = RecipeDetailViewModel(recipe: makeRecipe())

        #expect(viewModel.getCountryFlag(for: "italian") == "🇮🇹")
        #expect(viewModel.getCountryFlag(for: "ITALIAN") == "🇮🇹")
        #expect(viewModel.getCountryFlag(for: "iTaLiAn") == "🇮🇹")
    }

    @Test func testGetCountryFlagDefaultCase() throws {
        let viewModel = RecipeDetailViewModel(recipe: makeRecipe())

        #expect(viewModel.getCountryFlag(for: "Unknown") == "🌍")
        #expect(viewModel.getCountryFlag(for: "") == "🌍")
    }

}
