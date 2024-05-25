//
//  Journal.swift
//  CoreDataJournal
//
//  Created by Parker Rushton on 5/25/24.
//
//

import Foundation
import SwiftData

@Model class Journal {
    var colorHex: String?
    var createdAt: Date
    var id: String
    var title: String
    @Relationship(deleteRule: .cascade, inverse: \Entry.journal) var entries = [Entry]()

    init(title: String, colorHex: String?) {
        self.id = UUID().uuidString
        self.createdAt = Date()
        self.title = title
        self.colorHex = colorHex
    }

}
