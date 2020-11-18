//
//  Artist.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/17/20.
//

import MediaPlayer

struct Artist: Identifiable, Equatable {
    
    // MARK: - Variables
    
    let name: String
    let id: UInt64
    let albums: [Album]
    
    var items: [MPMediaItem] {
        var songList = [MPMediaItem]()
        
        for album in albums {
            songList += album.items
        }
        
        return songList
    }
    
    // MARK: - Initializers
    
    init?(id: UInt64) {
        let query = MPMediaQuery.albums()
        query.addFilterPredicate(MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyArtistPersistentID, comparisonType:MPMediaPredicateComparison.equalTo))
        
        let items: [MPMediaItem]
        
        if let mediaList = query.items {
            items = mediaList
        } else {
            items = []
        }
            
        var itemSet = Set<UInt64>()
        for item in items {
            itemSet.insert(item.albumPersistentID)
        }
        
        var tempAlbums = [Album]()
        
        for item in itemSet {
            if let temp = Album.createAlbum(for: item) {
                tempAlbums.append(temp)
            }
        }
        
        let item = items.first
        self.init(name: item?.artist ?? Constants.noArtist, albums: tempAlbums , id: id)
    }
    
    private init(name: String? = nil, albums: [Album] = [], id: UInt64 = 0) {
        if let name = name {
            self.name = name
        } else {
            self.name = Constants.noArtist
        }
        
        self.albums = albums
        self.id = id
    }
    
    // MARK: - Static Functions
    
    static func createArtist(for id: UInt64) -> Artist? {
        if let temp = cache.value(for: id) {
            return temp
        } else if let temp = Artist(id: id) {
            return temp
        }
        
        return nil
    }
    
    // MARK: - Static Variables
    
    static let noArtist = Artist()
    
    private static var cache = Cache<UInt64, Artist>()
}
