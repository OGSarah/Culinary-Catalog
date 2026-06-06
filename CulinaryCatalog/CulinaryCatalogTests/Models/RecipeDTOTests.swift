//
//  RecipeDTOTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/7/25.
//

import Foundation
import Testing
@testable import CulinaryCatalog

struct RecipeDTOTests {

    @Test func testRecipesResponseDecoding() throws {
        let jsonString = """
        {
            "recipes": [
                {
                    "cuisine": "Italian",
                    "name": "Pizza Margherita",
                    "photo_url_large": "large.jpg",
                    "photo_url_small": "small.jpg",
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "source_url": "example.com/pizza",
                    "youtube_url": "youtube.com/pizza"
                }
            ]
        }
        """

        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        let recipesResponse = try decoder.decode(RecipesResponse.self, from: jsonData)

        #expect(recipesResponse.recipes.count == 1)
        #expect(recipesResponse.recipes.first?.cuisine == "Italian")
    }

    @Test func testRecipesResponseEmptyDecoding() throws {
        let jsonString = """
        {
            "recipes": []
        }
        """

        let jsonData = Data(jsonString.utf8)
        let response = try JSONDecoder().decode(RecipesResponse.self, from: jsonData)

        #expect(response.recipes.isEmpty)
    }

    @Test func testRecipeDTODecoding() throws {
        let jsonString = """
        {
            "cuisine": "Italian",
            "name": "Pizza Margherita",
            "photo_url_large": "large.jpg",
            "photo_url_small": "small.jpg",
            "uuid": "123e4567-e89b-12d3-a456-426614174000",
            "source_url": "example.com/pizza",
            "youtube_url": "youtube.com/pizza"
        }
        """

        let jsonData = Data(jsonString.utf8)
        let recipeDTO = try JSONDecoder().decode(RecipeDTO.self, from: jsonData)

        #expect(recipeDTO.cuisine == "Italian")
        #expect(recipeDTO.name == "Pizza Margherita")
        #expect(recipeDTO.photoURLLarge == "large.jpg")
        #expect(recipeDTO.photoURLSmall == "small.jpg")
        #expect(recipeDTO.uuid == "123e4567-e89b-12d3-a456-426614174000")
        #expect(recipeDTO.sourceUrl == "example.com/pizza")
        #expect(recipeDTO.youtubeUrl == "youtube.com/pizza")
    }

    @Test func testRecipeDTODecodingWithMissingOptionalFields() throws {
        let jsonString = """
        {
            "cuisine": "Italian",
            "name": "Pizza Margherita",
            "uuid": "123e4567-e89b-12d3-a456-426614174000"
        }
        """

        let jsonData = Data(jsonString.utf8)
        let recipeDTO = try JSONDecoder().decode(RecipeDTO.self, from: jsonData)

        #expect(recipeDTO.cuisine == "Italian")
        #expect(recipeDTO.name == "Pizza Margherita")
        #expect(recipeDTO.photoURLLarge == nil)
        #expect(recipeDTO.photoURLSmall == nil)
        #expect(recipeDTO.sourceUrl == nil)
        #expect(recipeDTO.youtubeUrl == nil)
    }

    @Test func testToDomainConversion() throws {
        let dto = RecipeDTO(
            cuisine: "Italian",
            name: "Pizza Margherita",
            photoURLLarge: "large.jpg",
            photoURLSmall: "small.jpg",
            uuid: "123e4567-e89b-12d3-a456-426614174000",
            sourceUrl: "example.com/pizza",
            youtubeUrl: "youtube.com/pizza"
        )

        let domainModel = dto.toDomain()

        #expect(domainModel.cuisineType == "Italian")
        #expect(domainModel.recipeName == "Pizza Margherita")
        #expect(domainModel.photoURLLarge == "large.jpg")
        #expect(domainModel.photoURLSmall == "small.jpg")
        #expect(domainModel.sourceURL == "example.com/pizza")
        #expect(domainModel.id.uuidString.lowercased() == "123e4567-e89b-12d3-a456-426614174000")
        #expect(domainModel.youTubeURL == "youtube.com/pizza")
        #expect(domainModel.recipeImageSmall == nil)
        #expect(domainModel.recipeImageLarge == nil)
    }

    @Test func testToDomainConversionWithNilOptionals() throws {
        let dto = RecipeDTO(
            cuisine: "Greek",
            name: "Moussaka",
            photoURLLarge: nil,
            photoURLSmall: nil,
            uuid: "123e4567-e89b-12d3-a456-426614174000",
            sourceUrl: nil,
            youtubeUrl: nil
        )

        let domainModel = dto.toDomain()

        #expect(domainModel.photoURLLarge.isEmpty)
        #expect(domainModel.photoURLSmall.isEmpty)
        #expect(domainModel.sourceURL.isEmpty)
        #expect(domainModel.youTubeURL.isEmpty)
    }

    @Test func testToDomainConversionWithInvalidUUID() throws {
        let dto = RecipeDTO(
            cuisine: "Greek",
            name: "Moussaka",
            photoURLLarge: nil,
            photoURLSmall: nil,
            uuid: "not-a-valid-uuid",
            sourceUrl: nil,
            youtubeUrl: nil
        )

        let domainModel = dto.toDomain()

        // Should still produce a valid (random) UUID rather than crashing
        #expect(domainModel.id.uuidString.isEmpty == false)
    }

}
