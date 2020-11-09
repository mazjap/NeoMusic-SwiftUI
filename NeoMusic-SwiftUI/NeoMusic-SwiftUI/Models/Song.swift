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
    let artwork: Image
    let title: String
    let albumTitle: String
    let duration: TimeInterval
    let media: MPMediaItem?
    var isFavorite: Bool?
    let isExplicit: Bool
    let persistentID: UInt64
    var date: Date
    
    var id: String {
        return persistentID != 0 ? String(persistentID) : "\(artist) - \(title)\(isExplicit ? " - Explicit" : "")"
    }
    
    // MARK: - Initializer
    
    init(_ song: MPMediaItem?, date: Date = Date()) {
        let defaultArtist = "No Artist"
        let defaultImage = Image.placeholder
        let defaultTitle = "No Song Selected"
        let defaultAlbum = "No Album"
        let defaultDuration = 0.01
        
        self.date = date
        
        if let song = song {
            artist = song.artist ?? defaultArtist
            title = song.title ?? defaultTitle
            albumTitle = song.albumTitle ?? defaultAlbum
            duration = song.playbackDuration
            media = song
            isExplicit = song.isExplicitItem
            persistentID = song.persistentID
            
            if let image = song.artwork?.image(at: CGSize(width: 500, height: 500)) {
                artwork = Image(uiImage: image)
            } else {
                artwork = defaultImage
            }
        } else {
            artist = defaultArtist
            artwork = defaultImage
            albumTitle = defaultAlbum
            title = defaultTitle
            duration = defaultDuration
            media = MPMediaItem()
            isExplicit = false
            persistentID = 0
        }
    }
    
    // MARK: - Static Variables
    
    static var noSong = Song(nil)
}
