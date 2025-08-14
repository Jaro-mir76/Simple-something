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
    
    init(chatToEdit: Chat? = nil) {
        self.chatToEdit = chatToEdit
    }
}
