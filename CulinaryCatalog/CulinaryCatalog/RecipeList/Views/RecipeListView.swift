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

    init(viewContext: NSManagedObjectContext) {
        _recipeListViewModel = StateObject(wrappedValue: RecipeListViewModel(viewContext: viewContext))
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
