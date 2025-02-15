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

        do {
            let recipesResponse = try decoder.decode(RecipesResponse.self, from: jsonData)
            #expect(recipesResponse.recipes.count == 1)
        } catch {
            throw error
        }
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
        let decoder = JSONDecoder()

        do {
            let recipeDTO = try decoder.decode(RecipeDTO.self, from: jsonData)

            #expect(recipeDTO.cuisine == "Italian")
            #expect(recipeDTO.name == "Pizza Margherita")
            #expect(recipeDTO.photoUrlLarge == "large.jpg")
            #expect(recipeDTO.photoUrlSmall == "small.jpg")
            #expect(recipeDTO.uuid == "123e4567-e89b-12d3-a456-426614174000")
            #expect(recipeDTO.sourceUrl == "example.com/pizza")
            #expect(recipeDTO.youtubeUrl == "youtube.com/pizza")
        } catch {
            throw error
        }
    }

    @Test func testToDomainConversion() throws {
        let dto = RecipeDTO(
            cuisine: "Italian",
            name: "Pizza Margherita",
            photoUrlLarge: "large.jpg",
            photoUrlSmall: "small.jpg",
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
    }

}
