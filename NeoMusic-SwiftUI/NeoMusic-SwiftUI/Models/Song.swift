//
//  Song.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Encapsulate song data
//

import SwiftUI
import MediaPlayer

struct Song: Identifiable, Equatable {
    let artist: String
    let artwork: Image
    let title: String
    let albumTitle: String
    let duration: TimeInterval
    let media: MPMediaItem?
    var isFavorite: Bool?
    var isExplicit: Bool
    
    var id: String {
        "\(artist) - \(title)\(isExplicit ? " - Explicit" : "")"
    }
    
    init(_ song: MPMediaItem?) {
        let defaultArtist = "No Artist"
        let defaultImage = Image.placeholder
        let defaultTitle = "No Song Selected"
        let defaultAlbum = "No Album"
        let defaultDuration = 0.01
        
        if let song = song {
            artist = song.artist ?? defaultArtist
            title = song.title ?? defaultTitle
            albumTitle = song.albumTitle ?? defaultAlbum
            duration = song.playbackDuration
            media = song
            isExplicit = song.isExplicitItem
            
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
        }
    }
    
    static var noSong = Song(nil)
}
