//
//  MessageView.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 14.08.2025.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    
    var body: some View {
        VStack(alignment: .trailing){
            VStack(alignment: .leading) {
                Text(message.date?.formatted(date: .abbreviated , time: .shortened) ?? "unknown date")
                    .font(.caption2)
                Text(message.content ?? "empty message")
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(message.messageAuthor?.name ?? "unknown author")
                .font(.caption2)
        }
    }
}

#Preview {
    MessageView(message: Message.preview)
}
