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
    /// This uses the shared instance to ensure a single point of access to Core Data across the application,
    /// facilitating data consistency and management.
    let coreDataController = CoreDataController.shared

    var body: some Scene {
        /// Defines the main scene of the application, which is a single window group for iOS or macOS.
        ///
        /// The `WindowGroup` here contains the `ContentView`, which is the root view of our UI hierarchy,
        /// and injects the managed object context into the environment for use by any child views that
        /// need to interact with Core Data.
        WindowGroup {
            ContentView(viewContext: coreDataController.persistentContainer.viewContext)
                .environment(\.managedObjectContext, coreDataController.persistentContainer.viewContext)
        }
    }

}
