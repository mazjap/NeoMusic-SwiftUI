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
    
    private var needsUpdate: Bool = true {
        didSet {
            if needsUpdate {
                DispatchQueue.global(qos: .background).async {
                    _ = self.upNextSongs
                }
            }
        }
    }
    
    private(set) var upNext: [Song] = []
    
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
            
            if upNext.count > 0, currentSong == upNext[1] {
                upNext.remove(at: 0)
            } else {
                needsUpdate = true
            }
        }
    }
    
    @Published var isPlaying: Bool = false
    
    // MARK: - Initializers

    init() {
        dynamicPlayer = Dynamic(player)
        checkAuthorized()
        for song in upNextSongs {
            print("\(song.title), \(song.storeID)")
        }
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
        
        print("\n\nMPMediaQuery\n\n")
        Hidden.printMethodNames(for: MPMediaQuery.self)
        
        print("\n\nMPMusicPlayerQueueDescriptor\n\n")
        Hidden.printMethodNames(for: MPMusicPlayerQueueDescriptor.self)
        
        print("\n\nMPMediaItemCollection\n\n")
        Hidden.printMethodNames(for: MPMediaItemCollection.self)
        
        print("\n\nMPMediaItem\n\n")
        Hidden.printMethodNames(for: MPMediaItem.self)
        
        print("\n\nMPMusicPlayerController\n\n")
        Hidden.printMethodNames(for: MPMusicPlayerController.self)
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
    
    private func pause() {
        guard isAuthorized else { checkAuthorized(); return }
        
        player.pause()
    }

    private func play() {
        guard isAuthorized else { checkAuthorized(); return }
        
        player.play()
    }
    
    private func addToUpNext(media: [MPMediaItem]) {
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: media))

        player.prepend(descriptor)
    }
    
    private func addToUpLater(media: [MPMediaItem]) {
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: media))

        player.append(descriptor)
    }
    
    private func setQueue(media: [MPMediaItem]) {
        DispatchQueue.main.async {
            let ids = media.map { $0.playbackStoreID }
            
            self.player.setQueue(with: ids)
            self.player.prepareToPlay()
            self.player.play()
        }
    }
    
    // MARK: - Public Functions
    
    // MARK: - Music Control Functions

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
        
        setQueue(media: songs.compactMap { $0.media })
    }
    
    func setQueue(with album: Album) {
        guard isAuthorized else { checkAuthorized(); return }
        
        setQueue(media: album.items)
    }
    
    func setQueue(with artist: Artist) {
        guard isAuthorized else { checkAuthorized(); return }
        
        setQueue(media: artist.items)
    }
    
    func addToUpNext(_ song: Song) {
        addToUpNext([song])
    }
    
    func addToUpNext(_ songs: [Song]) {
        addToUpNext(media: songs.compactMap { $0.media })
    }
    
    func addToUpNext(_ album: Album) {
        addToUpNext(media: album.items)
    }
    
    func addToUpNext(_ artist: Artist) {
        addToUpNext(media: artist.items)
    }
    
    func addToUpLater(_ song: Song) {
        addToUpLater([song])
    }
    
    func addToUpLater(_ songs: [Song]) {
        addToUpLater(media: songs.compactMap { $0.media })
    }
    
    func addToUpLater(_ album: Album) {
        addToUpLater(media: album.items)
    }
    
    func addToUpLater(_ artist: Artist) {
        addToUpLater(media: artist.items)
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
    var songCount: Int {
        return dynamicPlayer.numberOfItems.unwrapped() ?? 0
    }
    
    var currentIndex: Int {
        return player.indexOfNowPlayingItem
    }
    
    var upNextSongs: [Song] {
        guard songCount > currentIndex else { return [] }
        
        if needsUpdate {
            var temp = [MPMediaItem]()
            
            if let query: MPMediaQuery = dynamicPlayer.queueAsQuery.unwrapped(), let items = query.items {
                temp = items
                print("From query: \(items)")
            } else {
                for i in currentIndex..<songCount {
                    if let media = item(at: i) {
                        temp.append(media)
                    }
                }
            }
            
            needsUpdate = false
            
            upNext = temp.map { Song($0) }
        }
        
        return upNext
    }
    
    func changeCurrentIndex(to item: Song) {
        if let media = item.media {
            changeCurrentIndex(to: media)
        }
    }
    
    func changeCurrentIndex(to item: MPMediaItem) {
        dynamicPlayer.set(nowPlayingItem: item)
    }
    
    func item(at index: Int) -> MPMediaItem? {
        if let item: MPMediaItem = dynamicPlayer.nowPlayingItemAt(index: index).unwrapped() {
            return item
        }
        
        return nil
    }
}
