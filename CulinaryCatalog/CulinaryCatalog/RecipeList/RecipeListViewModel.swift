//
//  RecipeListViewModel.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData

@MainActor
final class RecipeListViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    private let viewContext: NSManagedObjectContext
    @Published var errorMessage: String?

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchRecipes()
    }

    func loadRecipes() {
        Task {
            do {
                recipes = try await NetworkManager.shared.fetchRecipes()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func filteredRecipes(searchText: String) -> [RecipeModel] {
        guard !searchText.isEmpty else {
            return recipes
        }

        return recipes.filter {
            $0.recipeName.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Private functions
    private func fetchRecipes() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        do {
            let entities = try viewContext.fetch(fetchRequest)
            recipes = entities.map { RecipeModel(entity: $0) }
        } catch {
            print("Error fetching recipes from the CoreData model: \(error.localizedDescription)")
        }
    }

}
