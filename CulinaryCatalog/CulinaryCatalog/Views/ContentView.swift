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
    @State private var isRotating = false
    private let recipeRepository: RecipeDataRepository

    /// Initializes the view with a recipe repository
    /// - Parameter viewContext: The Core Data managed object context
    init(viewContext: NSManagedObjectContext) {
        let recipeRepository = RecipeDataRepository(
            networkManager: NetworkManager.shared,
            viewContext: viewContext
        )
        self.recipeRepository = recipeRepository
        _recipeListViewModel = StateObject(wrappedValue: RecipeListViewModel(recipeRepository: recipeRepository))
    }

    /// Background gradient for the view
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
                RecipeListView(recipeRepository: recipeRepository)
            }
            .navigationTitle("Recipes")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .toolbar {
                refreshButton
            }
        }
    }

    /// Refresh button with animated rotation
    private var refreshButton: some View {
        Image(systemName: "arrow.clockwise.circle")
            .foregroundStyle(
                isRotating ? .blue : .blue.opacity(0.5),
                isRotating ? .white : .gray
            )
            .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
            .shadow(color: isRotating ? .white : .clear, radius: isRotating ? 15 : 0)
            .scaleEffect(isRotating ? 1.3 : 1)
            .animation(.linear(duration: 1).repeatCount(1, autoreverses: false), value: isRotating)
            .onTapGesture {
                Task {
                    await refreshRecipes()
                }
            }
    }

    /// Refreshes recipes with animated loading state
    ///
    /// - Note: Manages the rotation animation and calls the view model's refresh method
    func refreshRecipes() async {
        isRotating = true

        do {
            try await recipeListViewModel.refreshRecipes()
        } catch {
            // Optionally handle or log the error
            print("Refresh failed: \(error.localizedDescription)")
        }

        // Ensure UI updates happen on the main thread
        await MainActor.run {
            isRotating = false
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
