//
//  CoreDataControllerTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/6/25.
//

import CoreData
import Testing
@testable import CulinaryCatalog

struct CoreDataControllerTests {

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

    @Test func testInitialization() async throws {
        setUp()

        let id = UUID()
        let recipe = RecipeModel(
            cuisineType: "Italian",
            recipeName: "Pasta Carbonara",
            photoLarge: "large.jpg",
            photoSmall: "small.jpg",
            sourceURL: "source.com",
            id: id,
            youTubeURL: "youtube.com"
        )

        #expect(recipe.cuisineType == "Italian")
        #expect(recipe.recipeName == "Pasta Carbonara")
        #expect(recipe.photoLarge == "large.jpg")
        #expect(recipe.photoSmall == "small.jpg")
        #expect(recipe.sourceURL == "source.com")
        #expect(recipe.id == id)
        #expect(recipe.youTubeURL == "youtube.com")

        clearCoreData() // Clean up after the test
    }

    @Test func testInitializationFromEntity() async throws {
        setUp()

        let entity = Recipe(context: context)
        entity.id = UUID()
        entity.cuisineType = "French"
        entity.recipeName = "Baguette"
        entity.photoLarge = "french_large.jpg"
        entity.photoSmall = "french_small.jpg"
        entity.sourceURL = "french_recipe.com"
        entity.youTubeURL = "french_youtube.com"

        let model = RecipeModel(entity: entity)

        #expect(model.cuisineType == "French")
        #expect(model.recipeName == "Baguette")
        #expect(model.photoLarge == "french_large.jpg")
        #expect(model.photoSmall == "french_small.jpg")
        #expect(model.sourceURL == "french_recipe.com")
        #expect(model.youTubeURL == "french_youtube.com")
        #expect(model.id != nil) // Check if ID is set, since we set it in the entity

        clearCoreData()
    }

    @Test func testInitializationFromEntityWithNilValues() async throws {
        setUp()

        let entity = Recipe(context: context)
        // Here, we leave all attributes as nil

        let model = RecipeModel(entity: entity)

        #expect(model.cuisineType.isEmpty == true)
        #expect(model.recipeName.isEmpty == true)
        #expect(model.photoLarge.isEmpty == true)
        #expect(model.photoSmall.isEmpty == true)
        #expect(model.sourceURL.isEmpty == true)
        #expect(model.youTubeURL.isEmpty == true)
        #expect(model.id != nil) // ID should be set to a new UUID since it was nil

        clearCoreData()
    }

    @Test func testCodableConformance() async throws {
        setUp()

        let id = UUID()
        let recipe = RecipeModel(
            cuisineType: "Mexican",
            recipeName: "Tacos",
            photoLarge: "tacos_large.jpg",
            photoSmall: "tacos_small.jpg",
            sourceURL: "tacos.com",
            id: id,
            youTubeURL: "tacos_youtube.com"
        )

        let jsonData = try JSONEncoder().encode(recipe)
        let decodedRecipe = try JSONDecoder().decode(RecipeModel.self, from: jsonData)

        #expect(recipe == decodedRecipe)

        clearCoreData()
    }

}
