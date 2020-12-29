//
//  CDSong+Convenience.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/21/20.
//

import CoreData

extension CDSong {
    convenience init(_ song: AMSong, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = song.title
        self.duration = song.duration
        self.isExplicit = song.isExplicit
        self.persistentID = Int64(bitPattern: song.persistentID)
        self.storeID = song.storeID
    }
}
