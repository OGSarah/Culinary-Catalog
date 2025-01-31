//
//  RecipeRowViewModelProtocol.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import SwiftUI

protocol RecipeRowViewModelProtocol: ObservableObject {
    var recipe: RecipeRowModel { get }

    func getFormattedCuisineType() -> String
    func getFormattedRecipeName() -> String
    func getPhotoURL() -> URL?
}
