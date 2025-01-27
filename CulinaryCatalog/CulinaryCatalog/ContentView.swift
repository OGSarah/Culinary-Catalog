//
//  ContentView.swift
//  CulinaryCatalog
//
//  Created by Sarah Clark on 1/27/25.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        Text("Hello, World!")
    }

}

#Preview {
    ContentView().environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
}
