//
//  Controller.swift
//  NeoWidgetExtension
//
//  Created by Jordan Christensen on 9/2/20.
//

import WidgetKit
import MediaPlayer

class Controller {
    private let player: MPMusicPlayerController
    
    let colorScheme: JCColorScheme
    
    init(date: Date = Date()) {
        self.player = .systemMusicPlayer
        self.colorScheme = SettingsController.shared.colorScheme
        
        player.beginGeneratingPlaybackNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
    
    func getSong(with date: Date = Date()) -> Song {
        if let media = player.nowPlayingItem {
            return Song(media, date: date)
        }
        
        return .noSong
    }
    
    @objc
    func update() {
        WidgetCenter.shared.reloadTimelines(ofKind: NeoWidget.kind)
    }
}
