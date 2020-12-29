//
//  CDAlbum+Convenience.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/21/20.
//

import CoreData

extension CDAlbum {
    convenience init(_ album: Album, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = album.title
        self.items = NSOrderedSet(array:  album.items.map { CDSong(($0 as? AMSong)!, context: context) })
        self.albumArtwork = album.artwork.pngData()
        self.persistentID = Int64(bitPattern: album.persistentID)
    }
}
