//
//  CoreDataStack.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 13.08.2025.
//

import Foundation
import CoreData

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error {
                // Handle the error appropriately. However, it's useful to use
                // `fatalError(_:file:line:)` during development.
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private init() {
        
    }
}

extension CoreDataStack {
    func save() {
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            try persistentContainer.viewContext.save()
        }catch {
            print("Failed to save changes: ", error.localizedDescription)
        }
    }
    
    func delete(_ item: Author) {
        persistentContainer.viewContext.delete(item)
        save()
    }
    
    func delete(_ item: Chat) {
        persistentContainer.viewContext.delete(item)
        save()
    }
    
    func delete(_ item: Message) {
        persistentContainer.viewContext.delete(item)
        save()
    }
}
