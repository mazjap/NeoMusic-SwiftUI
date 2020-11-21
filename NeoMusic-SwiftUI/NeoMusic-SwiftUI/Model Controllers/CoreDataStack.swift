//
//  CoreDataStack.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/20/20.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {
    }
    
    lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: Constants.coreDataModelName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Unable to load persistent store! Error: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error saving context: \(error)")
                context.reset()
            }
        }
    }
}
