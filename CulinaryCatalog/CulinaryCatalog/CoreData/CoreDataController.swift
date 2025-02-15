//
//  CoreDataController.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData

/// Defines the storage types for Core Data persistence.
///
/// - `persistent`: Uses a persistent storage on disk.
/// - `inMemory`: Uses in-memory storage, ideal for testing or previews where data should not persist between app launches.
enum StorageType {
    case persistent
    case inMemory
}

/// Manages Core Data stack, providing a centralized point for accessing and manipulating Core Data.
///
/// This class initializes the Core Data stack with either persistent or in-memory storage based on the `StorageType`. It offers a shared instance for use across the application and a preview instance for testing or SwiftUI preview purposes.
class CoreDataController {
    /// The shared instance of `CoreDataController` for use throughout the app.
    ///
    /// This singleton ensures that there's only one instance of the Core Data stack managing data operations across the application, ensuring consistency and efficient resource management.
    static let shared = CoreDataController()

    /// The persistent container managing the Core Data stack.
    ///
    /// This container holds the managed object contexts, persistent stores, and model. It's configured either for on-disk persistence or in-memory storage.
    let persistentContainer: NSPersistentContainer

    /// Initializes a new Core Data controller.
    ///
    /// - Parameter storageType: The type of storage to use, either `.persistent` for disk storage or `.inMemory` for transient storage. Defaults to `.persistent`.
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
    /// This instance uses an in-memory store to avoid persisting changes to disk, and it populates the context with sample data for demonstration purposes in previews or tests.
    ///
    /// - Warning: Use this only for testing or previewing; data will not be saved between app sessions.
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
            newRecipe.photoURLSmall = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/3b33a385-3e55-4ea5-9d98-13e78f840299/small.jpg"
            newRecipe.photoURLLarge = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/3b33a385-3e55-4ea5-9d98-13e78f840299/large.jpg"
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
