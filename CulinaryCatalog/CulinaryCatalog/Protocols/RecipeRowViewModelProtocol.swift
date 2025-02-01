//
//  RecipeRowViewModelProtocol.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import SwiftUI

/// Defines the interface for view models used to manage and display data for a single recipe row in a list or table view.
protocol RecipeRowViewModelProtocol: ObservableObject {
    /// The model containing the data for a recipe row, used for UI rendering.
    var recipe: RecipeRowModel { get }

    /// Returns a formatted version of the cuisine type for display purposes.
    ///
    /// - Returns: A string that might include capitalizations.
    func getFormattedCuisineType() -> String

    /// Provides the recipe name in a format suitable for display in the UI.
    ///
    /// - Returns: The name of the recipe.
    func getFormattedRecipeName() -> String

    /// Converts the photo URL string into a `URL` for use in image loading operations.
    ///
    /// - Returns: An optional `URL` for the small photo of the recipe, which could be `nil` if the URL string is not valid.
    func getPhotoURL() -> URL?
}
