//
//  JournalController.swift
//  CoreDataJournal
//
//  Created by Parker Rushton on 5/9/24.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

@Observable
class JournalController {

    static let shared = JournalController()

    private var viewContext: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }

    func createNewEntry(in journal: Journal, title: String, body: String, image: UIImage?) {
        let entry = Entry(context: viewContext)
        entry.id = UUID().uuidString
        entry.title = title
        entry.body = body
        entry.createdAt = Date()
        if let image {
            entry.imageData = image.jpegData(compressionQuality: 0.75)
        }
        entry.journal = journal
        saveContext()
    }

    func updateEntry(entry: Entry, title: String, body: String, image: UIImage?) {
        entry.title = title
        entry.body = body
        if let image {
            entry.imageData = image.jpegData(compressionQuality: 0.75)
        }
        saveContext()
    }

    func createNewJournal(title: String, color: Color) {
        let journal = Journal(context: viewContext)
        journal.id = UUID().uuidString
        journal.title = title
        journal.createdAt = Date()
        journal.colorHex = color.toHexString()

        saveContext()
    }

    func saveContext() {
        try? viewContext.save()
    }

}
