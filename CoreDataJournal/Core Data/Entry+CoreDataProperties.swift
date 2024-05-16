//
//  Entry+CoreDataProperties.swift
//  CoreDataJournal
//
//  Created by Parker Rushton on 5/13/24.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var body: String
    @NSManaged public var createdAt: Date
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var imageData: Data?
    @NSManaged public var journal: Journal?

}

extension Entry : Identifiable {

}
