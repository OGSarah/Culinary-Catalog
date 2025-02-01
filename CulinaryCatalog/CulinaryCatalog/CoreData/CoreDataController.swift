//
//  CoreDataController.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData

/// Manages the Core Data stack for the Culinary Catalog application.
///
/// This controller provides a shared instance and a preview instance for development and testing.
/// It handles the creation and configuration of the Core Data persistent container.
///
/// - Note: The controller supports in-memory stores for preview and testing scenarios.
struct CoreDataController {
    /// A shared singleton instance of the CoreDataController.
    ///
    /// Use this instance throughout the app to access the Core Data stack.
    static let shared = CoreDataController()

    /// A preview instance of CoreDataController for use in SwiftUI previews and testing.
    ///
    /// Creates an in-memory store with sample data for development purposes.
    ///
    /// - Returns: A CoreDataController instance with pre-populated sample data.
    /// - Important: This is intended for development and testing only.
    @MainActor
    static let preview: CoreDataController = {
        let result = CoreDataController(inMemory: true)
        let viewContext = result.container.viewContext

        // Create 10 sample recipes for preview
        for _ in 0..<10 {
            let newRecipe = Recipe(context: viewContext)
            newRecipe.id = UUID()
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return result
    }()

    /// The Core Data persistent container for the application.
    ///
    /// Manages the creation and lifecycle of the Core Data stack.
    let container: NSPersistentContainer

    /// Initializes a new CoreDataController instance.
    ///
    /// - Parameter inMemory: A boolean indicating whether to create an in-memory store.
    ///   When `true`, the persistent store is created in memory instead of on disk.
    ///   This is useful for testing and previewing without affecting the actual data store.
    ///
    /// - Note: The method configures the persistent container and loads the store.
    /// - Precondition: The Core Data model name must match the app's data model.
    init(inMemory: Bool = false) {
        // Initialize the persistent container with the app's data model name
        container = NSPersistentContainer(name: "CulinaryCatalog")

        // Configure in-memory store for testing if requested
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        // Load the persistent stores
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                // Fatal error if store cannot be loaded
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // Enable automatic merging of changes from parent contexts
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
