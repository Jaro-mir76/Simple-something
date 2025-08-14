//
//  Author+CoreDataProperties.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 13.08.2025.
//
//

import Foundation
import CoreData


extension Author {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "Author")
    }

    @NSManaged public var name: String?
    @NSManaged public var authorID: String?
    @NSManaged public var authorMessages: Message?

}

extension Author : Identifiable {

}
