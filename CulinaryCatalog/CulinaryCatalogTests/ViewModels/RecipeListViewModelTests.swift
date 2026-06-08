//
//  RecipeListViewModelTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/6/25.
//

import CoreData
import Testing
@testable import CulinaryCatalog

@MainActor
@Suite(.serialized)
struct RecipeListViewModelTests {

    private let controller = CoreDataController(.inMemory)
    private var context: NSManagedObjectContext {
        controller.persistentContainer.viewContext
    }

    private func clearCoreData() {
        let context = self.context
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

    private func makeSUT(
        recipes: [RecipeModel] = [],
        shouldThrowError: Bool = false
    ) -> (viewModel: RecipeListViewModel, network: MockNetworkManager) {
        let mockNetwork = MockNetworkManager()
        mockNetwork.mockRecipes = recipes
        mockNetwork.shouldThrowError = shouldThrowError
        // Use an offline mock session so the image-cache step does not hit the real network in CI.
        let mockSession = MockURLSession()
        mockSession.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        let viewModel = RecipeListViewModel(
            viewContext: context,
            networkManager: mockNetwork,
            imageDownloadSession: mockSession
        )
        return (viewModel, mockNetwork)
    }

    private func makeRecipe(
        cuisineType: String = "Italian",
        recipeName: String = "Pizza",
        id: UUID = UUID()
    ) -> RecipeModel {
        RecipeModel(
            cuisineType: cuisineType,
            recipeName: recipeName,
            photoURLLarge: "https://example.com/large.jpg",
            photoURLSmall: "https://example.com/small.jpg",
            recipeImageSmall: nil,
            recipeImageLarge: nil,
            sourceURL: "https://example.com/source",
            id: id,
            youTubeURL: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        )
    }

    @Test func testGetRecipesFromNetworkSuccess() async throws {
        clearCoreData()
        let testRecipe = makeRecipe(cuisineType: "Malaysian", recipeName: "Apam Balik")
        let (sut, _) = makeSUT(recipes: [testRecipe])

        try await sut.getRecipesFromNetwork()

        #expect(sut.recipes.count == 1)
        #expect(sut.recipes.first?.recipeName == "Apam Balik")
        #expect(sut.errorMessage == nil)
    }

    @Test func testGetRecipesFromNetworkFailure() async throws {
        clearCoreData()
        let (sut, _) = makeSUT(shouldThrowError: true)

        try await sut.getRecipesFromNetwork()

        // Errors are handled internally and surfaced via errorMessage
        #expect(sut.errorMessage != nil)
    }

    @Test func testRefreshRecipesSuccess() async throws {
        clearCoreData()
        let testRecipe = makeRecipe(cuisineType: "Italian", recipeName: "Pizza")
        let (sut, _) = makeSUT(recipes: [testRecipe])

        let returned = try await sut.refreshRecipes()

        #expect(returned.count == 1)
        #expect(sut.recipes.count == 1)
        #expect(sut.recipes.first?.recipeName == "Pizza")
        #expect(sut.errorMessage == nil)
    }

    @Test func testRefreshRecipesFailure() async {
        clearCoreData()
        let (sut, _) = makeSUT(shouldThrowError: true)

        await #expect(throws: (any Error).self) {
            _ = try await sut.refreshRecipes()
        }
        #expect(sut.isRefreshing == false)
    }

    @Test func testLoadSortedRecipesFromCoreData() async throws {
        clearCoreData()

        // Insert recipes directly into Core Data
        for name in ["Carrot Cake", "Apple Pie", "Banana Bread"] {
            let entity = Recipe(context: context)
            entity.id = UUID()
            entity.recipeName = name
            entity.cuisineType = "American"
            entity.photoURLSmall = ""
            entity.photoURLLarge = ""
            entity.sourceURL = ""
            entity.youTubeURL = ""
        }
        try context.save()

        let sut = RecipeListViewModel(viewContext: context, networkManager: MockNetworkManager())
        try await sut.loadSortedRecipesFromCoreData()

        #expect(sut.recipes.count == 3)
        // Verify alphabetical sort
        #expect(sut.recipes.map { $0.recipeName } == ["Apple Pie", "Banana Bread", "Carrot Cake"])
    }

    @Test func testFilteredRecipesByName() async throws {
        clearCoreData()
        let recipes = [
            makeRecipe(cuisineType: "Italian", recipeName: "Pizza"),
            makeRecipe(cuisineType: "French", recipeName: "Baguette")
        ]
        let (sut, _) = makeSUT(recipes: recipes)
        try await sut.getRecipesFromNetwork()

        let filtered = sut.filteredRecipes(searchText: "pizz")

        #expect(filtered.count == 1)
        #expect(filtered.first?.recipeName == "Pizza")
    }

    @Test func testFilteredRecipesByCuisine() async throws {
        clearCoreData()
        let recipes = [
            makeRecipe(cuisineType: "Italian", recipeName: "Pizza"),
            makeRecipe(cuisineType: "French", recipeName: "Baguette")
        ]
        let (sut, _) = makeSUT(recipes: recipes)
        try await sut.getRecipesFromNetwork()

        let filtered = sut.filteredRecipes(searchText: "fren")

        #expect(filtered.count == 1)
        #expect(filtered.first?.cuisineType == "French")
    }

    @Test func testFilteredRecipesEmptySearchReturnsAll() async throws {
        clearCoreData()
        let recipes = [
            makeRecipe(cuisineType: "Italian", recipeName: "Pizza"),
            makeRecipe(cuisineType: "French", recipeName: "Baguette")
        ]
        let (sut, _) = makeSUT(recipes: recipes)
        try await sut.getRecipesFromNetwork()

        let filtered = sut.filteredRecipes(searchText: "")

        #expect(filtered.count == 2)
    }

    @Test func testFilteredRecipesIsCaseInsensitive() async throws {
        clearCoreData()
        let recipes = [makeRecipe(cuisineType: "Italian", recipeName: "Pizza")]
        let (sut, _) = makeSUT(recipes: recipes)
        try await sut.getRecipesFromNetwork()

        let filtered = sut.filteredRecipes(searchText: "PIZ")

        #expect(filtered.count == 1)
    }

    @Test func testFilteredRecipesNoMatch() async throws {
        clearCoreData()
        let recipes = [makeRecipe(cuisineType: "Italian", recipeName: "Pizza")]
        let (sut, _) = makeSUT(recipes: recipes)
        try await sut.getRecipesFromNetwork()

        let filtered = sut.filteredRecipes(searchText: "sushi")

        #expect(filtered.isEmpty)
    }

}
