//
//  CulinaryCatalogApp.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import SwiftUI

@main
struct CulinaryCatalogApp: App {
    let coreDataController = CoreDataController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewContext: coreDataController.persistentContainer.viewContext)
                .environment(\.managedObjectContext, coreDataController.persistentContainer.viewContext)
        }
    }
}
