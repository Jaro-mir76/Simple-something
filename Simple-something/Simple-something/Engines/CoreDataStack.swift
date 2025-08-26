//
//  CoreDataStack.swift
//  Simple-something
//
//  Created by Jaromir Jagieluk on 13.08.2025.
//

import Foundation
import CoreData
import CloudKit

let appTransactionAuthorName = "app"

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    var chats: [Chat] = []
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Model")
        
//      Description of local store
//        let localStoreLocation = URL(filePath: "local.store")
        let localStoreDescription = container.persistentStoreDescriptions.first!
        let storeURL = localStoreDescription.url!.deletingLastPathComponent()
        localStoreDescription.url = storeURL.appending(path: "private.sqlite")
        localStoreDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        localStoreDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
//        localStoreDescription.configuration = "Local"
        
//      Description of cloudKit-backed local store
        guard let cloudStoreDescription = localStoreDescription.copy() as? NSPersistentStoreDescription else {fatalError("Fatal error occured during copying the local store description")}
        
        let containerIdentifier = localStoreDescription.cloudKitContainerOptions!.containerIdentifier
        let cloudStoreOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: containerIdentifier)
        cloudStoreOptions.databaseScope = .shared
        cloudStoreDescription.cloudKitContainerOptions = cloudStoreOptions
        cloudStoreDescription.url = storeURL.appending(path: "shared.sqlite")
//        cloudStoreDescription.configuration = "CloudKit"
//        cloudStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.app.Simple-something")
        
        container.persistentStoreDescriptions = [
            localStoreDescription,
//            cloudStoreDescription
        ]
        
        #if DEBUG
        do {
            // Use the container to initialize the development schema.
            try container.initializeCloudKitSchema(options: [])
        } catch {
            // Handle any errors.
        }
        #endif
        
        container.loadPersistentStores { _, error in
            if let error {
                // Handle the error appropriately. However, it's useful to use
                // `fatalError(_:file:line:)` during development.
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
            
        }
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        container.viewContext.transactionAuthor = appTransactionAuthorName
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
        }
        
        // Observe Core Data remote change notifications.
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(storeRemoteChange(_:)),
//                                               name: .NSPersistentStoreRemoteChange,
//                                               object: container.persistentStoreCoordinator)
        
        NotificationCenter.default.addObserver(self, selector: #selector(storeRemoteChange(_:)), name: .NSPersistentStoreRemoteChange, object: container.persistentStoreCoordinator)
        
        return container
    }()
    
    func fetchData(viewContext: NSManagedObjectContext) -> [Chat]? {
        let chatsFetchRequest: NSFetchRequest<Chat> = Chat.fetchRequest()
        chatsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Chat.latestUpdate, ascending: false)]
        
        do {
            let fetchedChats = try viewContext.fetch(chatsFetchRequest)
            print ("successfully fetched \(fetchedChats.count) chats")
            for chat in fetchedChats {
                print ("\(chat.name) last update: \(chat.latestUpdate)")
            }
            self.chats = fetchedChats
            return fetchedChats
        } catch {
            print("error during fetching Chats: \(error)")
            self.chats = []
            return nil
        }
    }
    
    private lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    /**
     Track the last history token processed for a store, and write its value to file.
     
     The historyQueue reads the token when executing operations and updates it after processing is complete.
     */
    private var lastHistoryToken: NSPersistentHistoryToken? = nil {
        didSet {
            guard let token = lastHistoryToken,
                let data = try? NSKeyedArchiver.archivedData( withRootObject: token, requiringSecureCoding: true) else { return }

            do {
                try data.write(to: tokenFile)
            } catch {
                print("###\(#function): Failed to write token data. Error = \(error)")
            }
        }
    }
    
    private lazy var tokenFile: URL = {
        let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("CoreDataCloudKitDemo", isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("###\(#function): Failed to create persistent container URL. Error = \(error)")
            }
        }
        return url.appendingPathComponent("token.data", isDirectory: false)
    }()
    
    private init() {
        
    }
}

extension CoreDataStack {
    func save() {
        print ("CoreDataStack executing my custome save function")
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

extension CoreDataStack {
    /**
     Handle remote store change notifications (.NSPersistentStoreRemoteChange).
     */
    @objc
    func storeRemoteChange(_ notification: Notification) {
        // Process persistent history to merge changes from other coordinators.
        historyQueue.addOperation {
            self.processPersistentHistory()
        }
    }

    /**
     Process persistent history, posting any relevant transactions to the current view.
     */
    func processPersistentHistory() {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.performAndWait {
            
            // Fetch history received from outside the app since the last token
            let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest!
            historyFetchRequest.predicate = NSPredicate(format: "author != %@", appTransactionAuthorName)
            let request = NSPersistentHistoryChangeRequest.fetchHistory(after: lastHistoryToken)
            request.fetchRequest = historyFetchRequest
            
            let result = (try? taskContext.execute(request)) as? NSPersistentHistoryResult
            guard let transactions = result?.result as? [NSPersistentHistoryTransaction],
                  !transactions.isEmpty
            else { return }
            
            // Post transactions relevant to the current view.
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didFindRelevantTransactions, object: self, userInfo: ["transactions": transactions])
            }
            
            // Deduplicate the new tags.
//            var newTagObjectIDs = [NSManagedObjectID]()
//            let tagEntityName = Tag.entity().name
//            
//            for transaction in transactions where transaction.changes != nil {
//                for change in transaction.changes!
//                where change.changedObjectID.entity.name == tagEntityName && change.changeType == .insert {
//                    newTagObjectIDs.append(change.changedObjectID)
//                }
//            }
//            if !newTagObjectIDs.isEmpty {
//                deduplicateAndWait(tagObjectIDs: newTagObjectIDs)
//            }
            
            // Update the history token using the last transaction.
            lastHistoryToken = transactions.last!.token
        }
    }
    
    
    

    
}

/**
 Custom notifications in this sample.
 */
extension Notification.Name {
    static let didFindRelevantTransactions = Notification.Name("didFindRelevantTransactions")
}
