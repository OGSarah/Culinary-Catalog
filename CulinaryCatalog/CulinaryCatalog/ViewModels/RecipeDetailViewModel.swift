//
//  RecipeDetailViewModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/30/25.
//

import SwiftUI

/// Manages the data and presentation logic for the Recipe Detail view.
///
/// This view model handles recipe-specific operations, including transforming recipe data
/// and providing country flags for different cuisine types.
///
/// - Note: Conforms to `ObservableObject` for reactive UI updates and `CountryFlagProtocol` for flag retrieval.
final class RecipeDetailViewModel: ObservableObject, CountryFlagProtocol {

    /// The original recipe model used as the source of truth.
    ///
    /// This private property ensures that the view model has direct access to the source data
    /// while preventing external modification.
    private let recipe: RecipeModel

    /// A published state representing the current recipe details.
    ///
    /// This property is marked as `@Published` to trigger UI updates when its value changes.
    /// It is privately settable to maintain encapsulation.
    ///
    /// - SeeAlso: `RecipeDetailState`
    @Published private(set) var recipeDetails: RecipeDetailState

    /// Initializes a new RecipeDetailViewModel with a given recipe.
    ///
    /// Transforms the input recipe into a `RecipeDetailState` for view presentation.
    ///
    /// - Parameters:
    ///   - recipe: The source recipe model to be displayed and processed.
    /// - SeeAlso: `RecipeModel`
    /// - SeeAlso: `RecipeDetailState`
    init(recipe: RecipeModel) {
        self.recipe = recipe
        self.recipeDetails = RecipeDetailState(
            recipeName: recipe.recipeName,
            cuisineType: recipe.cuisineType,
            photoLarge: recipe.photoURLLarge,
            sourceURL: recipe.sourceURL,
            youtubeVideoID: recipe.youTubeURL.extractYouTubeID()
        )
    }

    /// Retrieves the country flag emoji for a given cuisine type.
    ///
    /// Provides a standardized way to display country flags based on cuisine origin.
    ///
    /// - Parameter cuisineType: The type of cuisine to find a flag for.
    /// - Returns: A country flag emoji representing the cuisine type.
    ///
    /// - Note: Returns a globe emoji (🌍) for unrecognized cuisine types.
    /// - Complexity: O(1) - Constant time complexity due to switch statement.
    func getCountryFlag(for cuisineType: String) -> String {
        switch cuisineType.lowercased() {
        case "american": return "🇺🇸"
        case "british": return "🇬🇧"
        case "malaysian": return "🇲🇾"
        case "canadian": return "🇨🇦"
        case "italian": return "🇮🇹"
        case "french": return "🇫🇷"
        case "tunisian": return "🇹🇳"
        case "greek": return "🇬🇷"
        case "polish": return "🇵🇱"
        case "portuguese": return "🇵🇹"
        case "russian": return "🇷🇺"
        case "croatian": return "🇭🇷"
        default: return "🌍"
        }
    }

}
