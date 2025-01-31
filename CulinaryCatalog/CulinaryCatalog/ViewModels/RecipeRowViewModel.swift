//
//  RecipeRowViewModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation

final class RecipeRowViewModel: ObservableObject, RecipeRowViewModelProtocol {
    internal let recipe: RecipeRowModel

    init(recipe: RecipeModel) {
        self.recipe = RecipeRowModel(
            id: recipe.id,
            cuisineType: recipe.cuisineType,
            recipeName: recipe.recipeName,
            photoSmallURL: recipe.photoSmall
        )
    }

    func getFormattedCuisineType() -> String {
        return recipe.cuisineType.capitalized
    }

    func getFormattedRecipeName() -> String {
        return recipe.recipeName
    }

    func getPhotoURL() -> URL? {
        return URL(string: recipe.photoSmallURL)
    }
}
