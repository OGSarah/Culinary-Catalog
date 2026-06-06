//
//  RecipeRowViewModelTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 6/6/26.
//

import Foundation
import Testing
@testable import CulinaryCatalog

@MainActor
struct RecipeRowViewModelTests {

    private func makeRecipe(
        cuisineType: String = "italian",
        recipeName: String = "Pizza Margherita",
        photoURLSmall: String = "https://example.com/small.jpg"
    ) -> RecipeModel {
        RecipeModel(
            cuisineType: cuisineType,
            recipeName: recipeName,
            photoURLLarge: "https://example.com/large.jpg",
            photoURLSmall: photoURLSmall,
            recipeImageSmall: nil,
            recipeImageLarge: nil,
            sourceURL: "https://example.com/source",
            id: UUID(),
            youTubeURL: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        )
    }

    @Test func testGetFormattedCuisineTypeCapitalizesFirstLetter() {
        let viewModel = RecipeRowViewModel(recipe: makeRecipe(cuisineType: "italian"))

        #expect(viewModel.getFormattedCuisineType() == "Italian")
    }

    @Test func testGetFormattedCuisineTypeHandlesAlreadyCapitalized() {
        let viewModel = RecipeRowViewModel(recipe: makeRecipe(cuisineType: "British"))

        #expect(viewModel.getFormattedCuisineType() == "British")
    }

    @Test func testGetFormattedRecipeNameReturnsOriginal() {
        let viewModel = RecipeRowViewModel(recipe: makeRecipe(recipeName: "Apple & Blackberry Crumble"))

        #expect(viewModel.getFormattedRecipeName() == "Apple & Blackberry Crumble")
    }

    @Test func testGetPhotoURLReturnsValidURL() {
        let viewModel = RecipeRowViewModel(
            recipe: makeRecipe(photoURLSmall: "https://example.com/small.jpg")
        )

        #expect(viewModel.getPhotoURL() == URL(string: "https://example.com/small.jpg"))
    }

    @Test func testGetPhotoURLReturnsNilForEmptyString() {
        let viewModel = RecipeRowViewModel(recipe: makeRecipe(photoURLSmall: ""))

        #expect(viewModel.getPhotoURL() == nil)
    }

    @Test func testRecipeRowModelIsBuiltFromRecipeModel() {
        let id = UUID()
        let recipe = RecipeModel(
            cuisineType: "Italian",
            recipeName: "Pizza",
            photoURLLarge: "large.jpg",
            photoURLSmall: "small.jpg",
            recipeImageSmall: nil,
            recipeImageLarge: nil,
            sourceURL: "source.com",
            id: id,
            youTubeURL: "youtube.com"
        )

        let viewModel = RecipeRowViewModel(recipe: recipe)

        #expect(viewModel.recipe.id == id)
        #expect(viewModel.recipe.cuisineType == "Italian")
        #expect(viewModel.recipe.recipeName == "Pizza")
        #expect(viewModel.recipe.photoSmallURL == "small.jpg")
    }

}
