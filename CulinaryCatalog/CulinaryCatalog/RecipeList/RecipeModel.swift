//
//  RecipeModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData

struct RecipeModel: Identifiable, Codable {
    let cuisineType: String
    let recipeName: String
    let photoLarge: String
    let photoSmall: String
    let sourceURL: String
    let id: UUID
    let youTubeURL: String

    init(cuisineType: String, recipeName: String, photoLarge: String, photoSmall: String, sourceURL: String, id: UUID, youTubeURL: String) {
        self.cuisineType = cuisineType
        self.recipeName = recipeName
        self.photoLarge = photoLarge
        self.photoSmall = photoSmall
        self.sourceURL = sourceURL
        self.id = id
        self.youTubeURL = youTubeURL
    }

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
