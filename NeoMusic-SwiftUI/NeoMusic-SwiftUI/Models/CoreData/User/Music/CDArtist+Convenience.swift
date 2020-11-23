//
//  CDArtist+Convenience.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/21/20.
//

import CoreData

extension CDArtist {
    convenience init(_ artist: Artist, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = artist.name
        self.albums = NSSet(array: artist.albums.map { CDAlbum($0, context: context) })
        self.id = Int64(bitPattern: artist.id)
    }
}
