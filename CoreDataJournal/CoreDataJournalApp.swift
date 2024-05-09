//
//  CoreDataJournalApp.swift
//  CoreDataJournal
//
//  Created by Parker Rushton on 5/8/24.
//

import SwiftUI

@main
struct CoreDataJournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
