//
//  CoreDataController.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData

struct CoreDataController {
    static let shared = CoreDataController()

    @MainActor
    static let preview: CoreDataController = {
        let result = CoreDataController(inMemory: true)
        let viewContext = result.container.viewContext

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

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        guard let modelURL = Bundle.main.url(forResource: "CulinaryCatalog", withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to find Core Data model")
        }

        container = NSPersistentContainer(name: "CulinaryCatalog", managedObjectModel: managedObjectModel)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
        }

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")

#if DEBUG
                fatalError("Unresolved error \(error), \(error.userInfo)")
#endif
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
