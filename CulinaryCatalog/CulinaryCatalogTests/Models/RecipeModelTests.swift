//
//  RecipeModelTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/7/25.
//

import CoreData
import Testing
@testable import CulinaryCatalog

struct RecipeModelTests {

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

    @Test func testInitialization() throws {
        clearCoreData()

        let id = UUID()
        let model = RecipeModel(
            cuisineType: "Italian",
            recipeName: "Pizza Margherita",
            photoLarge: "large.jpg",
            photoSmall: "small.jpg",
            sourceURL: "example.com/pizza",
            id: id,
            youTubeURL: "youtube.com/pizza"
        )

        #expect(model.cuisineType == "Italian")
        #expect(model.recipeName == "Pizza Margherita")
        #expect(model.photoURLLarge == "large.jpg")
        #expect(model.photoURLSmall == "small.jpg")
        #expect(model.sourceURL == "example.com/pizza")
        #expect(model.id == id)
        #expect(model.youTubeURL == "youtube.com/pizza")

    }

    @Test func testEquatable() throws {
        clearCoreData()

        let id = UUID()
        let model1 = RecipeModel(
            cuisineType: "Italian",
            recipeName: "Pizza Margherita",
            photoLarge: "large.jpg",
            photoSmall: "small.jpg",
            sourceURL: "example.com/pizza",
            id: id,
            youTubeURL: "youtube.com/pizza"
        )
        let model2 = RecipeModel(
            cuisineType: "Italian",
            recipeName: "Pizza Margherita",
            photoLarge: "large.jpg",
            photoSmall: "small.jpg",
            sourceURL: "example.com/pizza",
            id: id,
            youTubeURL: "youtube.com/pizza"
        )
        let model3 = RecipeModel(
            cuisineType: "French",
            recipeName: "Croissant",
            photoLarge: "croissant.jpg",
            photoSmall: "croissant_small.jpg",
            sourceURL: "example.com/croissant",
            id: UUID(),
            youTubeURL: "youtube.com/croissant"
        )

        #expect(model1 == model2)
        #expect(model1 != model3)
    }

    @Test func testCoreDataInitialization() throws {
        clearCoreData()

        let entity = Recipe(context: context)
        entity.cuisineType = "Italian"
        entity.recipeName = "Pizza Margherita"
        entity.photoLarge = "large.jpg"
        entity.photoSmall = "small.jpg"
        entity.sourceURL = "example.com/pizza"
        entity.id = UUID()
        entity.youTubeURL = "youtube.com/pizza"

        let model = RecipeModel(entity: entity)

        #expect(model.cuisineType == "Italian")
        #expect(model.recipeName == "Pizza Margherita")
        #expect(model.photoURLLarge == "large.jpg")
        #expect(model.photoURLSmall == "small.jpg")
        #expect(model.sourceURL == "example.com/pizza")
        #expect(model.id != nil)
        #expect(model.youTubeURL == "youtube.com/pizza")
    }

}
