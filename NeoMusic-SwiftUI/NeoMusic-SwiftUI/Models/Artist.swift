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
        self.init(name: item?.artist, albums: tempAlbums , id: id)
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
        return cache.value(for: id) ?? Artist(id: id)
    }
    
    // MARK: - Static Variables
    
    static let noArtist = Artist()
    
    private static var cache = Cache<UInt64, Artist>()
}

extension Artist: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case relationships
        case attributes
        
        enum RelationshipsCodingKeys: String, CodingKey {
            case albums
            
            enum AlbumsCodingKeys: String, CodingKey {
                case data
            }
        }
        
        enum AttributesCodingKeys: String, CodingKey {
            case name
        }
    }
    
    init(from decoder: Decoder) throws {
        var name = Constants.noArtist
        var id: UInt64 = 0
        var albums = [Album]()
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let relationshipsContainer = try container.nestedContainer(keyedBy: CodingKeys.RelationshipsCodingKeys.self, forKey: .relationships)
            let attributesContainer = try container.nestedContainer(keyedBy: CodingKeys.AttributesCodingKeys.self, forKey: .attributes)
            let albumsContainer = try relationshipsContainer.nestedContainer(keyedBy: CodingKeys.RelationshipsCodingKeys.AlbumsCodingKeys.self, forKey: .albums)
            
            name = try attributesContainer.decode(String.self, forKey: .name)
            albums = try albumsContainer.decode([Album].self, forKey: .data)
            
            let storeID = try container.decode(String.self, forKey: .id)
            
            let query = MPMediaQuery(filterPredicates: [MPMediaPropertyPredicate(value: storeID, forProperty: MPMediaItemPropertyPlaybackStoreID, comparisonType:MPMediaPredicateComparison.equalTo)])
            
            if let item = query.items?.first {
                id = item.persistentID
            }
            
        } catch {
            NSLog("Unable to create Artist from json data: \(error)")
        }
        
        self.name = name
        self.id = id
        self.albums = albums
    }
}
