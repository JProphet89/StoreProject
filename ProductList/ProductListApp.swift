//
//  ProductListApp.swift
//  ProductList
//
//  Created by João Fonseca on 11/10/2022.
//

import SwiftUI

@main
struct ProductListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
