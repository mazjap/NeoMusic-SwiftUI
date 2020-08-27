//
//  MusicController.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Control system music player
//

import MediaPlayer

class MusicController: ObservableObject {
    let player = MPMusicPlayerController.systemMusicPlayer

    @Published var currentSong: Song = Song.noSong
    @Published var isPlaying: Bool = false

    var currentPlaybackTime: TimeInterval {
        player.currentPlaybackTime
    }

    var totalPlaybackTime: TimeInterval {
        return currentSong.duration
    }

    init() {
        player.beginGeneratingPlaybackNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(songChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStatusChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        
        playbackStatusChanged()
        songChanged()
    }

    func prepareToPlay() {
        player.prepareToPlay()
    }
    
    func pause() {
        player.pause()
    }

    func play() {
        player.play()
    }

    func setQueue(songs: [Song]) {
        player.setQueue(with: MPMediaItemCollection(items: songs.filter({ $0.media != nil }).map({ $0.media! })))
    }

    func set(time: TimeInterval) {
        player.currentPlaybackTime = time
    }

    func toggle() {
        isPlaying ? pause() : play()
    }

    func skipToPreviousItem() {
        player.skipToPreviousItem()
    }

    func skipToNextItem() {
        player.skipToNextItem()
    }

    @objc
    private func playbackStatusChanged() {
        isPlaying = player.playbackState == .playing
    }

    @objc func songChanged() {
        guard let media = player.nowPlayingItem else { return }

        currentSong = Song(media)
    }
}

