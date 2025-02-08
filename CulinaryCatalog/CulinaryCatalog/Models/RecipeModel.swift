//
//  RecipeModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//
import CoreData

/// Represents a recipe with detailed information.
///
/// This model conforms to `Identifiable` for use with SwiftUI, `Codable` for JSON serialization/deserialization, and `Equatable` for comparison operations, making it versatile for various uses within an application.
struct RecipeModel: Identifiable, Codable, Equatable {
    /// The type of cuisine for the recipe.
    ///
    /// Describes the culinary tradition or origin of the recipe, aiding in categorization or filtering.
    let cuisineType: String

    /// The name of the recipe.
    ///
    /// A descriptive name that identifies the recipe to the user.
    let recipeName: String

    /// URL for the large-sized photo of the recipe.
    ///
    /// Used for displaying a high-quality image of the dish, enhancing the recipe's visual appeal.
    let photoLarge: String

    /// URL for the small-sized photo of the recipe.
    ///
    /// Provides a thumbnail or smaller image, useful for list views or when bandwidth is a concern.
    let photoSmall: String

    /// URL to the original source of the recipe.
    ///
    /// Links back to where the recipe was sourced, offering additional context or credit to the original author.
    let sourceURL: String

    /// Unique identifier for the recipe.
    ///
    /// Allows for unique identification of each recipe instance, crucial for operations like updates or deletions.
    let id: UUID

    /// URL to the YouTube video demonstrating the recipe.
    ///
    /// Provides a video link for users to see the recipe preparation, enhancing user engagement.
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
    /// This initializer converts a CoreData entity into a model object, handling potential nil values by providing default empty strings or a new UUID for missing data.
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

    // MARK: - Equatable Conformance for Unit testing
    /// Compares two `RecipeModel` instances for equality.
    ///
    /// This method checks if all properties of two `RecipeModel` instances match, which is crucial for testing or when managing collections of recipes.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `RecipeModel` to compare
    ///   - rhs: The right-hand side `RecipeModel` to compare
    /// - Returns: `true` if all properties are equal, otherwise `false`.
    static func == (lhs: RecipeModel, rhs: RecipeModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.cuisineType == rhs.cuisineType &&
        lhs.recipeName == rhs.recipeName &&
        lhs.photoLarge == rhs.photoLarge &&
        lhs.photoSmall == rhs.photoSmall &&
        lhs.sourceURL == rhs.sourceURL &&
        lhs.youTubeURL == rhs.youTubeURL
    }

}
