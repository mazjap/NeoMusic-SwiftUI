//
//  MusicPlayerController.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Control system music player
//

import MediaPlayer

extension Queue where Type: MPMediaItem {
    var collection: MPMediaItemCollection {
        MPMediaItemCollection(items: arr)
    }
}

class MusicPlayerController: ObservableObject {
    var isAuthorized = false {
        didSet {
            if isAuthorized {
                setup()
            }
        }
    }
    let player = MPMusicPlayerController.systemMusicPlayer
    var queue = Queue<Song>()

    @Published var currentSong: Song = Song.noSong {
        willSet {
            if UIApplication.shared.applicationState == .active {
                objectWillChange.send()
            }
        }
    }
    @Published var isPlaying: Bool = false

    var currentPlaybackTime: TimeInterval {
        player.currentPlaybackTime
    }

    var totalPlaybackTime: TimeInterval {
        return currentSong.duration
    }

    init() {
        checkAuthorized()
    }
    
    private func setup() {
        player.beginGeneratingPlaybackNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(songChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStatusChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        
        if !player.isPreparedToPlay {
            player.prepareToPlay()
        }
        
        playbackStatusChanged()
        songChanged()
    }
    
    func checkAuthorized() {
        switch MPMediaLibrary.authorizationStatus() {
        case .authorized, .restricted:
            isAuthorized = true
        case .notDetermined:
            MPMediaLibrary.requestAuthorization { [weak self] auth in
                guard let self = self else { return }
                
                if auth != .authorized && auth != .restricted {
                    self.isAuthorized = true
                }
            }
        case .denied:
            fallthrough
        @unknown default:
            // Alert user that access hasn't been granted
            // User is given the option to dismiss or open settings
            let alert = UIAlertController(title: "Apple Music Access Denied", message: "To use Apple music with this app, you must allow access in settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
                guard let appSettingsURL = URL(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(appSettingsURL) else { return }
                
                UIApplication.shared.open(appSettingsURL) { didOpen in
                    if didOpen {
                        NSLog("App settings opened successfully")
                    } else {
                        NSLog("Failed to open app settings @f\(#file)l\(#line)")
                    }
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            NSLog("Access to Apple Music is denied or unknown case \(Constants.codeLineLocation)")
            UIApplication.present(alert, animated: true)
        }
    }
    
    func pause() {
        if !isAuthorized { checkAuthorized(); return }
        
        player.pause()
    }

    func play() {
        if !isAuthorized { checkAuthorized(); return }
        
        player.play()
    }

    func setQueue(songs: [Song]) {
        if !isAuthorized { checkAuthorized(); return }
        
        queue = Queue(songs)
        updateQueue()
    }

    func set(time: TimeInterval) {
        if !isAuthorized { checkAuthorized(); return }
        
        player.currentPlaybackTime = time
    }

    func toggle() {
        if !isAuthorized { checkAuthorized(); return }
        
        isPlaying ? pause() : play()
    }

    func skipToPreviousItem() {
        if !isAuthorized { checkAuthorized(); return }
        
        if currentPlaybackTime <= 5 {
            player.skipToPreviousItem()
        } else {
            set(time: 0)
        }
    }

    func skipToNextItem() {
        if !isAuthorized { checkAuthorized(); return }
        
        player.skipToNextItem()
    }
    
    func addToUpNext(_ song: Song) {
        addToUpNext([song])
    }
    
    func addToUpNext(_ songs: [Song]) {
        if !isAuthorized { checkAuthorized(); return }
        
        queue.push(songs)
        updateQueue()
    }
    
    private func updateQueue() {
        player.setQueue(with: MPMediaItemCollection(items: queue.arr.compactMap { $0.media! } ))
    }

    @objc
    private func playbackStatusChanged() {
        DispatchQueue.main.async {
            self.isPlaying = self.player.playbackState == .playing
        }
    }

    @objc func songChanged() {
        guard let media = player.nowPlayingItem else { return }
        DispatchQueue.main.async {
            self.currentSong = Song(media)
        }
    }
}
