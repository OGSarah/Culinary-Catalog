//
//  RecipeRowModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation

struct RecipeRowModel: Identifiable {
    let id: UUID
    let cuisineType: String
    let recipeName: String
    let photoSmallURL: String
}
