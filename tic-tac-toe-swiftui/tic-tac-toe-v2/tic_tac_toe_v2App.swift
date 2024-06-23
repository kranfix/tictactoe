//
//  tic_tac_toe_v2App.swift
//  tic-tac-toe-v2
//
//  Created by Guerin Steven Colocho Chacon on 22/06/24.
//

import SwiftUI
import SwiftData

@main
struct tic_tac_toe_v2App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
