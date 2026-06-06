//
//  CulinaryCatalogApp.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import SwiftUI

/// The entry point of the "CulinaryCatalog" application, conforming to SwiftUI's `App` protocol.
///
/// This structure sets up the main application scene, configuring the Core Data stack and providing
/// the root view of the application with the necessary data context.
@main
struct CulinaryCatalogApp: App {
    /// An instance of `CoreDataController` for managing Core Data operations throughout the app.
    ///
    /// In normal launches this uses the shared persistent store. When the process is launched with
    /// `-uiTesting`, the controller is swapped for an in-memory store pre-seeded with fixture data
    /// so UI tests can run deterministically without network access.
    let coreDataController: CoreDataController

    @MainActor
    init() {
        if CommandLine.arguments.contains("-uiTesting") {
            coreDataController = CoreDataController.uiTestingSeeded()
        } else {
            coreDataController = CoreDataController.shared
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewContext: coreDataController.persistentContainer.viewContext)
                .environment(\.managedObjectContext, coreDataController.persistentContainer.viewContext)
        }
    }

}
