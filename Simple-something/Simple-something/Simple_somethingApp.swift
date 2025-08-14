//
//  Simple_somethingApp.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 12.08.2025.
//

import SwiftUI

@main
struct Simple_somethingApp: App {
    @State private var coreDataStack = CoreDataStack.shared
    @State private var navigationManager = NavigationManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
                .environment(navigationManager)
        }
    }
}
