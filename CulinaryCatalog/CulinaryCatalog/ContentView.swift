//
//  ContentView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var recipeListViewModel: RecipeListViewModel

    init(viewContext: NSManagedObjectContext) {
        _recipeListViewModel = StateObject(wrappedValue: RecipeListViewModel(viewContext: viewContext))
    }

    let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .blue.opacity(0.6), location: 0),
            Gradient.Stop(color: .blue.opacity(0.3), location: 0.256),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        NavigationStack {
            VStack {
                RecipeListView(viewContext: viewContext)
            }

            .navigationTitle("Recipes")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                Image(systemName: "arrow.clockwise.circle")
                    .foregroundStyle(.blue, .gray)
                    .onTapGesture {
                        recipeListViewModel.refreshRecipes()
                    }
            }
        }
    }
}

#Preview("Light Mode") {
    ContentView(viewContext: CoreDataController.preview.container.viewContext)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView(viewContext: CoreDataController.preview.container.viewContext)
        .preferredColorScheme(.dark)
}
