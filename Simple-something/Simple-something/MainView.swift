//
//  ContentView.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 12.08.2025.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(NavigationManager.self) private var navigationManager
    @FetchRequest(sortDescriptors: [SortDescriptor(\.latestUpdate, order: .reverse)], animation: .default)
    private var chats: FetchedResults<Chat>
    @State private var selectedChat: Chat?
    @State private var showAddChat = false
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedChat) {
                ForEach(chats) { chat in
                    NavigationLink(value: chat) {
                        Text(chat.name ?? "no name")
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    deleteChat(chat)
                                } label: {
                                    Label("Delete", systemImage: "minus.circle")
                                }
                                .tint(.red)

                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    navigationManager.chatToEdit = chat
                                    showAddChat = true
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.green)
                            }
                    }
                }
            }
            .overlay {
                if chats.isEmpty {
                    Text("There is not chats, you can create one using + button.")
                        .font(.title3)
                }
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        navigationManager.chatToEdit = nil
                        showAddChat = true
                    } label: {
                        Label("New chat", systemImage: "plus")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        } detail: {
            if let selectedChat = selectedChat {
                NavigationStack {
                    ChatContentView(chat: selectedChat)
                }
            }
        }
        .sheet(isPresented: $showAddChat) {
            NavigationStack {
                ChatEditView(chat: navigationManager.chatToEdit)
            }
            .presentationDetents([.medium, .large])
        }
    }
    
    func deleteChat(_ chat: Chat) {
        viewContext.delete(chat)
        do {
            try viewContext.save()
            print ("successfully saved context after deleting chat")
        } catch {
            fatalError("Could not save contex after deleting chat: \(error.localizedDescription)")
        }
    }
}

#Preview {
    MainView()
}
