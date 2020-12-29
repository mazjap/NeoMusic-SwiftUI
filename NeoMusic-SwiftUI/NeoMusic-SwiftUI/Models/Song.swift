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

// MARK: - Generic Song

protocol Song {
    var title: String { get }
    var artist: String { get }
    var album: String { get }
    var duration: TimeInterval { get }
    var isExplicit: Bool { get }
    
    var albumArtwork: UIImage { get }
    
    var id: String { get }
    var artistID: String { get }
    var albumID: String { get }
}

extension Song {
    var image: Image {
        Image(uiImage: albumArtwork)
    }
}

// MARK: - Apple Music Song

struct AMSong: Song, TimelineEntry, Identifiable {
    
    // MARK: - Variables
    
    let title: String
    let duration: TimeInterval
    var albumArtwork: UIImage
    let artist: String
    let album: String
    let isExplicit: Bool
    let storeID: String
    
    var date: Date
    var id: String
    var artistID: String
    var albumID: String
    
    var persistentID: UInt64 {
        UInt64(id) ?? 0
    }
    
    var artistPersistentID: UInt64 {
        UInt64(artistID) ?? 0
    }
    
    var albumPersistentID: UInt64 {
        UInt64(albumID) ?? 0
    }
    
    var media: MPMediaItem?
    
    #if os(watchOS)
    var widgetSong: WidgetSong {
        if let media = media {
            return WidgetSong(media)
        }
        
        return .noSong()
    }
    #endif
    
    // MARK: - Initializers
    
    init(_ song: MPMediaItem?, date: Date = Date()) {
        let defaultTitle = Constants.noSong
        let defaultArtist = Constants.noArtist
        let defaultAlbum = Constants.noAlbum
        let defaultDuration = 0.01
        
        self.date = date
        self.media = song
        self.albumArtwork = song?.artwork?.image(at: CGSize(width: 500, height: 500)) ?? .placeholder
        
        if let song = song {
            title = song.title ?? defaultTitle
            artist = song.artist ?? defaultArtist
            album = song.albumTitle ?? defaultAlbum
            duration = song.playbackDuration
            isExplicit = song.isExplicitItem
            id = "\(song.persistentID)"
            artistID = "\(song.artistPersistentID)"
            albumID = "\(song.albumPersistentID)"
            storeID = "\(song.playbackStoreID)"
        } else {
            title = defaultTitle
            artist = defaultArtist
            album = defaultAlbum
            duration = defaultDuration
            isExplicit = false
            id = ""
            artistID = ""
            albumID = ""
            storeID = ""
        }
    }
    
    init(id: UInt64) {
        self.init(MPMediaQuery(filterPredicates: [MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)]).items?.first)
    }
    
    // MARK: - Static Variables
    
    static var noSong = AMSong(nil)
}

extension AMSong: Decodable {
    enum CodingKeys: String, CodingKey {
        case storeID = "id"
        case id = "persistentID"
        case date
        case isExplicit
        
        case attributes
    }
    
    enum AttributesCodingKeys: String, CodingKey {
        case artist = "artistName"
        case title = "name"
        case album = "albumName"
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
            artistName = try attributesContainer.decode(String.self, forKey: .artist)
            albumTitle = try attributesContainer.decode(String.self, forKey: .album)
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
        
        self.albumArtwork = image
        self.title = title
        self.album = albumTitle
        self.artist = artistName
        self.duration = duration
        self.isExplicit = isExplicit
        self.id = "\(id)"
        // TODO: - Fix these
        self.artistID = "\(id)"
        self.albumID = "\(id)"
        //
        self.storeID = storeID
    }
}
