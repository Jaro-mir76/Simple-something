//
//  NavigationManager.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 14.08.2025.
//

import Foundation

@Observable
class NavigationManager {
    var chatToEdit: Chat?
    var userName: String
    var userId: String
    let defaultUserName = "Anonymous"
    
    init(chatToEdit: Chat? = nil, userName: String = "Anonymous", userId: String = "") {
        self.chatToEdit = chatToEdit
        self.userName = userName
        self.userId = userId
    }
}
