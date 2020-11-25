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
        query.addFilterPredicate(MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo))
        
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

extension Album: Decodable {
    enum CodingKeys: String, CodingKey {
        case attributes
    }
    
    enum AttributesCodingKeys: String, CodingKey {
        case title = "name"
        case id
        case items
        
        case artwork
    }
    
    enum ArtworkCodingKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        var title: String = Constants.noAlbum
        var image: UIImage = .placeholder
        var id: UInt64 = 0
        var items = [MPMediaItem]()
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let attributesContainer = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
            let artworkContainer = try attributesContainer.nestedContainer(keyedBy: ArtworkCodingKeys.self, forKey: .artwork)
            
            let urlString = try artworkContainer.decode(String.self, forKey: .url)
                .replacingOccurrences(of: "{w}", with: "500")
                .replacingOccurrences(of: "{h}", with: "500")
            
            
            if let url = URL(string: urlString), let img = try UIImage(data: Data(contentsOf: url)) {
                image = img
            }
            
            title = try attributesContainer.decode(String.self, forKey: .title)
            
            let storeID = try attributesContainer.decode(String.self, forKey: .id)
            
            let query = MPMediaQuery(filterPredicates: [MPMediaPropertyPredicate(value: storeID, forProperty: MPMediaItemPropertyPlaybackStoreID, comparisonType: .equalTo)])
            
            if let item = query.items?.first {
                id = item.persistentID
                items = MPMediaQuery(filterPredicates: [MPMediaPropertyPredicate(value: item.albumPersistentID, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)]).items ?? []
            }
        
        } catch {
            
        }
        
        self.title = title
        self.artwork = image
        self.id = id
        self.items = items
    }
}
