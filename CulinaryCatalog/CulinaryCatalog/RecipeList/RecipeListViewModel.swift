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
    @Published var isRefreshing = false

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchRecipesFromCoreData()
    }

    func refreshRecipes() async throws {
        isRefreshing = true
        do {
            let newRecipes = try await NetworkManager.shared.fetchRecipesFromNetwork()
            await saveRecipesToCoreData(newRecipes)
            fetchRecipesFromCoreData()
            isRefreshing = false
        } catch {
            isRefreshing = false
            throw error
        }
    }

    func loadRecipes() {
        Task {
            do {
                recipes = try await NetworkManager.shared.fetchRecipesFromNetwork()
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
    private func saveRecipesToCoreData(_ recipes: [RecipeModel]) async {
        await viewContext.perform {
            // First, delete existing recipes
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Recipe.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try self.viewContext.execute(batchDeleteRequest)

                // Save new recipes
                for recipeModel in recipes {
                    let newRecipe = Recipe(context: self.viewContext)
                    newRecipe.id = recipeModel.id
                    newRecipe.recipeName = recipeModel.recipeName
                    newRecipe.cuisineType = recipeModel.cuisineType
                    newRecipe.photoSmall = recipeModel.photoSmall
                    newRecipe.photoLarge = recipeModel.photoLarge
                    newRecipe.sourceURL = recipeModel.sourceURL
                    newRecipe.youTubeURL = recipeModel.youTubeURL
                }

                try self.viewContext.save()
            } catch {
                print("Error saving recipes to CoreData: \(error.localizedDescription)")
            }
        }
    }

    private func fetchRecipesFromCoreData() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        do {
            let entities = try viewContext.fetch(fetchRequest)
            recipes = entities.map { RecipeModel(entity: $0) }
        } catch {
            print("Error fetching recipes from the CoreData model: \(error.localizedDescription)")
        }
    }

}
