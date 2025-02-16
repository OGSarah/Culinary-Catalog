//
//  RecipeDetailState.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/31/25.
//

import Foundation
/// Represents the detailed state of a recipe for display in the user interface.
///
/// This struct encapsulates all the necessary information about a recipe that will be presented in the detail view. It's designed to hold immutable data, which aids in thread safety and predictable state management within UI frameworks like SwiftUI or UIKit.
///
/// - Note: Designed to be immutable for thread safety and predictable state management.
struct RecipeDetailState {
    /// The name of the recipe.
    ///
    /// Displays the full, descriptive name of the recipe in the user interface. This name should be unique or at least clearly descriptive to differentiate it from other recipes.
    ///
    /// - Example: "Blackberry Fool"
    let recipeName: String

    /// The type of cuisine the recipe belongs to.
    ///
    /// Represents the cultural or regional origin of the recipe, helping users to navigate or filter recipes by cuisine preference.
    ///
    /// - Example: "Italian", "Russian", "British"
    let cuisineType: String

    /// Data for the large photo of the recipe.
    ///
    /// This property contains the binary data for a high-resolution image of the finished dish. It's used to enhance the visual appeal and user engagement by displaying detailed images in the recipe view.
    ///
    /// - Note: This data should be derived from a valid, accessible image URL and stored locally for quick access.
    let photoLarge: Data

    /// The original source URL of the recipe.
    ///
    /// Provides a link to the website where the recipe was originally published or sourced from, allowing users to access further details or give credit to the original creator.
    ///
    /// - Note: Can be used to give credit to the original recipe creator.
    let sourceURL: String

    /// The YouTube video ID associated with the recipe, if available.
    ///
    /// This property holds the identifier for a YouTube video that demonstrates how to prepare the recipe. If no video is available, this will be `nil`.
    ///
    /// - Returns: A string containing the YouTube video ID, or `nil` if no video is available.
    /// - Example: "dQw4w9WgXcQ"
    let youtubeVideoID: String?
}
