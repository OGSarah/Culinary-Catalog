//
//  RecipeDataTransferObject.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/29/25.
//

import Foundation

/// Represents the response containing a list of recipes from an API.
struct RecipesResponse: Codable {
    /// An array of `RecipeDTO` objects representing the recipes.
    let recipes: [RecipeDTO]
}

/// A data transfer object (DTO) for a recipe, used for decoding from JSON.
struct RecipeDTO: Codable {
    /// The type of cuisine for the recipe.
    let cuisine: String

    /// The name of the recipe.
    let name: String

    /// URL for the large photo of the recipe, if available.
    let photoUrlLarge: String?

    /// URL for the small photo of the recipe, if available.
    let photoUrlSmall: String?

    /// A universally unique identifier for the recipe.
    let uuid: String

    /// The source URL of the recipe, if available.
    let sourceUrl: String?

    /// The YouTube URL for the recipe video, if available.
    let youtubeUrl: String?

    /// Custom coding keys to match the JSON structure.
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case uuid
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }

    /// Converts the DTO to a domain model `RecipeModel`.
    ///
    /// - Returns: A `RecipeModel` instance populated with data from this DTO.
    func toDomain() -> RecipeModel {
        RecipeModel(
            cuisineType: cuisine,
            recipeName: name,
            photoLarge: photoUrlLarge ?? "",
            photoSmall: photoUrlSmall ?? "",
            sourceURL: sourceUrl ?? "",
            id: UUID(uuidString: uuid.lowercased()) ?? UUID(),
            youTubeURL: youtubeUrl ?? ""
        )
    }

}
