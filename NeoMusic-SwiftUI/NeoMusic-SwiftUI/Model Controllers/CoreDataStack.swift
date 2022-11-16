import CoreData

class CoreDataStack {
    
    // MARK: - Variables
    
    var userContext: NSManagedObjectContext {
        return userContainer.viewContext
    }
    
    lazy var userContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: Constants.coreDataUserModelName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Unable to load persistent store! Error: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // MARK: - Initializers
    
    private init() {
        
    }
    
    // MARK: - Functions
    
    func save(context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error saving context: \(error)")
                context.reset()
            }
        }
    }
    
    // MARK: - Static Variables
    
    static let shared = CoreDataStack()
}
