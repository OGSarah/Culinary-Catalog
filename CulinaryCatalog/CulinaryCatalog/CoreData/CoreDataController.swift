//
//  CoreDataController.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData

enum StorageType {
    case persistent
    case inMemory
}

class CoreDataController {
    /// The shared instance of `CoreDataController` for use throughout the app.
    static let shared = CoreDataController()

    let persistentContainer: NSPersistentContainer

    init(_ storageType: StorageType = .persistent) {
        self.persistentContainer = NSPersistentContainer(name: "CulinaryCatalog")

        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.persistentContainer.persistentStoreDescriptions = [description]
        }

        self.persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    /// A preview instance of `CoreDataController` for SwiftUI previews or testing.
    ///
    /// This instance uses an in-memory store to avoid persisting changes to disk, and it populates the context with sample data.
    @MainActor
    static let preview: CoreDataController = {
        let result = CoreDataController(StorageType.inMemory)
        let viewContext = result.persistentContainer.viewContext

        // Populate the context with sample data for preview purposes
        for _ in 0..<10 {
            let newRecipe = Recipe(context: viewContext)
            newRecipe.id = UUID()
            newRecipe.cuisineType = "Canadian"
            newRecipe.recipeName = "BeaverTails"
            newRecipe.photoSmall = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/3b33a385-3e55-4ea5-9d98-13e78f840299/small.jpg"
            newRecipe.photoLarge = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/3b33a385-3e55-4ea5-9d98-13e78f840299/large.jpg"
            newRecipe.sourceURL = "https://www.tastemade.com/videos/beavertails"
            newRecipe.youTubeURL = "https://www.youtube.com/watch?v=2G07UOqU2e8"
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return result
    }()

}
