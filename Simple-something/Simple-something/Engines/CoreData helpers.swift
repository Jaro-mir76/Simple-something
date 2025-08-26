//
//  CoreData helpers.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 22.08.2025.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func customeSave() {
        guard hasChanges else { return }
        
        do {
            try save()
        }catch {
            print("Failed to save changes: ", error.localizedDescription)
        }
    }
}
