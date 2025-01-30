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
        HStack {
            AsyncImage(url: URL(string: recipe.photoSmall)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
            }
            Spacer()
            Text(recipe.recipeName)
                .font(.headline)
        }
        .padding()
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
        RecipeRowView(recipe: sampleRecipe)
            .preferredColorScheme(.dark)
        Divider()
    }
}
