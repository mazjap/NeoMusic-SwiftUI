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

// MARK: - Helpers

protocol MusicPlayerControllerDelegate: AnyObject {
    func songChanged(previousSong: Song)
}

extension Queue where Type == Song {
    var collection: MPMediaItemCollection {
        MPMediaItemCollection(items: arr.compactMap { $0.media })
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
    
    private var player: MPMusicPlayerController = .systemMusicPlayer
    
    private var queue = Queue<Song>()
    
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
            if currentSong.persistentID != -1 {
                delegate?.songChanged(previousSong: currentSong)
            }
            
            if UIApplication.shared.applicationState == .active {
                objectWillChange.send()
            }
        }
        
        didSet {
            queue.pop()
            
//            if queue.arr.count == 0 {
//                queue.push(getAllSongs())
//            }
        }
    }
    
    @Published var isPlaying: Bool = false
    
    // MARK: - Initializer

    init() {
        checkAuthorized()
        
        queue.delegate = self
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
    
    // MARK: - Queue Functions
    
    func setQueue(with songs: [Song]) {
        queue.clear()
        queue.push(songs)
    }
    
    func addToUpNext(_ song: Song) {
        queue.pushToFront(song)
    }
    
    func addToUpNext(_ songs: [Song]) {
        queue.pushToFront(songs)
    }
    
    func addToUpLater(_ song: Song) {
        queue.push(song)
    }
    
    func addToUpLater(_ songs: [Song]) {
        queue.push(songs)
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

extension MusicPlayerController: QueueDelegate {
//    internal func queueWillChange() {
//        DispatchQueue.main.async {
//            print(self.queue.arr.map { $0.title })
//        }
//    }
    
    internal func queueDidPush() {
        updateQueue()
    }
    
    internal func queueDidPushToFront() {
        updateQueue()
    }
    
    private func updateQueue() {
        guard isAuthorized else { checkAuthorized(); return }
        
        DispatchQueue.main.async {
            let arr = self.queue.arr
            let ids = arr.compactMap { $0.media?.playbackStoreID }
            
            self.player.setQueue(with: ids)
            self.player.prepareToPlay()
            self.player.play()
        }
    }
}
