//
//  ChatContentView.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 13.08.2025.
//

import SwiftUI
import CoreData

struct ChatContentView: View {
    var chat: Chat
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest
    private var messages: FetchedResults<Message>
    @State private var messageContent = ""
    @FocusState private var isFocused: Bool
    
    init(chat: Chat){
        self.chat = chat
        _messages = FetchRequest<Message>(sortDescriptors: [.init(\.date)], predicate: NSPredicate(format: "(chat == %@)", chat))
    }
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            List {
                ForEach(messages) { message in
                    MessageView(message: message)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            deleteMessage(message)
                        } label: {
                            Label("Delete", systemImage: "minus.circle")
                        }
                        .tint(.red)
                    }
                }
            }
            .onChange(of: messages.count) {
                if let last = messages.last {
                    scrollProxy.scrollTo(last.id)
                }
            }
        }
        Form {
            HStack {
                TextField("Enter message here...", text: $messageContent)
                    .focused($isFocused)
                    .task {
                        isFocused = true
                    }
                Button(action: {
                    withAnimation {
                        addMessage()
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .accessibilityLabel("Add message")
                }
                .disabled(messageContent.isEmpty)
            }
        }
        .frame(maxHeight: 80)
        .navigationTitle(chat.name ?? "No name chat")
    }
    
    func addMessage() {
        let newMessage = Message(context: viewContext)
        newMessage.content = messageContent
        newMessage.date = .now
        newMessage.chat = chat
        newMessage.messageAuthor = Author(context: viewContext)
        newMessage.messageAuthor?.name = "Jaro"
        newMessage.messageAuthor?.authorID = "JaroID"
        
        do {
            try viewContext.save()
            chat.latestUpdate = .now
        } catch {
            fatalError("Failed to save message (Core Data): \(error.localizedDescription)")
        }
        
        messageContent = ""
    }
    
    func deleteMessage(_ message: Message) {
        viewContext.delete(message)
        do {
            try viewContext.save()
            chat.latestUpdate = .now
            print ("successfully saved context after deleting message")
        } catch {
            fatalError("Could not save contex after deleting message: \(error.localizedDescription)")
        }
    }
    
//    func scrollToBottom(messages: [Message], proxy: ScrollViewProxy){
//        if let lastMessage = messages.last {
//            proxy.scrollTo(lastMessage.id)
//        }
//    }
}

#Preview {
    ChatContentView(chat: .preview)
        .environment(\.managedObjectContext, PreviewHelper.preview.container.viewContext)
}
