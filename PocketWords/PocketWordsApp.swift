//
//  PocketWordsApp.swift
//  PocketWords
//
//  Created by Ashkan Ghaderi on 2/24/1404 AP.
//

import SwiftUI
import SwiftData

@main
struct PocketWordsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WordCard.self,
            UserProgress.self
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
            FlashCardsView()
        }
        .modelContainer(sharedModelContainer)
    }
}
