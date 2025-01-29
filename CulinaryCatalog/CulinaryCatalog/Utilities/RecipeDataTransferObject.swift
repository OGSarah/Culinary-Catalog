//
//  RecipeDataTransferObject.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/29/25.
//

import Foundation

struct RecipesResponse: Codable {
    let recipes: [RecipeDTO]
}

struct RecipeDTO: Codable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let uuid: String
    let sourceUrl: String?
    let youtubeUrl: String?

    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case uuid
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }

    func toDomain() -> RecipeModel {
        RecipeModel(
            cuisineType: cuisine,
            recipeName: name,
            photoLarge: photoUrlLarge ?? "",
            photoSmall: photoUrlSmall ?? "",
            sourceURL: sourceUrl ?? "",
            id: UUID(uuidString: uuid) ?? UUID(),
            youTubeURL: youtubeUrl ?? ""
        )
    }

}
