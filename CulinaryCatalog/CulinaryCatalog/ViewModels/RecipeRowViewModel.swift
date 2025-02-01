//
//  RecipeRowViewModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation

/// A concrete implementation of `RecipeRowViewModelProtocol` for handling recipe row data.
final class RecipeRowViewModel: ObservableObject, RecipeRowViewModelProtocol {
    /// The `RecipeRowModel` instance containing the data for the recipe row.
    internal let recipe: RecipeRowModel

    /// Initializes the view model with a `RecipeModel`.
    ///
    /// - Parameter recipe: The `RecipeModel` to convert into a `RecipeRowModel` for UI representation.
    init(recipe: RecipeModel) {
        self.recipe = RecipeRowModel(
            id: recipe.id,
            cuisineType: recipe.cuisineType,
            recipeName: recipe.recipeName,
            photoSmallURL: recipe.photoSmall
        )
    }

    /// Formats the cuisine type by capitalizing the first letter for display.
    ///
    /// - Returns: A string where the cuisine type's first character is capitalized.
    func getFormattedCuisineType() -> String {
        return recipe.cuisineType.capitalized
    }

    /// Returns the recipe name as is, without additional formatting.
    ///
    /// - Returns: The original recipe name from the model.
    func getFormattedRecipeName() -> String {
        return recipe.recipeName
    }

    /// Attempts to create a `URL` from the small photo URL string.
    ///
    /// - Returns: An optional `URL` for the small photo, or `nil` if the URL string is invalid.
    func getPhotoURL() -> URL? {
        return URL(string: recipe.photoSmallURL)
    }

}
