//
//  Author+CoreDataProperties.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 19.08.2025.
//
//

import Foundation
import CoreData


extension Author {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "Author")
    }

    @NSManaged public var authorID: String?
    @NSManaged public var name: String?
    @NSManaged public var authorMessages: NSSet?

}

// MARK: Generated accessors for authorMessages
extension Author {

    @objc(addAuthorMessagesObject:)
    @NSManaged public func addToAuthorMessages(_ value: Message)

    @objc(removeAuthorMessagesObject:)
    @NSManaged public func removeFromAuthorMessages(_ value: Message)

    @objc(addAuthorMessages:)
    @NSManaged public func addToAuthorMessages(_ values: NSSet)

    @objc(removeAuthorMessages:)
    @NSManaged public func removeFromAuthorMessages(_ values: NSSet)

}

extension Author : Identifiable {

}
