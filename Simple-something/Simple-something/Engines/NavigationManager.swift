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
//    private var user: String
    var userName: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "userName")
        }
        get {
            if let user = UserDefaults.standard.string(forKey: "userName") {
                return user
            } else {
                return defaultUserName
            }
        }
    }
    var userId: String
    let defaultUserName = "Anonymous"
    var chats: [Chat]
    
    init(chatToEdit: Chat? = nil, userId: String = "", chats: [Chat] = []) {
        self.chatToEdit = chatToEdit
//        self.user = user
        self.userId = userId
        self.chats = chats
    }
    func refreshTest() {
        print ("This is refreshTest func exectuion")
    }
}
