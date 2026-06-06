//
//  AccessibilityIdentifiers.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 6/6/26.
//

/// Centralized accessibility identifiers used by views and UI tests.
///
/// Sharing a single source of truth between production code and UI tests prevents the common
/// "tests drift from UI" failure mode where renaming an identifier silently breaks UI tests.
enum AccessibilityIdentifiers {

    enum ContentView {
        static let navigationTitle = "content.navigationTitle"
        static let refreshButton = "content.refreshButton"
        static let emptyState = "content.emptyState"
    }

    enum RecipeList {
        static let list = "recipeList.list"
        static let searchField = "recipeList.searchField"
        static let errorAlert = "recipeList.errorAlert"
        static let loadingOverlay = "recipeList.loadingOverlay"

        /// Builds a unique identifier for an individual recipe row, allowing UI tests
        /// to target a specific recipe by name.
        static func row(for recipeName: String) -> String {
            "recipeList.row.\(recipeName)"
        }
    }

    enum RecipeRow {
        static let photo = "recipeRow.photo"
        static let cuisineLabel = "recipeRow.cuisine"
        static let nameLabel = "recipeRow.name"
    }

    enum RecipeDetail {
        static let scrollView = "recipeDetail.scrollView"
        static let headerImage = "recipeDetail.headerImage"
        static let nameLabel = "recipeDetail.name"
        static let cuisineFlag = "recipeDetail.cuisineFlag"
        static let sourceLink = "recipeDetail.sourceLink"
        static let videoSection = "recipeDetail.videoSection"
    }

    enum YouTubeVideo {
        static let webView = "youtubeVideo.webView"
    }

}
