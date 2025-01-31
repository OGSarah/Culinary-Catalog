//
//  RecipeModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData

/// Represents a recipe with detailed information.
///
/// This model conforms to `Identifiable` and `Codable` protocols, allowing easy integration
/// with SwiftUI views and JSON encoding/decoding.
struct RecipeModel: Identifiable, Codable {
    /// The type of cuisine for the recipe.
    let cuisineType: String

    /// The name of the recipe.
    let recipeName: String

    /// URL for the large-sized photo of the recipe.
    let photoLarge: String

    /// URL for the small-sized photo of the recipe.
    let photoSmall: String

    /// URL to the original source of the recipe.
    let sourceURL: String

    /// Unique identifier for the recipe.
    let id: UUID

    /// URL to the YouTube video demonstrating the recipe.
    let youTubeURL: String

    /// Initializes a new RecipeModel with all required properties.
    ///
    /// - Parameters:
    ///   - cuisineType: The type of cuisine
    ///   - recipeName: The name of the recipe
    ///   - photoLarge: URL for the large photo
    ///   - photoSmall: URL for the small photo
    ///   - sourceURL: URL to the original recipe source
    ///   - id: Unique identifier for the recipe
    ///   - youTubeURL: URL to the recipe's YouTube video
    init(cuisineType: String, recipeName: String, photoLarge: String, photoSmall: String, sourceURL: String, id: UUID, youTubeURL: String) {
        self.cuisineType = cuisineType
        self.recipeName = recipeName
        self.photoLarge = photoLarge
        self.photoSmall = photoSmall
        self.sourceURL = sourceURL
        self.id = id
        self.youTubeURL = youTubeURL
    }

    /// Initializes a RecipeModel from a CoreData Recipe entity.
    ///
    /// Handles potential nil values from CoreData by providing default empty strings or a new UUID.
    ///
    /// - Parameter entity: The CoreData Recipe entity to convert
    init(entity: Recipe) {
        self.cuisineType = entity.cuisineType ?? ""
        self.recipeName = entity.recipeName ?? ""
        self.photoLarge = entity.photoLarge ?? ""
        self.photoSmall = entity.photoSmall ?? ""
        self.sourceURL = entity.sourceURL ?? ""
        self.id = entity.id ?? UUID()
        self.youTubeURL = entity.youTubeURL ?? ""
    }

}
