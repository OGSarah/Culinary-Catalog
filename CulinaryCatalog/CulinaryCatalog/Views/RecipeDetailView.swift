//
//  RecipeDetailView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import SwiftUI

/// A view displaying detailed information about a specific recipe.
///
/// This SwiftUI view presents an in-depth look at a recipe, including:
/// - A large header image of the dish
/// - The recipe's name and cuisine type
/// - A link to the original recipe source
/// - An optional embedded YouTube video demonstrating the recipe
///
/// The view is designed to be visually appealing with a scrollable content area, adapting to both light and dark modes for better user experience across different devices.
struct RecipeDetailView: View {
    /// The view model managing the state and logic for this recipe detail view.
    ///
    /// This `@ObservedObject` ensures that the view updates automatically when the view model's published properties change.
    @ObservedObject private var viewModel: RecipeDetailViewModel

    /// Initializes the `RecipeDetailView` with a given recipe.
    ///
    /// - Parameter viewModel: The `RecipeDetailViewModel` which holds all the necessary data and logic for displaying the recipe details.
    init(viewModel: RecipeDetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Main View
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                recipeHeaderSection

                LazyVStack(spacing: 16) {
                    recipeDetailsCard
                    sourceURLSection
                    youtubeVideoSection
                }
                .padding()
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Private Variables for View
    /// The header section of the recipe view, displaying the recipe's main image.
    ///
    /// Uses `AsyncImage` for efficient loading of the large recipe image, showing a progress view as a placeholder while loading.
    private var recipeHeaderSection: some View {
        AsyncImage(url: URL(string: viewModel.recipeDetails.photoLarge)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: UIScreen.main.bounds.height * 0.3)
                .clipped()
        } placeholder: {
            ProgressView()
                .frame(height: UIScreen.main.bounds.height * 0.3)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
        }
    }

    /// Displays detailed information about the recipe including name and cuisine type.
    ///
    /// This card-like view provides a summary of the recipe, with the name in bold and a country flag emoji representing the cuisine.
    private var recipeDetailsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.recipeDetails.recipeName)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                Text(viewModel.getCountryFlag(for: viewModel.recipeDetails.cuisineType))
                    .font(.largeTitle)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? .darkGray
            : .white
        }))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    /// A section showing a link to the original recipe if available.
    ///
    /// If the source URL exists, this section presents a button-like link to view the original recipe on the web.
    private var sourceURLSection: some View {
        Group {
            if let url = URL(string: viewModel.recipeDetails.sourceURL) {
                Link(destination: url) {
                    HStack {
                        Image(systemName: "safari")
                        Text("View Original Recipe")
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor { traitCollection in
                        traitCollection.userInterfaceStyle == .dark
                        ? .darkGray
                        : .white
                    }))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
            }
        }
    }

    /// Displays a YouTube video related to the recipe if a video ID is available.
    ///
    /// This section embeds a YouTube video for visual learners, enhancing the user's engagement with the recipe through video demonstration.
    private var youtubeVideoSection: some View {
        Group {
            if let videoID = viewModel.recipeDetails.youtubeVideoID {
                VStack(alignment: .leading) {
                    Text("Watch the Recipe in Action:")
                        .font(.headline)
                        .padding(.bottom, 8)

                    YouTubeVideoView(videoID: videoID)
                        .frame(height: 250)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding()
                .background(Color(UIColor { traitCollection in
                    traitCollection.userInterfaceStyle == .dark
                    ? .darkGray
                    : .white
                }))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
    }

}

// MARK: - Preview
/// Previews for `RecipeDetailView` in different UI modes.
///
/// These previews help in visualizing how the view will look with sample data in both light and dark mode, ensuring a consistent and appealing UI across different settings.
#Preview("Light Mode") {
    let sampleRecipe = RecipeModel(
        cuisineType: "British",
        recipeName: "Apple & Blackberry Crumble",
        photoLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
        photoSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
        sourceURL: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
        id: UUID(),
        youTubeURL: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
    )

    RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: sampleRecipe))
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let sampleRecipe = RecipeModel(
        cuisineType: "British",
        recipeName: "Apple & Blackberry Crumble",
        photoLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
        photoSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
        sourceURL: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
        id: UUID(),
        youTubeURL: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
    )

    RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: sampleRecipe))
        .preferredColorScheme(.dark)
}
