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

// MARK: - MusicPlayerControllerDelegate

protocol MusicPlayerControllerDelegate: AnyObject {
    func songChanged(previousSong: Song)
}

extension Array where Element == Song {
    var mediaItems: [MPMediaItem] {
        self.compactMap { $0.media }
    }
}

// MARK: - MusicPlayerController

class MusicPlayerController: ObservableObject {
    
    // MARK: - Variables
    
    private var isAuthorized = false {
        didSet {
            if isAuthorized && oldValue != isAuthorized { setup() }
        }
    }
    
    private var player: MPMusicPlayerController = .systemMusicPlayer {
        didSet {
            dynamicPlayer = Dynamic(player)
        }
    }
    
    private var dynamicPlayer: Dynamic
    
    var currentPlaybackTime: TimeInterval {
        player.currentPlaybackTime
    }

    var totalPlaybackTime: TimeInterval {
        return currentSong.duration
    }
    
    // MARK: - MusicPlayerControllerDelegate
    
    weak var delegate: MusicPlayerControllerDelegate?
    
    // MARK: - Published Variables

    @Published var currentSong: Song = Song.noSong {
        willSet {
            if UIApplication.shared.applicationState == .active {
                objectWillChange.send()
            }
        }
        
        didSet {
            if oldValue.persistentID != 0 {
                delegate?.songChanged(previousSong: oldValue)
            }
        }
    }
    
    @Published var isPlaying: Bool = false
    
    // MARK: - Initializer

    init() {
        dynamicPlayer = Dynamic(player)
        checkAuthorized()
        
        print(upNextSongs.map { $0.title })
    }
    
    // MARK: - Private Functions
    
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
    
    private func checkAuthorized() {
        switch MPMediaLibrary.authorizationStatus() {
        case .authorized, .restricted:
            isAuthorized = true
        case .notDetermined:
            MPMediaLibrary.requestAuthorization { [weak self] auth in
                guard let self = self else { return }
                
                if auth == .authorized || auth == .restricted {
                    self.isAuthorized = true
                }
            }
            if !isAuthorized {
                fallthrough
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
            NSLog("f:\(#file)l:\(#line) Error: Access to Apple Music is denied or unknown case")
            UIApplication.present(alert, animated: true)
        }
    }
    
    private func getAllSongs(shuffled: Bool = true) -> [Song] {
        var songs = [Song]()
        
        for collection in MPMediaQuery.songs().collections ?? [] {
            for item in collection.items {
                songs.append(Song(item))
            }
        }
        
        return shuffled ? songs.shuffled() : songs
    }
    
    private func pause() {
        guard isAuthorized else { checkAuthorized(); return }
        
        player.pause()
    }

    private func play() {
        guard isAuthorized else { checkAuthorized(); return }
        
        player.play()
    }
    
    // MARK: - Music Control Functions & Public Functions

    func set(time: TimeInterval) {
        guard isAuthorized else { checkAuthorized(); return }
        
        player.currentPlaybackTime = time
    }

    func toggle() {
        guard isAuthorized else { checkAuthorized(); return }
        
        isPlaying ? pause() : play()
    }

    func skipToPreviousItem() {
        guard isAuthorized else { checkAuthorized(); return }
        
        if currentPlaybackTime <= 5 {
            player.skipToPreviousItem()
        } else {
            set(time: 0)
        }
    }

    func skipToNextItem() {
        guard isAuthorized else { checkAuthorized(); return }
        
        player.skipToNextItem()
    }
    
    func setQueue(with songs: [Song]) {
        guard isAuthorized else { checkAuthorized(); return }
        
        DispatchQueue.main.async {
            let ids = songs.compactMap { $0.storeID }
            
            self.player.setQueue(with: ids)
            self.player.prepareToPlay()
            self.player.play()
        }
    }
    
    func addToUpNext(_ song: Song) {
        addToUpNext([song])
    }
    
    func addToUpNext(_ songs: [Song]) {
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: songs.mediaItems))

        player.prepend(descriptor)
    }
    
    func addToUpLater(_ song: Song) {
        addToUpLater([song])
    }
    
    func addToUpLater(_ songs: [Song]) {
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: songs.mediaItems))

        player.append(descriptor)
    }
    
    // MARK: - Objective-C Functions

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

// MARK: - MusicPlayerController Extension: Dynamic Player

extension MusicPlayerController {
    private var songCount: Int {
        return dynamicPlayer.numberOfItems.unwrapped() ?? 0
    }
    
    private var currentIndex: Int {
        return player.indexOfNowPlayingItem
    }
    
    var upNextSongs: [Song] {
        guard songCount > currentIndex else { return [] }
        
        var temp = [Song]()
        
        for i in currentIndex..<songCount {
            if let media = item(at: i) {
                temp.append(Song(media))
            }
        }
        
        return temp
    }
    
    private func item(at index: Int) -> MPMediaItem? {
        if let item: MPMediaItem = dynamicPlayer.nowPlayingItemAt(index: index).unwrapped() {
            return item
        }
        
        return nil
    }
}


