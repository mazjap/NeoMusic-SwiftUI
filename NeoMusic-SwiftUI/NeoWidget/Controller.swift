//
//  Controller.swift
//  NeoWidgetExtension
//
//  Created by Jordan Christensen on 9/2/20.
//

import WidgetKit
import MediaPlayer

class Controller: TimelineEntry {
    private let player: MPMusicPlayerController
    
    let colorScheme: ColorScheme
    var date: Date
    var song: Song {
        player.nowPlayingItem != nil ? Song(player.nowPlayingItem) : .noSong
    }
    
    init(date: Date = Date()) {
        self.date = date
        self.player = .systemMusicPlayer
        self.colorScheme = SettingsController().colorScheme
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
    
    @objc
    func update() {
        WidgetCenter.shared.reloadTimelines(ofKind: NeoWidget.kind)
    }
}
