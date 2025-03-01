//
//  PassMateApp.swift
//  PassMate
//
//  Created by Ryan Jones on 3/1/25.
//

import SwiftUI

@main
struct PassMateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
