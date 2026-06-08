//
//  CoreDataControllerTests.swift
//  CulinaryCatalogTests
//
//  Created by Sarah Clark on 2/6/25.
//

import CoreData
import Testing
@testable import CulinaryCatalog

@Suite(.serialized)
struct CoreDataControllerTests {

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

    @Test func testInMemoryStorageInitialization() throws {
        let inMemoryController = CoreDataController(.inMemory)
        let description = inMemoryController.persistentContainer.persistentStoreDescriptions.first

        #expect(description?.type == NSInMemoryStoreType)
    }

    @Test func testPersistentContainerName() throws {
        #expect(controller.persistentContainer.name == "CulinaryCatalog")
    }

    @Test func testInsertAndFetchRecipe() throws {
        clearCoreData()

        let id = UUID()
        let entity = Recipe(context: context)
        entity.id = id
        entity.cuisineType = "Italian"
        entity.recipeName = "Pasta Carbonara"
        entity.photoURLLarge = "large.jpg"
        entity.photoURLSmall = "small.jpg"
        entity.sourceURL = "source.com"
        entity.youTubeURL = "youtube.com"

        try context.save()

        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let results = try context.fetch(fetchRequest)

        #expect(results.count == 1)
        #expect(results.first?.id == id)
        #expect(results.first?.recipeName == "Pasta Carbonara")

        clearCoreData()
    }

    @Test func testDeleteRecipe() throws {
        clearCoreData()

        let entity = Recipe(context: context)
        entity.id = UUID()
        entity.recipeName = "Pasta"
        entity.cuisineType = "Italian"
        try context.save()

        context.delete(entity)
        try context.save()

        let results = try context.fetch(Recipe.fetchRequest())
        #expect(results.isEmpty)
    }

    @Test func testFetchByPredicate() throws {
        clearCoreData()

        let targetID = UUID()
        let target = Recipe(context: context)
        target.id = targetID
        target.recipeName = "Target Recipe"

        let other = Recipe(context: context)
        other.id = UUID()
        other.recipeName = "Other Recipe"

        try context.save()

        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", targetID as CVarArg)
        let results = try context.fetch(fetchRequest)

        #expect(results.count == 1)
        #expect(results.first?.recipeName == "Target Recipe")

        clearCoreData()
    }

    @Test func testImageBinaryDataPersists() throws {
        clearCoreData()

        let entity = Recipe(context: context)
        entity.id = UUID()
        entity.recipeImageSmall = Data([0xDE, 0xAD, 0xBE, 0xEF])
        entity.recipeImageLarge = Data([0xCA, 0xFE, 0xBA, 0xBE])
        try context.save()

        let result = try context.fetch(Recipe.fetchRequest()).first
        #expect(result?.recipeImageSmall == Data([0xDE, 0xAD, 0xBE, 0xEF]))
        #expect(result?.recipeImageLarge == Data([0xCA, 0xFE, 0xBA, 0xBE]))

        clearCoreData()
    }

    @MainActor
    @Test func testPreviewControllerPopulatesData() throws {
        let preview = CoreDataController.preview
        let previewContext = preview.persistentContainer.viewContext

        let results = try previewContext.fetch(Recipe.fetchRequest())

        #expect(results.count >= 10)
    }

}
