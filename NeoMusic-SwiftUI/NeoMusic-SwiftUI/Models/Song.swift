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
    
    let artist: String
    let artwork: UIImage
    let title: String
    let albumTitle: String
    let duration: TimeInterval
    var isFavorite: Bool?
    let isExplicit: Bool
    let persistentID: UInt64
    let storeID: String
    var date: Date
    
    var image: Image {
        Image(uiImage: artwork)
    }
    
    var media: MPMediaItem? {
        let predicate = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyPersistentID)
        let songQuery = MPMediaQuery()
        
        songQuery.addFilterPredicate(predicate)

        var song: MPMediaItem?
        
        if let items = songQuery.items, items.count > 0 {
             song = items[0]
        }
        
        return song
    }
    
    var id: String {
        return persistentID != 0 ? String(persistentID) : "\(artist) - \(title)\(isExplicit ? " - Explicit" : "")"
    }
    
    // MARK: - Initializer
    
    init(_ song: MPMediaItem?, date: Date = Date()) {
        let defaultArtist = "No Artist"
        let defaultImage = UIImage.placeholder
        let defaultTitle = "No Song Selected"
        let defaultAlbum = "No Album"
        let defaultDuration = 0.01
        
        self.date = date
        
        if let song = song {
            artist = song.artist ?? defaultArtist
            title = song.title ?? defaultTitle
            albumTitle = song.albumTitle ?? defaultAlbum
            duration = song.playbackDuration
            isExplicit = song.isExplicitItem
            persistentID = song.persistentID
            storeID = song.playbackStoreID
            
            if let image = song.artwork?.image(at: CGSize(width: 500, height: 500)) {
                artwork = image
            } else {
                artwork = defaultImage
            }
            
        } else {
            artist = defaultArtist
            artwork = defaultImage
            albumTitle = defaultAlbum
            title = defaultTitle
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
