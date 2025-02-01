//
//  RecipeDetailState.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

/// Represents the detailed state of a recipe for display in the user interface.
///
/// This struct encapsulates all the necessary information about a recipe
/// that will be presented in the detail view.
///
/// - Note: Designed to be immutable for thread safety and predictable state management.
struct RecipeDetailState {
    /// The name of the recipe.
    ///
    /// Displays the full, descriptive name of the recipe in the user interface.
    ///
    /// - Example: "Blackberry Fool"
    let recipeName: String

    /// The type of cuisine the recipe belongs to.
    ///
    /// Represents the cultural or regional origin of the recipe.
    ///
    /// - Example: "Italian", "Russian", "British"
    let cuisineType: String

    /// The URL of the large-sized photo representing the recipe.
    ///
    /// Used for displaying a high-resolution image of the finished dish.
    ///
    /// - Note: Should be a valid, accessible image URL.
    let photoLarge: String

    /// The original source URL of the recipe.
    ///
    /// Provides a link to the website where the recipe was originally published.
    ///
    /// - Note: Can be used to give credit to the original recipe creator.
    let sourceURL: String

    /// The YouTube video ID associated with the recipe, if available.
    ///
    /// Allows embedding or linking to a video demonstration of the recipe.
    ///
    /// - Returns: A string containing the YouTube video ID, or `nil` if no video is available.
    /// - Example: "dQw4w9WgXcQ"
    let youtubeVideoID: String?

}
