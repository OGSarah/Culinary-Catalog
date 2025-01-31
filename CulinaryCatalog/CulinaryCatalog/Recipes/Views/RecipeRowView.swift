//
//  RecipeRowView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: RecipeModel

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: recipe.photoSmall)) { image in
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

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.cuisineType)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(recipe.recipeName)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .shadow(color: .secondary.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview
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
