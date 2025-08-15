//
//  ChatEditView.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 13.08.2025.
//

import SwiftUI

struct ChatEditView: View {
    var chat: Chat?
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(NavigationManager.self) private var navigationManager
    @Environment(\.dismiss) private var dismiss
    @State private var chatName = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Enter name here", text: $chatName)
            } header: {
                Text("Chat title")
            }
        }
        .navigationTitle(chat == nil ? "New chat" : "Edit chat")
        .onAppear(perform: {
            if chat != nil {
                chatName = chat!.name ?? ""
            }
        })
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {
                    saveChat()
                    dismiss()
                }
                .disabled(chatName.isEmpty)
            }
        }
    }
    
    private func saveChat() {
        withAnimation {
            if chat == nil {
                let newChat = Chat(context: viewContext)
                newChat.name = chatName
                newChat.latestUpdate = .now
            } else {
                chat!.name = chatName
            }
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
//            consider better error management
            fatalError("Failed to save data (Core Data): \(error)")
        }
    }
}

#Preview {
    ChatEditView()
        .environment(NavigationManager())
}
