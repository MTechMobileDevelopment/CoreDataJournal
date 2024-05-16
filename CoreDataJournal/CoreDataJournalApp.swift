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
            JournalsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")

                }
        }
    }
}
