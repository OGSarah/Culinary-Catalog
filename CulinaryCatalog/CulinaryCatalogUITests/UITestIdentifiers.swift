//
//  UITestIdentifiers.swift
//  CulinaryCatalogUITests
//
//  Created by Sarah Clark on 6/6/26.
//

/// Mirror of `AccessibilityIdentifiers` from the app target.
///
/// Duplicated here because UI test targets cannot use `@testable import` against the app target.
/// Keep these values in sync with `CulinaryCatalog/Utilities/AccessibilityIdentifiers.swift`.
enum UITestIdentifiers {

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
