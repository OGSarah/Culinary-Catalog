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
            backgroundGradient
                .edgesIgnoringSafeArea(.all)
            RecipeListView(viewContext: viewContext)
            .navigationTitle("Recipes")
            .toolbar {
                Image(systemName: "arrow.clockwise.circle")
                    .foregroundStyle(.blue, .gray)
                    .onTapGesture {
                        // TODO: Add button action to refresh the recipes via a network call.
                    }
            }
            .searchable(text: .constant("")) {

            }
        }
    }

}

#Preview ("Light Mode") {
    ContentView().environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
        .preferredColorScheme(.light)
}

#Preview ("Dark Mode") {
    ContentView().environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
        .preferredColorScheme(.dark)
}
