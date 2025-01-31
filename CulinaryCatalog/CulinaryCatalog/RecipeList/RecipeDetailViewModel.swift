//
//  RecipeDetailViewModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/30/25.
//

import SwiftUI

final class RecipeDetailViewModel: ObservableObject {
    let recipe: RecipeModel
    var youtubeVideoID: String?

    init(recipe: RecipeModel) {
        self.recipe = recipe
        self.youtubeVideoID = recipe.youTubeURL.extractYouTubeID()
    }

    func countryFlag(for cuisineType: String) -> String {
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
