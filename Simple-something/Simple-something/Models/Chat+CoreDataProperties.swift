//
//  Chat+CoreDataProperties.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 13.08.2025.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var name: String?
    @NSManaged public var latestUpdate: Date?
    @NSManaged public var chatMessages: Message?

}

extension Chat : Identifiable {

}

extension Chat {
    static var preview: Chat {
        let result = PreviewHelper.preview
        let viewContext = result.container.viewContext
        let chat = Chat(context: viewContext)
        chat.name = "Test Chat"
        return chat
        
    }
}
