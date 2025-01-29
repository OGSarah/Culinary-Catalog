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
            Image(recipe.photoSmall)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(8)
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
        recipeName: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
        photoLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
        photoSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
        sourceURL: "Apple & Blackberry Crumble",
        id: UUID(),
        youTubeURL: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
    )

    Group {
        RecipeRowView(recipe: sampleRecipe)
            .preferredColorScheme(.light)

        RecipeRowView(recipe: sampleRecipe)
            .preferredColorScheme(.light)
    }
}

#Preview("Dark Mode") {
    let sampleRecipe = RecipeModel(
        cuisineType: "British",
        recipeName: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
        photoLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
        photoSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
        sourceURL: "Apple & Blackberry Crumble",
        id: UUID(),
        youTubeURL: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
    )

    Group {
        RecipeRowView(recipe: sampleRecipe)
            .preferredColorScheme(.dark)

        RecipeRowView(recipe: sampleRecipe)
            .preferredColorScheme(.dark)
    }
}
