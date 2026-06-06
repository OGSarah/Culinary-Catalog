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
    /// Holds a reference to an `@Observable` view model so SwiftUI automatically tracks reads and re-renders when the model changes.
    private let viewModel: RecipeDetailViewModel

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
        .accessibilityIdentifier(AccessibilityIdentifiers.RecipeDetail.scrollView)
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
    }

// MARK: - Private Variables for View
/// The header section of the recipe view, displaying the recipe's main image.
///
/// This section uses a conditional `ZStack` to display either the large recipe image, if available, or a progress view as a placeholder. The image data is stored in `viewModel.recipeDetails.photoLarge` and converted to a `UIImage` for display. If the image data is not available, a `ProgressView` is shown instead. The entire section is framed to occupy 30% of the screen height and has a light gray background.
    private var recipeHeaderSection: some View {
        ZStack {
            if let uiImage = UIImage(data: viewModel.recipeDetails.photoLarge) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .containerRelativeFrame(.vertical) { height, _ in
                        height * 0.3
                    }
                    .clipped()
                    .accessibilityLabel("Photo of \(viewModel.recipeDetails.recipeName)")
            } else {
                ProgressView()
                    .containerRelativeFrame(.vertical) { height, _ in
                        height * 0.3
                    }
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Loading recipe photo")
            }
        }
        .containerRelativeFrame(.vertical) { height, _ in
            height * 0.3
        }
        .background(Color.gray.opacity(0.1))
        .accessibilityIdentifier(AccessibilityIdentifiers.RecipeDetail.headerImage)
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
                        .accessibilityIdentifier(AccessibilityIdentifiers.RecipeDetail.nameLabel)
                        .accessibilityAddTraits(.isHeader)
                }
                Spacer()
                Text(viewModel.getCountryFlag(for: viewModel.recipeDetails.cuisineType))
                    .font(.largeTitle)
                    .accessibilityIdentifier(AccessibilityIdentifiers.RecipeDetail.cuisineFlag)
                    .accessibilityLabel("\(viewModel.recipeDetails.cuisineType) cuisine")
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
            if let url = URL(string: viewModel.recipeDetails.sourceURL), !viewModel.recipeDetails.sourceURL.isEmpty {
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
                .accessibilityIdentifier(AccessibilityIdentifiers.RecipeDetail.sourceLink)
                .accessibilityLabel("View original recipe")
                .accessibilityHint("Opens the source web page in your browser")
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
                        .accessibilityAddTraits(.isHeader)

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
                .accessibilityIdentifier(AccessibilityIdentifiers.RecipeDetail.videoSection)
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
        photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
        photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
        recipeImageSmall: Data(),
        recipeImageLarge: Data(),
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
        photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
        photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
        recipeImageSmall: Data(),
        recipeImageLarge: Data(),
        sourceURL: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
        id: UUID(),
        youTubeURL: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
    )

    RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: sampleRecipe))
        .preferredColorScheme(.dark)
}
