//
//  PreviewHelper.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 13.08.2025.
//

import Foundation
import CoreData

struct PreviewHelper {
    
    init(inMemory: Bool = false){
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions.first!.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        }
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Fatal error during loading persistent stores for preview: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    static let shared = PreviewHelper()
    
    static var preview: PreviewHelper = {
        let result = PreviewHelper(inMemory: true)
        let viewContext = result.container.viewContext
        
        let newChat = Chat(context: viewContext)
        newChat.name = "Bla bla bla"
        newChat.latestUpdate = Date()
        
        do {
            try viewContext.save()
        } catch {
            fatalError("Failed to save (preview Helper): \(error)")
        }
        
        return result
    }()
    
    let container: NSPersistentContainer
    
   
}
