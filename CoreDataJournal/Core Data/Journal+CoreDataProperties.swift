//
//  Journal+CoreDataProperties.swift
//  CoreDataJournal
//
//  Created by Parker Rushton on 5/14/24.
//
//

import Foundation
import CoreData
import UIKit

extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var colorHex: String?
    @NSManaged public var entries: NSSet?

}

// MARK: Generated accessors for entries
extension Journal {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: Entry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: Entry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}

extension Journal : Identifiable {
    var entriesArray: [Entry] {
        guard let all = entries?.allObjects as? [Entry] else { return [] }
        return Array(all)
    }
}
