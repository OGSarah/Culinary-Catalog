//
//  RecipeListViewModelProtocol.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import SwiftUI

/// Defines the contract for the recipe list view model operations.
///
/// This protocol outlines the requirements for any view model that manages
/// a list of recipes, including loading, refreshing, and filtering operations.
protocol RecipeListViewModelProtocol: ObservableObject {
    /// The list of recipes currently available for display.
    ///
    /// This property is asynchronous to allow for loading recipes from a remote or local source.
    var recipes: [RecipeModel] { get async }

    /// Indicates whether a refresh operation is currently in progress.
    ///
    /// Useful for UI elements to show loading states or disable interactions during refresh.
    var isRefreshing: Bool { get async }

    /// The current error message, if any, after attempting to load or refresh recipes.
    ///
    /// This can be used to display error information to the user or log errors.
    var errorMessage: String? { get async }

    func getRecipesFromNetwork() async throws

    /// Loads sorted recipes from CoreData.
    ///
    /// This method should be called when initially loading the view or when
    /// the user explicitly requests to load recipes.
    /// - Returns: An alphabetically sorted list of recipes.
    /// - Throws: An error if the loading process fails.
    func loadSortedRecipesFromCoreData() async throws -> [RecipeModel]

    /// Refreshes the current list of recipes by making a network call to update the Recipe Model.
    ///
    /// This method is triggered by the Refresh button on the Recipe List screen.
    /// - Throws: An error if the refresh operation fails.
    func refreshRecipes() async throws

    /// Filters the list of recipes based on the provided search text.
    ///
    /// This method allows for dynamic filtering of recipes based on user input,
    /// typically used for search functionality within the recipe list.
    /// - Parameter searchText: The text to filter recipes by. This can match against recipe names, ingredients, or any other relevant attribute.
    /// - Returns: A filtered list of `RecipeModel` objects matching the search criteria.
    /// - Throws: An error if filtering fails, for example, due to data corruption or network issues when fetching additional data for filtering.
    func filteredRecipes(searchText: String) -> [RecipeModel]
}
