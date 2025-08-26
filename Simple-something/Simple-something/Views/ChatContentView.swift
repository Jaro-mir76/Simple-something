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
    
    @Environment(NavigationManager.self) private var navigationManager
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
        HStack {
            TextField ("Enter message here...", text: $messageContent)
                .textFieldStyle(.roundedBorder)
                .onSubmit{
                    if !messageContent.isEmpty {
                        withAnimation {
                            addMessage()
                        }
                        isFocused = true
                    }
                }
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
        .padding()
        .frame(maxHeight: 60)
        .background(.gray.opacity(0.1))
        .navigationTitle(chat.name ?? "No name chat")
    }
    
    func addMessage() {
        let newMessage = Message(context: viewContext)
        newMessage.content = messageContent
        newMessage.date = .now
        newMessage.chat = chat
        newMessage.messageAuthor = Author(context: viewContext)
        if navigationManager.userName.isEmpty {
            newMessage.messageAuthor?.name = navigationManager.defaultUserName
        } else {
            newMessage.messageAuthor?.name = navigationManager.userName
        }
        
        newMessage.messageAuthor?.authorID = navigationManager.userId
        
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
}

#Preview {
    ChatContentView(chat: .preview)
        .environment(\.managedObjectContext, PreviewHelper.preview.container.viewContext)
        .environment(NavigationManager())
}
