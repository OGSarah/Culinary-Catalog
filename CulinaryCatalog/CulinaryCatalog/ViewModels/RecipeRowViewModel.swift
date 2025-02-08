//
//  RecipeRowViewModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation

/// A concrete implementation of `RecipeRowViewModelProtocol` for handling recipe row data in a list view.
///
/// This class is designed to manage the data and presentation logic for individual rows in a recipe list, transforming complex `RecipeModel` data into a more UI-friendly `RecipeRowModel`. It conforms to `ObservableObject` to support reactive UI updates in SwiftUI.
final class RecipeRowViewModel: ObservableObject, RecipeRowViewModelProtocol {
    /// The `RecipeRowModel` instance containing the simplified data for the recipe row.
    ///
    /// This property holds all necessary information for displaying a single recipe row, including ID, cuisine type, name, and photo URL.
    internal let recipe: RecipeRowModel

    /// Initializes the view model with a `RecipeModel`.
    ///
    /// This initializer converts the detailed `RecipeModel` into a `RecipeRowModel`, which contains only the data needed for list representation, thus optimizing for performance in list views.
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
    /// This method ensures that the cuisine type is presented in a consistent, readable format regardless of how it was originally entered or stored.
    ///
    /// - Returns: A string where the cuisine type's first character is capitalized.
    func getFormattedCuisineType() -> String {
        return recipe.cuisineType.capitalized
    }

    /// Returns the recipe name as is, without additional formatting.
    ///
    /// Since the recipe name is already expected to be in a display-friendly format, this method simply passes it through without modification.
    ///
    /// - Returns: The original recipe name from the model.
    func getFormattedRecipeName() -> String {
        return recipe.recipeName
    }

    /// Attempts to create a `URL` from the small photo URL string.
    ///
    /// This method is crucial for UI elements that need to load images from a URL. It handles the possibility that the URL string might be invalid or improperly formatted.
    ///
    /// - Returns: An optional `URL` for the small photo, or `nil` if the URL string is invalid or cannot be constructed into a URL.
    func getPhotoURL() -> URL? {
        return URL(string: recipe.photoSmallURL)
    }

}
