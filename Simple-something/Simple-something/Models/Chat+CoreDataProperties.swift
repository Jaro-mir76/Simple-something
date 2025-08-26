//
//  Chat+CoreDataProperties.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 19.08.2025.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var latestUpdate: Date?
    @NSManaged public var name: String?
    @NSManaged public var chatMessages: NSSet?
    
    public var updateDate: Date {
        return latestUpdate ?? Date()
    }
    
    public var chatName: String {
        return name ?? "no name"
    }
    
    public var messages: [Message] {
        let set = chatMessages as? Set<Message> ?? []
        return Array(set).sorted { $0.date! < $1.date!}
    }
}

// MARK: Generated accessors for chatMessages
extension Chat {

    @objc(addChatMessagesObject:)
    @NSManaged public func addToChatMessages(_ value: Message)

    @objc(removeChatMessagesObject:)
    @NSManaged public func removeFromChatMessages(_ value: Message)

    @objc(addChatMessages:)
    @NSManaged public func addToChatMessages(_ values: NSSet)

    @objc(removeChatMessages:)
    @NSManaged public func removeFromChatMessages(_ values: NSSet)

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
