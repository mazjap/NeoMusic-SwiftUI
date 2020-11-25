//
//  Song.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Encapsulate song data
//

import WidgetKit
import SwiftUI
import MediaPlayer

struct Song: TimelineEntry, Identifiable, Equatable {
    
    // MARK: - Variables
    
    let title: String
    let duration: TimeInterval
    var isFavorite: Bool?
    var artwork: UIImage
    let artistName: String
    let albumTitle: String
    let isExplicit: Bool
    let persistentID: UInt64
    let storeID: String
    
    var date: Date
    
    var image: Image {
        Image(uiImage: artwork)
    }
    
    var media: MPMediaItem?
    
    var id: UInt64 {
        persistentID
    }
    
    lazy var artist: Artist? = {
        guard let id = media?.artistPersistentID else { return nil }
        return Artist.createArtist(for: id)
    }()
    
    lazy var album: Album? = {
        guard let id = media?.id else { return nil }
        return Album.createAlbum(for: id)
    }()
    
    // MARK: - Initializers
    
    init(_ song: MPMediaItem?, date: Date = Date()) {
        let defaultTitle = Constants.noSong
        let defaultArtist = Constants.noArtist
        let defaultAlbum = Constants.noAlbum
        let defaultDuration = 0.01
        
        self.date = date
        self.media = song
        self.artwork = song?.artwork?.image(at: CGSize(width: 500, height: 500)) ?? .placeholder
        
        if let song = song {
            title = song.title ?? defaultTitle
            artistName = song.artist ?? defaultArtist
            albumTitle = song.albumTitle ?? defaultAlbum
            duration = song.playbackDuration
            isExplicit = song.isExplicitItem
            persistentID = song.persistentID
            storeID = song.playbackStoreID
        } else {
            title = defaultTitle
            artistName = defaultArtist
            albumTitle = defaultAlbum
            duration = defaultDuration
            isExplicit = false
            persistentID = 0
            storeID = ""
        }
    }
    
    // MARK: - Static Variables
    
    static var noSong = Song(nil)
}

extension Song: Decodable {
    enum CodingKeys: String, CodingKey {
        case storeID = "id"
        case persistentID
        case date
        case isFavorite
        case isExplicit
        
        case attributes
    }
    
    enum AttributesCodingKeys: String, CodingKey {
        case artistName
        case title = "name"
        case albumTitle = "albumName"
        case duration = "durationInMillis"
        
        case artwork
    }
    
    enum ArtworkCodingKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        self.date = Date()
        
        var image: UIImage = .placeholder
        var title: String = Constants.noSong
        var artistName: String = Constants.noArtist
        var albumTitle: String = Constants.noAlbum
        var duration: Double = 0
        var isExplicit: Bool = false
        var id: UInt64 = 0
        var storeID: String = ""
        
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let attributesContainer = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
            let artworkContainer = try attributesContainer.nestedContainer(keyedBy: ArtworkCodingKeys.self, forKey: .artwork)
            
            title = try attributesContainer.decode(String.self, forKey: .title)
            artistName = try attributesContainer.decode(String.self, forKey: .artistName)
            albumTitle = try attributesContainer.decode(String.self, forKey: .albumTitle)
            duration = Double(try attributesContainer.decode(Int.self, forKey: .duration)) / 1000
            storeID = try container.decode(String.self, forKey: .storeID)
            let artworkURLString = try artworkContainer.decode(String.self, forKey: .url)
                .replacingOccurrences(of: "{w}", with: "500")
                .replacingOccurrences(of: "{h}", with: "500")
            
            if let url = URL(string: artworkURLString) {
                image = try UIImage(data: Data.init(contentsOf: url)) ?? .placeholder
            }
            
        } catch {
            fatalError(error.localizedDescription)
        }
        
        if let item = MPMediaQuery(filterPredicates: [MPMediaPropertyPredicate(value: storeID, forProperty: MPMediaItemPropertyPlaybackStoreID, comparisonType: .equalTo)]).items?.first {
            isExplicit = item.isExplicitItem
            id = item.persistentID
        }
        
        self.artwork = image
        self.title = title
        self.albumTitle = albumTitle
        self.artistName = artistName
        self.duration = duration
        self.isExplicit = isExplicit
        self.persistentID = id
        self.storeID = storeID
    }
}
