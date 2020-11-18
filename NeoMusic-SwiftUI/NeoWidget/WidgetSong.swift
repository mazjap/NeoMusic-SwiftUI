//
//  WidgetSong.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/18/20.
//

import WidgetKit
import MediaPlayer

struct WidgetSong: TimelineEntry {
    var title: String
    var artistName: String
    var artwork: UIImage
    var isExplicit: Bool
    
    var date: Date
    
    init(_ media: MPMediaItem, date: Date) {
        self.title = media.title ?? Constants.noSong
        self.artistName = media.artist ?? Constants.noArtist
        self.artwork = media.artwork?.image(at: CGSize(width: 200, height: 200)) ?? .placeholder
        self.isExplicit = media.isExplicitItem
        
        self.date = date
    }
    
    private init(date: Date) {
        self.title = Constants.noSong
        self.artistName = Constants.noArtist
        self.artwork = .placeholder
        self.isExplicit = false
        
        self.date = Date(timeIntervalSince1970: 0)
    }
    
    static func noSong(date: Date = Date(timeIntervalSince1970: 0)) -> WidgetSong {
        WidgetSong(date: date)
    }
}
