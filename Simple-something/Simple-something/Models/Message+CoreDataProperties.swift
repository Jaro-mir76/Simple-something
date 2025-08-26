//
//  Message+CoreDataProperties.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 19.08.2025.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var chat: Chat?
    @NSManaged public var messageAuthor: Author?

}

extension Message : Identifiable {

}

extension Message {
    static var preview: Message {
        let result = PreviewHelper.preview
        let viewContext = result.container.viewContext
        let chat = Chat(context: viewContext)
        chat.name = "Test Chat"
        chat.latestUpdate = .now
        
        let message = Message(context: viewContext)
        message.content = "Hello, world!"
        message.date = .now
        message.chat = chat
        
        let author = Author(context: viewContext)
        author.name = "Jaro"
        author.authorID = "secretID"
        message.messageAuthor = author
        
        return message
        
    }
}
