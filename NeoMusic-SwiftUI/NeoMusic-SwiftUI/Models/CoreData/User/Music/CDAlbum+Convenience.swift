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
        self.items = NSOrderedSet(array: album.songs.map { CDSong($0, context: context) })
        self.artwork = album.artwork.pngData()
        if let creator = album.artist {
            self.artist = CDArtist(creator, context: context)
        }
        self.id = Int64(bitPattern: album.id)
    }
}
