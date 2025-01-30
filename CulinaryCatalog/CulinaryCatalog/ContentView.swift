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
        }
    }

    func refreshRecipes() async {
        isRotating = true
        do {
            try await recipeListViewModel.refreshRecipes()
        } catch {
            print("Refresh failed: \(error.localizedDescription)")
        }

        // Use MainActor to update UI on main thread
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
