//
//  RecipeListView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData
import SwiftUI

struct RecipeListView: View {
    @StateObject private var recipeListViewModel: RecipeListViewModel
    @State private var searchText = ""

    init(viewContext: NSManagedObjectContext) {
        _recipeListViewModel = StateObject(wrappedValue: RecipeListViewModel(viewContext: viewContext))
    }

    var body: some View {
        List {
            ForEach(recipeListViewModel.filteredRecipes(searchText: searchText)) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    RecipeRowView(recipe: recipe)
                }
            }
        }

        .searchable(text: $searchText, prompt: "Search")
        .onAppear {
            recipeListViewModel.loadRecipes()
        }
        .alert("Error", isPresented: .constant(recipeListViewModel.errorMessage != nil)) {
            Button("OK") {
                recipeListViewModel.errorMessage = nil
            }
        } message: {
            Text(recipeListViewModel.errorMessage ?? "")
        }
    }
}

// MARK: - Preview
#Preview("Light Mode") {
    RecipeListView(viewContext: CoreDataController.preview.container.viewContext)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    RecipeListView(viewContext: CoreDataController.preview.container.viewContext)
        .preferredColorScheme(.dark)
}
