//
//  CoreDataController.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData

/// A controller for managing Core Data operations in the app.
///
/// This struct provides a singleton instance for managing the Core Data stack, including the persistent container and context setup.
struct CoreDataController {
    /// The shared instance of `CoreDataController` for use throughout the app.
    static let shared = CoreDataController()

    /// A preview instance of `CoreDataController` for SwiftUI previews or testing.
    ///
    /// This instance uses an in-memory store to avoid persisting changes to disk, and it populates the context with sample data.
    @MainActor
    static let preview: CoreDataController = {
        let result = CoreDataController(inMemory: true)
        let viewContext = result.container.viewContext

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

    /// Creates a `CoreDataController` instance for unit testing.
    ///
    /// This method sets up an in-memory Core Data stack for testing, allowing for quick setup and teardown.
    static func testController() -> CoreDataController {
        let result = CoreDataController(inMemory: true)
        let viewContext = result.container.viewContext

        // Populate the context with sample data for testing purposes
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
    }

    /// The Core Data persistent container which manages the persistent stores.
    let container: NSPersistentContainer

    /// Initializes the `CoreDataController`.
    ///
    /// - Parameter inMemory: If `true`, uses an in-memory store for testing or preview purposes. Defaults to `false`.
    init(inMemory: Bool = false) {
        guard let modelURL = Bundle.main.url(forResource: "CulinaryCatalog", withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to find Core Data model")
        }

        container = NSPersistentContainer(name: "CulinaryCatalog", managedObjectModel: managedObjectModel)

        if inMemory {
            // Use an in-memory store for non-persistent data
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
        }

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")

#if DEBUG
                fatalError("Unresolved error \(error), \(error.userInfo)")
#endif
            }
        }

        // Configure the view context to automatically merge changes from parent contexts and use a specific merge policy
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
