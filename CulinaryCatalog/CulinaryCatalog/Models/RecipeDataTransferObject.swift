//
//  RecipeDataTransferObject.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/29/25.
//

import Foundation

/// Represents the response containing a list of recipes from an API.
///
/// This structure is designed to decode JSON responses from an API endpoint that lists recipes.
/// It includes an array of `RecipeDTO` objects which can be further processed or converted into domain models.
struct RecipesResponse: Codable {
    /// An array of `RecipeDTO` objects representing the recipes.
    ///
    /// Each `RecipeDTO` within this array corresponds to a single recipe entry from the API response.
    let recipes: [RecipeDTO]
}

/// A data transfer object (DTO) for a recipe, used for decoding from JSON.
///
/// This DTO matches the JSON structure expected from the API for individual recipes. It includes properties for various attributes of a recipe and methods to convert it to a domain model.
struct RecipeDTO: Codable {
    /// The type of cuisine for the recipe.
    ///
    /// This string describes the culinary style or origin of the recipe, e.g., "Italian", "French".
    let cuisine: String

    /// The name of the recipe.
    ///
    /// This is the title or name by which the recipe is commonly known.
    let name: String

    /// URL for the large photo of the recipe, if available.
    ///
    /// This optional property provides a link to a high-resolution image of the dish.
    let photoURLLarge: String?

    /// URL for the small photo of the recipe, if available.
    ///
    /// This optional property provides a link to a thumbnail or smaller image of the dish.
    let photoURLSmall: String?

    /// A universally unique identifier for the recipe.
    ///
    /// This UUID uniquely identifies the recipe across systems or databases.
    let uuid: String

    /// The source URL of the recipe, if available.
    ///
    /// This optional property points to the original source or website where the recipe was published.
    let sourceUrl: String?

    /// The YouTube URL for the recipe video, if available.
    ///
    /// This optional property provides a link to a YouTube video demonstrating the recipe preparation.
    let youtubeUrl: String?

    /// Custom coding keys to match the JSON structure.
    ///
    /// These keys ensure that the JSON keys from the API match with the Swift property names, handling cases where the JSON uses snake_case.
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case uuid
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }

    /// Converts the DTO to a domain model `RecipeModel`.
    ///
    /// This method transforms the DTO into a domain-specific model that might be used within the application's business logic. It handles default values for optional fields and converts the UUID string to a `UUID` object.
    ///
    /// - Returns: A `RecipeModel` instance populated with data from this DTO.
    func toDomain() -> RecipeModel {
        RecipeModel(
            cuisineType: cuisine,
            recipeName: name,
            photoURLLarge: photoURLLarge ?? "",
            photoURLSmall: photoURLSmall ?? "",
            recipeImageSmall: nil,
            recipeImageLarge: nil,
            sourceURL: sourceUrl ?? "",
            id: UUID(uuidString: uuid.lowercased()) ?? UUID(),
            youTubeURL: youtubeUrl ?? ""
        )
    }

}
