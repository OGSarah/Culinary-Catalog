//
//  RecipeListViewModelTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/6/25.
//

import CoreData
import Testing
@testable import CulinaryCatalog

struct RecipeListViewModelTests {

    private let controller = CoreDataController(.inMemory)
    private var context: NSManagedObjectContext {
        controller.persistentContainer.viewContext
    }

    private func clearCoreData() {
        context.performAndWait {
            do {
                let fetchRequest: NSFetchRequest = Recipe.fetchRequest()
                let objects = try context.fetch(fetchRequest)
                for object in objects {
                    context.delete(object)
                }
                try context.save()
            } catch {
                print("Error clearing Core Data: \(error)")
            }
        }
    }

    private func setUp() {
        clearCoreData()
    }

    private func makeSUT(recipes: [RecipeModel] = [], shouldThrowError: Bool = false) -> (viewModel: RecipeListViewModel, repository: MockRecipeDataRepository) {
        let mockRepository = MockRecipeDataRepository()
        mockRepository.recipesToReturn = recipes
        mockRepository.shouldThrowError = shouldThrowError
        let viewModel = RecipeListViewModel(recipeRepository: mockRepository, viewContext: context, networkManager: MockNetworkManager())
        return (viewModel, mockRepository)
    }

    @Test func testLoadRecipesSuccess() async {
        setUp()

        let testRecipes = [RecipeModel(
            cuisineType: "Malaysian",
            recipeName: "Apam Balik",
            photoLarge: "someURL",
            photoSmall: "someURL",
            sourceURL: "someURL",
            id: UUID(uuidString: "0c6ca6e7-e32a-4053-b824-1dbf749910d8")!,
            youTubeURL: "someURL"
        )]
        let (sut, _) = makeSUT(recipes: testRecipes)

        await sut.loadRecipes()

        #expect(sut.recipes == testRecipes)
        #expect(sut.errorMessage == nil)
    }

    @Test func testLoadRecipesFailure() async {
        setUp()
        let (sut, _) = makeSUT(shouldThrowError: true)

        await sut.loadRecipes()

        #expect(sut.recipes.isEmpty == true)
        #expect(sut.errorMessage != nil)
    }

    @Test func testRefreshRecipesFailure() async {
        setUp()
        let (sut, _) = makeSUT(shouldThrowError: true)
        await sut.loadRecipes()
        do {
            try await sut.refreshRecipes()
            #expect(Bool(false)) // Should not reach here if an error is thrown
        } catch {
            #expect(sut.recipes.isEmpty == true)
            #expect(sut.errorMessage != nil)
            #expect(sut.isRefreshing == false) // Should be false after refresh fails
        }
    }

    @Test func testFilteredRecipes() async {
        setUp()
        let recipes = [
            RecipeModel(cuisineType: "Italian", recipeName: "Pizza", photoLarge: "", photoSmall: "", sourceURL: "", id: UUID(), youTubeURL: ""),
            RecipeModel(cuisineType: "French", recipeName: "Baguette", photoLarge: "", photoSmall: "", sourceURL: "", id: UUID(), youTubeURL: "")
        ]
        let (sut, _) = makeSUT(recipes: recipes)
        await sut.loadRecipes()
        #expect(sut.recipes.count == 2)

        let filtered = sut.filteredRecipes(searchText: "ita")

        #expect(filtered.count == 1)
        #expect(filtered.first?.cuisineType == "Italian")
    }

    @Test func testFilteredRecipesEmptySearch() async {
        setUp()
        let recipes = [RecipeModel(
            cuisineType: "Italian",
            recipeName: "Pizza",
            photoLarge: "",
            photoSmall: "",
            sourceURL: "",
            id: UUID(),
            youTubeURL: "")]
        let (sut, _) = makeSUT(recipes: recipes)
        await sut.loadRecipes()

        let filtered = sut.filteredRecipes(searchText: "")

        #expect(filtered == recipes)
    }

}
