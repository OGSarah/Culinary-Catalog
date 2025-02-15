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
    /// Used for displaying a high-quality image of the dish in the RecipeDetailView.
    let photoURLLarge: String

    /// URL for the small-sized photo of the recipe.
    ///
    /// Provides a thumbnail or smaller image, used in the RecipeListView.
    let photoURLSmall: String

    /// Downloaded version of the photoURLSmall.
    ///
    /// Provides a smaller image for the RecipeListView, with the image stored locally.
    /// This property is not part of the JSON data and is stored in Core Data.
    let recipeImageSmall: Data?

    /// Downloaded version of the photoURLLarge.
    ///
    /// Provides a larger image for the RecipeDetailView, with the image stored locally.
    /// This property is not part of the JSON data and is stored in Core Data.
    let recipeImageLarge: Data?

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

    /// Initializes a new RecipeModel with properties from JSON data.
    ///
    /// - Parameters:
    ///   - cuisineType: The type of cuisine
    ///   - recipeName: The name of the recipe
    ///   - photoURLLarge: URL for the large photo
    ///   - photoURLSmall: URL for the small photo
    ///   - sourceURL: URL to the original recipe source
    ///   - id: Unique identifier for the recipe
    ///   - youTubeURL: URL to the recipe's YouTube video
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cuisineType = try container.decode(String.self, forKey: .cuisineType)
        recipeName = try container.decode(String.self, forKey: .recipeName)
        photoURLLarge = try container.decode(String.self, forKey: .photoURLLarge)
        photoURLSmall = try container.decode(String.self, forKey: .photoURLSmall)
        sourceURL = try container.decode(String.self, forKey: .sourceURL)
        id = try container.decode(UUID.self, forKey: .id)
        youTubeURL = try container.decode(String.self, forKey: .youTubeURL)

        // Initialize image data properties as nil since they're not part of JSON
        recipeImageSmall = nil
        recipeImageLarge = nil
    }

    /// Encodes the RecipeModel for JSON serialization.
    ///
    /// - Parameter encoder: The encoder to use for encoding the model.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cuisineType, forKey: .cuisineType)
        try container.encode(recipeName, forKey: .recipeName)
        try container.encode(photoURLLarge, forKey: .photoURLLarge)
        try container.encode(photoURLSmall, forKey: .photoURLSmall)
        try container.encode(sourceURL, forKey: .sourceURL)
        try container.encode(id, forKey: .id)
        try container.encode(youTubeURL, forKey: .youTubeURL)
    }

    /// Initializes a RecipeModel from a CoreData Recipe entity.
    ///
    /// This initializer converts a CoreData entity into a model object, handling potential nil values by providing default empty strings, a new UUID, or nil for missing data.
    ///
    /// - Parameter entity: The CoreData Recipe entity to convert
    init(entity: Recipe) {
        cuisineType = entity.cuisineType ?? ""
        recipeName = entity.recipeName ?? ""
        photoURLLarge = entity.photoURLLarge ?? ""
        photoURLSmall = entity.photoURLSmall ?? ""
        recipeImageSmall = entity.recipeImageSmall
        recipeImageLarge = entity.recipeImageLarge
        sourceURL = entity.sourceURL ?? ""
        id = entity.id ?? UUID()
        youTubeURL = entity.youTubeURL ?? ""
    }

    /// Initializes a new RecipeModel with all required properties.
    ///
    /// - Parameters:
    ///   - cuisineType: The type of cuisine
    ///   - recipeName: The name of the recipe
    ///   - photoURLLarge: URL for the large photo
    ///   - photoURLSmall: URL for the small photo
    ///   - recipeImageSmall: Image data for the small photo
    ///   - recipeImageLarge: Image data for the large photo
    ///   - sourceURL: URL to the original recipe source
    ///   - id: Unique identifier for the recipe
    ///   - youTubeURL: URL to the recipe's YouTube video
    init(cuisineType: String, recipeName: String, photoURLLarge: String, photoURLSmall: String, recipeImageSmall: Data?, recipeImageLarge: Data?, sourceURL: String, id: UUID, youTubeURL: String) {
        self.cuisineType = cuisineType
        self.recipeName = recipeName
        self.photoURLLarge = photoURLLarge
        self.photoURLSmall = photoURLSmall
        self.recipeImageSmall = recipeImageSmall
        self.recipeImageLarge = recipeImageLarge
        self.sourceURL = sourceURL
        self.id = id
        self.youTubeURL = youTubeURL
    }

    // MARK: - Equatable Conformance
    /// Compares two `RecipeModel` instances for equality.
    ///
    /// This method checks if all properties of two `RecipeModel` instances match, which is useful for comparison operations and testing.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `RecipeModel` to compare
    ///   - rhs: The right-hand side `RecipeModel` to compare
    /// - Returns: `true` if all properties are equal, otherwise `false`.
    static func == (lhs: RecipeModel, rhs: RecipeModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.cuisineType == rhs.cuisineType &&
        lhs.recipeName == rhs.recipeName &&
        lhs.photoURLLarge == rhs.photoURLLarge &&
        lhs.photoURLSmall == rhs.photoURLSmall &&
        lhs.recipeImageSmall == rhs.recipeImageSmall &&
        lhs.recipeImageLarge == rhs.recipeImageLarge &&
        lhs.sourceURL == rhs.sourceURL &&
        lhs.youTubeURL == rhs.youTubeURL
    }

    // MARK: - CodingKeys
    /// Defines the coding keys for JSON serialization/deserialization.
    ///
    /// These keys correspond to the properties that are part of the JSON data.
    enum CodingKeys: String, CodingKey {
        case cuisineType
        case recipeName
        case photoURLLarge
        case photoURLSmall
        case sourceURL
        case id
        case youTubeURL
    }

}
