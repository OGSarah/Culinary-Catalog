//
//  RecipeDataRepositoryTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/4/25.
//

import CoreData
import Network
import Testing
@testable import CulinaryCatalog

struct RecipeDataRepositoryTests {

    private let mockNetworkManager = MockNetworkManager()

    static func clearContext(_ context: NSManagedObjectContext) throws {
        let fetchRequest: NSFetchRequest = Recipe.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        let batchDeleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
        if let result = batchDeleteResult?.result as? [NSManagedObjectID] {
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: result], into: [context])
        }
    }

    @Test func testFetchRecipes() async throws {
        let coreDataController = CoreDataController.testController()
        let repository = RecipeDataRepository(networkManager: mockNetworkManager, viewContext: coreDataController.container.viewContext)

        // No need to add mock data since testController already populates the context
        let recipes = try await repository.fetchRecipes()

        // Expect 10 recipes because testController adds 10
        #expect(recipes.count == 10)
        // Checking if the first recipe matches what testController adds
        #expect(recipes.first?.recipeName == "BeaverTails")
    }

    @Test func testRefreshRecipes() async throws {
        let coreDataController = CoreDataController.testController()
        let repository = RecipeDataRepository(networkManager: mockNetworkManager, viewContext: coreDataController.container.viewContext)

        // Mock network fetch to return a single recipe, different from what's in Core Data
        mockNetworkManager.mockRecipes = [
            RecipeModel(
                cuisineType: "Malaysian",
                recipeName: "Apam Balik",
                photoLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                photoSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                sourceURL: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                id: UUID(uuidString: "0c6ca6e7-e32a-4053-b824-1dbf749910d8")!,
                youTubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
            )
        ]

        let refreshedRecipes = try await repository.refreshRecipes()

        #expect(refreshedRecipes.count == 63) // Only one recipe from mock network fetch
        #expect(refreshedRecipes.first?.recipeName == "Apam Balik")

        // Check if the data in Core Data has changed to match the mock recipe
        let fetchRequest: NSFetchRequest = Recipe.fetchRequest()
        let fetchedEntities = try coreDataController.container.viewContext.fetch(fetchRequest)
        #expect(fetchedEntities.count == 1)
        #expect(fetchedEntities.first?.recipeName == "Apam Balik")
    }

    @Test func testRefreshRecipesError() async throws {
        let coreDataController = CoreDataController.testController()
        let repository = RecipeDataRepository(networkManager: mockNetworkManager, viewContext: coreDataController.container.viewContext)

        // Mock network fetch to throw an error
        mockNetworkManager.shouldThrowError = true

        do {
            _ = try await repository.refreshRecipes()
            #expect(Bool(false)) // Should not reach here if an error is thrown
        } catch {
            #expect(Bool(true)) // An error should have been thrown
        }

        // Check if Core Data still contains the original 10 recipes
        let fetchRequest: NSFetchRequest = Recipe.fetchRequest()
        let fetchedEntities = try coreDataController.container.viewContext.fetch(fetchRequest)
        #expect(fetchedEntities.count == 10) // Data should not change due to the error
    }
}
