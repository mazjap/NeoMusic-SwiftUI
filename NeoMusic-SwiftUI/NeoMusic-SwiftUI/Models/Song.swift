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
    let artwork: UIImage
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
    
    // MARK: - Initializer
    
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

extension Song {//: Decodable {
    enum CodingKeys: String, CodingKey {
        case artwork
        case artist
        case title
        case albumTitle
        case duration
        case isFavorite
        case isExplicit
        case persistentID
        case storeID
        case date
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try? decoder.container(keyedBy: CodingKeys.self)
//        
//    }
}
