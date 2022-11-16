import CoreData

extension CDArtist {
    convenience init(_ artist: Artist, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = artist.name
        self.persistentID = Int64(bitPattern: artist.persistentID)
    }
}
