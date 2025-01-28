//
//  RecipeModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData

struct RecipeModel: Identifiable {
    let cuisineType: String
    let id: UUID
    let photoLarge: String
    let photoSmall: String
    let recipeName: String
    let sourceURL: String

    init(cuisineType: String, id: UUID, photoLarge: String, photoSmall: String, recipeName: String, sourceURL: String) {
        self.cuisineType = cuisineType
        self.id = id
        self.photoLarge = photoLarge
        self.photoSmall = photoSmall
        self.recipeName = recipeName
        self.sourceURL = sourceURL
    }

    init(entity: Recipe) {
        self.cuisineType = entity.cuisineType ?? ""
        self.id = entity.id ?? UUID()
        self.photoLarge = entity.photoLarge ?? ""
        self.photoSmall = entity.photoSmall ?? ""
        self.recipeName = entity.recipeName ?? ""
        self.sourceURL = entity.sourceURL ?? ""
    }

}
