//
//  ChatListView.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 21.08.2025.
//

import SwiftUI

struct ChatListView: View {
    var chat: Chat
    var body: some View {
        VStack(alignment: .trailing){
            VStack(alignment: .leading) {
//                Text(chat.latestUpdate?.formatted(date: .abbreviated , time: .shortened) ?? "unknown date")
//                    .font(.caption2)
                Text(chat.chatName)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(chat.updateDate.formatted(date: .numeric , time: .shortened))
                .font(.caption2)
        }
    }
}

#Preview {
    ChatListView(chat: Chat.preview)
}
