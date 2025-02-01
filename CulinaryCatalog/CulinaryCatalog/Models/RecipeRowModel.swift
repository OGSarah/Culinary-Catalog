//
//  RecipeRowModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation

/// A model representing a single row in a list of recipes, used for UI display purposes.
struct RecipeRowModel: Identifiable {
    /// The unique identifier for the recipe.
    let id: UUID

    /// The type of cuisine the recipe belongs to.
    let cuisineType: String

    /// The name of the recipe.
    let recipeName: String

    /// URL string for a small-sized photo of the recipe.
    let photoSmallURL: String
}
