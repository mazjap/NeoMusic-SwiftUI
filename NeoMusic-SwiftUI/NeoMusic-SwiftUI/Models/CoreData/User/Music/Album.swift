//
//  Album.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/17/20.
//

import MediaPlayer
import SwiftUI

struct Album: Identifiable, Equatable {
    
    // MARK: - Variables
    
    var title: String
    var artwork: UIImage
    var id: UInt64
    let items: [MPMediaItem]
    
    var songs: [Song] {
        items.map { Song($0) }
    }
    
    var artist: Artist? {
        guard let id = items.first?.artistPersistentID, let art = Artist.createArtist(for: id) else { return nil }
        return art
    }
    
    // MARK: - Initializers
    
    private init?(id: UInt64) {
        if Self.cache.value(for: id) != nil {
            return nil
        }
        
        var items = [MPMediaItem]()
        
        let query = MPMediaQuery.albums()
        query.addFilterPredicate(MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType:MPMediaPredicateComparison.equalTo))
        
        if let mediaList = query.items {
            items = mediaList
        } else {
            items = []
        }
        
        let item = items.first
        
        self.init(title: item?.albumTitle, artwork: item?.artwork?.image(at: CGSize(width: 500, height: 500)), items: items, id: id)
    }
    
    private init(title: String? = nil, artwork: UIImage? = nil, items: [MPMediaItem] = [], id: UInt64 = 0) {
        if let title = title {
            self.title = title
        } else {
            self.title = Constants.noAlbum
        }
        
        if let artwork = artwork {
            self.artwork = artwork
        } else {
            self.artwork = .placeholder
        }
        
        self.items = items
        self.id = id
    }
    
    // Static Functions
    
    static func createAlbum(for id: UInt64) -> Album? {
        return cache.value(for: id) ?? Album(id: id)
    }
    
    // Static Variables
    
    static let noAlbum = Album()
    
    private static var cache = Cache<UInt64, Album>()
}
