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

    /// The network manager used by the recipe screens.
    ///
    /// Normally backed by `NetworkManager.shared`. When the process is launched with `-uiTesting`,
    /// this is swapped for a stub that never touches the network so UI tests cannot accidentally
    /// hit the live recipes endpoint or hang on a slow connection in CI.
    let networkManager: NetworkManagerProtocol

    @MainActor
    init() {
        if CommandLine.arguments.contains("-uiTesting") {
            coreDataController = CoreDataController.uiTestingSeeded()
            networkManager = UITestingStubNetworkManager()
        } else {
            coreDataController = CoreDataController.shared
            networkManager = NetworkManager.shared
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                viewContext: coreDataController.persistentContainer.viewContext,
                networkManager: networkManager
            )
            .environment(\.managedObjectContext, coreDataController.persistentContainer.viewContext)
        }
    }

}

/// A no-op `NetworkManagerProtocol` used when the app is launched with `-uiTesting`.
///
/// Returns an empty array so the app falls back to the recipes already seeded into the in-memory
/// Core Data store by `CoreDataController.uiTestingSeeded()`. This guarantees UI tests never make
/// real network calls, which keeps them deterministic and avoids the multi-second timeouts that
/// were causing CI failures on the GitHub-hosted macOS runners.
struct UITestingStubNetworkManager: NetworkManagerProtocol {
    func fetchRecipesFromNetwork() async throws -> [RecipeModel] {
        []
    }
}
