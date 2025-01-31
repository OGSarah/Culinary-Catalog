//
//  RecipeListViewModelProtocol.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import SwiftUI

/// Defines the contract for recipe list view model operations
protocol RecipeListViewModelProtocol: ObservableObject {
    /// The list of recipes to be displayed
    var recipes: [RecipeModel] { get async }

    /// Indicates whether a refresh operation is in progress
    var isRefreshing: Bool { get async }

    /// The current error message, if any
    var errorMessage: String? { get async }

    /// Loads recipes from the repository
    func loadRecipes() async

    /// Refreshes the list of recipes
    func refreshRecipes() async

    /// Filters recipes based on a search text
    /// - Parameter searchText: The text to filter recipes by
    /// - Returns: Filtered list of recipes
    func filteredRecipes(searchText: String) async -> [RecipeModel]
}
