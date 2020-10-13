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

protocol MusicPlayerControllerDelegate: AnyObject {
    func songChanged(previousSong: Song)
}

extension Queue where Type == Song {
    var collection: MPMediaItemCollection {
        MPMediaItemCollection(items: arr.compactMap { $0.media })
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
    
    private lazy var player: MPMusicPlayerController = { MPMusicPlayerController.applicationQueuePlayer }()
    
    var queue = Queue<Song>() {
        didSet {
            updateQueue()
        }
    }
    
    weak var delegate: MusicPlayerControllerDelegate?

    @Published var currentSong: Song = Song.noSong {
        willSet {
            if currentSong.persistentID != -1 {
                delegate?.songChanged(previousSong: currentSong)
            }
            
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
    }
    
    private func updateQueue() {
        guard queue.arr.count > 0 else { return }
        
        let filterPredicates = Set<MPMediaPropertyPredicate>(queue.arr.filter { $0.persistentID != 0 }.map { MPMediaPropertyPredicate(value: $0.persistentID, forProperty: MPMediaItemPropertyPersistentID) })
        
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(query: MPMediaQuery(filterPredicates: filterPredicates))
        player.setQueue(with: descriptor)
        player.prepareToPlay()
        player.play()
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
