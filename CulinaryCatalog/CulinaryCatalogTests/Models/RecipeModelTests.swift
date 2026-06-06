//
//  RecipeModelTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/7/25.
//

import CoreData
import Testing
@testable import CulinaryCatalog

@Suite(.serialized)
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

    @Test func testInitialization() throws {
        let id = UUID()
        let model = makeRecipe(cuisineType: "Italian", recipeName: "Pizza Margherita", id: id)

        #expect(model.cuisineType == "Italian")
        #expect(model.recipeName == "Pizza Margherita")
        #expect(model.photoURLLarge == "https://example.com/large.jpg")
        #expect(model.photoURLSmall == "https://example.com/small.jpg")
        #expect(model.sourceURL == "https://example.com/source")
        #expect(model.id == id)
        #expect(model.youTubeURL == "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
        #expect(model.recipeImageSmall == nil)
        #expect(model.recipeImageLarge == nil)
    }

    @Test func testInitializationWithImageData() throws {
        let imageData = Data([0x01, 0x02, 0x03])
        let model = RecipeModel(
            cuisineType: "Italian",
            recipeName: "Pizza Margherita",
            photoURLLarge: "https://example.com/large.jpg",
            photoURLSmall: "https://example.com/small.jpg",
            recipeImageSmall: imageData,
            recipeImageLarge: imageData,
            sourceURL: "https://example.com/source",
            id: UUID(),
            youTubeURL: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        )

        #expect(model.recipeImageSmall == imageData)
        #expect(model.recipeImageLarge == imageData)
    }

    @Test func testEquatableSameProperties() throws {
        let id = UUID()
        let model1 = makeRecipe(id: id)
        let model2 = makeRecipe(id: id)

        #expect(model1 == model2)
    }

    @Test func testEquatableDifferentProperties() throws {
        let model1 = makeRecipe(cuisineType: "Italian", recipeName: "Pizza")
        let model2 = makeRecipe(cuisineType: "French", recipeName: "Baguette")

        #expect(model1 != model2)
    }

    @Test func testEquatableDifferentImageData() throws {
        let id = UUID()
        let model1 = RecipeModel(
            cuisineType: "Italian",
            recipeName: "Pizza",
            photoURLLarge: "",
            photoURLSmall: "",
            recipeImageSmall: Data([0x01]),
            recipeImageLarge: nil,
            sourceURL: "",
            id: id,
            youTubeURL: ""
        )
        let model2 = RecipeModel(
            cuisineType: "Italian",
            recipeName: "Pizza",
            photoURLLarge: "",
            photoURLSmall: "",
            recipeImageSmall: Data([0x02]),
            recipeImageLarge: nil,
            sourceURL: "",
            id: id,
            youTubeURL: ""
        )

        #expect(model1 != model2)
    }

    @Test func testCodableRoundTrip() throws {
        let original = makeRecipe()
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(RecipeModel.self, from: data)

        #expect(original == decoded)
    }

    @Test func testCoreDataEntityInitialization() throws {
        clearCoreData()

        let entity = Recipe(context: context)
        entity.cuisineType = "Italian"
        entity.recipeName = "Pizza Margherita"
        entity.photoURLLarge = "https://example.com/large.jpg"
        entity.photoURLSmall = "https://example.com/small.jpg"
        entity.sourceURL = "https://example.com/source"
        entity.id = UUID()
        entity.youTubeURL = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

        let model = RecipeModel(entity: entity)

        #expect(model.cuisineType == "Italian")
        #expect(model.recipeName == "Pizza Margherita")
        #expect(model.photoURLLarge == "https://example.com/large.jpg")
        #expect(model.photoURLSmall == "https://example.com/small.jpg")
        #expect(model.sourceURL == "https://example.com/source")
        #expect(model.youTubeURL == "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
        #expect(model.id == entity.id)
    }

    @Test func testCoreDataEntityInitializationWithNilValues() throws {
        clearCoreData()

        let entity = Recipe(context: context)
        // All attributes left as nil

        let model = RecipeModel(entity: entity)

        #expect(model.cuisineType.isEmpty)
        #expect(model.recipeName.isEmpty)
        #expect(model.photoURLLarge.isEmpty)
        #expect(model.photoURLSmall.isEmpty)
        #expect(model.sourceURL.isEmpty)
        #expect(model.youTubeURL.isEmpty)
        #expect(model.recipeImageSmall == nil)
        #expect(model.recipeImageLarge == nil)
    }

}
