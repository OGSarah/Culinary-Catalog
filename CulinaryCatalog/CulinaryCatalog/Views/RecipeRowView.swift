//
//  RecipeRowView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import SwiftUI

/// A view representing a single recipe row in a list.
///
/// This view is designed to display a concise summary of a recipe in a horizontal format, showing:
/// - A photo of the dish
/// - The cuisine type
/// - The recipe's name
///
/// It's optimized for use within lists or collections where space is limited but visual representation is key.
struct RecipeRowView: View {
    /// The view model for the recipe row, managing the data and logic for this view.
    ///
    /// Using `@StateObject` ensures that the view model's lifecycle is tied to this view's lifetime, automatically updating the UI when the model changes.
    @StateObject private var viewModel: RecipeRowViewModel

    /// Initializes a new `RecipeRowView` with the provided recipe.
    ///
    /// - Parameter recipe: The `RecipeModel` to display in this row, which will be converted into a view model for managing display logic.
    init(recipe: RecipeModel) {
        _viewModel = StateObject(wrappedValue: RecipeRowViewModel(recipe: recipe))
    }

    var body: some View {
        HStack(spacing: 12) {
            photoView
            textContent
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .shadow(color: .secondary.opacity(0.4), radius: 4, x: 0, y: 2)
    }

    /// The photo view component of the recipe row.
    ///
    /// This view uses `AsyncImage` to load and display the recipe's photo asynchronously, with a progress view as a placeholder for loading states.
    private var photoView: some View {
        AsyncImage(url: viewModel.getPhotoURL()) { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(10)
                .shadow(color: .secondary.opacity(0.2), radius: 4, x: 0, y: 2)
        } placeholder: {
            ProgressView()
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }

    /// The text content of the recipe row, showing cuisine type and recipe name.
    ///
    /// This component organizes the textual information in a vertical stack, with the cuisine type in a smaller, secondary font, followed by the recipe name in a more prominent style.
    private var textContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.getFormattedCuisineType())
                .font(.caption)
                .foregroundColor(.secondary)

            Text(viewModel.getFormattedRecipeName())
                .font(.headline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }
}

// MARK: - Preview
/// Provides previews for `RecipeRowView` to visualize how it looks in both light and dark modes.
///
/// These previews use a sample `RecipeModel` to demonstrate the view's appearance, wrapped in dividers to simulate list separation.
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

    Group {
        Divider()
        RecipeRowView(recipe: sampleRecipe)
            .preferredColorScheme(.light)
        Divider()
    }
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

    Group {
        Divider()
        RecipeRowView(recipe: sampleRecipe)
            .preferredColorScheme(.dark)
        Divider()
    }
}
