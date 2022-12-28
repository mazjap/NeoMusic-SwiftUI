import MusicKit
import MediaPlayer
import StoreKit
import WidgetKit

// MARK: - MusicControllerDelegate

protocol MusicControllerDelegate: AnyObject {
    func songChanged(previousSong: Song)
}

// MARK: - MusicPlayerController

class MusicController: ObservableObject {
    
    // MARK: - Variables
    
    private var isCloudAuthorized: Bool
    
    @MainActor
    private var player: MPMusicPlayerController = .systemMusicPlayer {
        didSet {
            dynamicPlayer = Dynamic(player)
        }
    }
    
    private var dynamicPlayer: Dynamic
    
    private var needsUpdate: Bool = true {
        didSet {
            if needsUpdate {
                Task {
                    _  = await self.upNextSongs
                }
            }
        }
    }
    
    @MainActor
    private(set) var queue = Queue<Song>()
    
    private let baseURL = URL(string: "https://api.music.apple.com/v1/")!
    private let apiKey: String = Hidden.apple_music_api_key // Place your Apple Music API Key here
    
    private var task: DispatchWorkItem? = nil
    
    @MainActor
    var currentPlaybackTime: TimeInterval {
        player.currentPlaybackTime
    }
    
    @MainActor
    var totalPlaybackTime: TimeInterval {
        return currentSong.duration
    }
    
    @MainActor
    var isEmpty: Bool {
        return searchResults.songs.isEmpty && searchResults.albums.isEmpty && searchResults.artists.isEmpty
    }
    
    private var userToken: String? = nil
    private var countryCode: String? = nil
    
    weak var delegate: MusicControllerDelegate?
    
    // MARK: - Published Variables
    
    @MainActor
    @Published var currentSong: Song = AMSong.noSong {
        didSet {
            if oldValue.id != "0" {
                delegate?.songChanged(previousSong: oldValue)
            }
            
            if queue.count > 0, currentSong.id == queue[1].id {
                queue.pop()
            } else {
                needsUpdate = true
            }
        }
    }
    
    @Published var showNoAccessMessage = false
    @Published var isPlaying: Bool = false
    @Published var lastPlayed: [AMSong]
    
    @MainActor
    @Published var searchResults: (songs: [AMSong], artists: [Artist], albums: [Album]) = ([], [], [])
    @MainActor
    @Published var isSearching: Bool = false
    
    // MARK: - Initializers
    
    init(lastPlayed: [AMSong] = []) {
        let auth = SKCloudServiceController.authorizationStatus()
        self.isCloudAuthorized = auth == .authorized || auth == .restricted
        
        self.lastPlayed = lastPlayed
        self.dynamicPlayer = Dynamic(player)
        
        queue.delegate = self
        
        Task {
            do {
                if auth == .notDetermined {
                    switch await SKCloudServiceController.requestAuthorization() {
                    case .authorized, .restricted:
                        self.isCloudAuthorized = true
                    default:
                        NSLog("Cloud access was denied")
                        self.isCloudAuthorized = false
                    }
                }
                
                self.countryCode = try await fetchCountryCode()
                self.userToken = try await fetchUserToken()
                
                if await checkAuthorized() {
                    await setup()
                }
            } catch {
                // TODO: - use nserror
                NSLog("\(error as NSError)")
            }
        }
    }
    
    // MARK: - Private Functions
    
    @MainActor
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
    
    func checkAuthorized() async -> Bool {
        switch MPMediaLibrary.authorizationStatus() {
        case .authorized, .restricted:
            return true
        case .notDetermined:
            let auth = await MPMediaLibrary.requestAuthorization()
            if auth == .authorized || auth == .restricted {
                await self.setup()
            }
            
            return await checkAuthorized()
        default:
            return false
        }
    }
    
    @MainActor
    private func pause() {
        player.pause()
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func play() async throws {
        try await player.prepareToPlay()
        
        await MainActor.run {
            player.play()
            
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    private func addToUpNext(media: [MPMediaItem]) {
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: media))
        
        Task { @MainActor in
            player.prepend(descriptor)
            
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    private func addToUpLater(media: [MPMediaItem]) {
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: media))
        
        Task { @MainActor in
            player.append(descriptor)
            
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    private func setQueue(media: [MPMediaItem]) async {
        let ids = media.map { $0.playbackStoreID }
        
        await MainActor.run {
            self.player.setQueue(with: ids)
            self.player.prepareToPlay()
            self.player.play()
            
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    private func fetchUserToken() async throws -> String {
        try await SKCloudServiceController().requestUserToken(forDeveloperToken: self.apiKey)
    }
    
    private func fetchCountryCode() async throws -> String {
        try await SKCloudServiceController().requestStorefrontCountryCode()
    }
    
    // MARK: - Public Functions
    
    func search(_ term: String, type: SearchType) async throws {
        let search = term.lowercased()
        
        guard !term.isEmpty else { return }
        
        await MainActor.run {
            self.isSearching = true
        }
        
        if type == .library {
            let titleQuery = MPMediaQuery.songs()
            let artistQuery = MPMediaQuery.artists()
            let albumQuery = MPMediaQuery.albums()
            
            titleQuery.addFilterPredicate(MPMediaPropertyPredicate(value: search, forProperty: MPMediaItemPropertyTitle, comparisonType: .contains))
            artistQuery.addFilterPredicate(MPMediaPropertyPredicate(value: search, forProperty: MPMediaItemPropertyArtist, comparisonType: .contains))
            albumQuery.addFilterPredicate(MPMediaPropertyPredicate(value: search, forProperty: MPMediaItemPropertyAlbumTitle, comparisonType: .contains))
            
            var albumIDSet = Set<UInt64>()
            var artistIDSet = Set<UInt64>()
            
            if let items = artistQuery.items {
                for item in items {
                    artistIDSet.insert(item.artistPersistentID)
                }
            }
            
            if let items = albumQuery.items {
                for item in items {
                    albumIDSet.insert(item.albumPersistentID)
                }
            }
            
            let songList = (titleQuery.items ?? []).toSongs()
            let artistList = try artistIDSet.compactMap { try artist(for: $0) }
            let albumList = try albumIDSet.compactMap { try album(for: $0) }
            
            await MainActor.run {
                searchResults = (songList, artistList, albumList)
                isSearching = false
            }
        } else if type == .applemusic {
            if let countryCode = countryCode {
                let url = baseURL
                    .appendingPathComponent("catalog")
                    .appendingPathComponent(countryCode)
                    .appendingPathComponent("search")
                
                var urlComponenets = URLComponents(url: url, resolvingAgainstBaseURL: false)
                
                urlComponenets?.queryItems = [
                    URLQueryItem(name: "term", value: search),
                    URLQueryItem(name: "limit", value: "3"),
                    URLQueryItem(name: "types", value: "songs,artists,albums")
                ]
                
                if let requestURL = urlComponenets?.url {
                    var request = URLRequest(url: requestURL)
                    request.httpMethod = HTTPMethod.get.rawValue
                    
                    request.setValue("Bearer \(self.apiKey)", forHTTPHeaderField: "Authorization")
                    request.setValue(userToken, forHTTPHeaderField: "Music-User-Token")
                    
                    let (data, response) = try await withTaskCancellationHandler {
                        try await URLSession.shared.data(for: request)
                    } onCancel: {
                        print("sad day, the request was cancelled")
                    }
                    
                    if let response = response as? HTTPURLResponse,
                       response.statusCode != 200 {
                        NSLog("Invalid response code returned: \(response.statusCode)")
                        // TODO: - use nserror()
                        throw NSError()
                    }
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        NSLog("f:\(#file)l:\(#line) Error: JSON could not be decoded")
                        return
                    }
                    
                    guard let results = json["results"] as? [String : Any],
                          let tempSongs = results["songs"] as? [String : Any],
                          let tempAlbums = results["albums"] as? [String : Any],
                          let tempArtists = results["artists"] as? [String : Any],
                          let songJson = tempSongs["data"],
                          let albumJson = tempAlbums["data"],
                          let artistJson = tempArtists["data"] else { return }
                    
                    let songs = try JSONSerialization.data(withJSONObject: songJson)
                    let albums = try JSONSerialization.data(withJSONObject: albumJson)
                    let artists = try JSONSerialization.data(withJSONObject: artistJson)
                    
                    
                    let songArray: [AMSong] = try JSONDecoder().decode([AMSong].self, from: songs)
                    let albumArray: [Album] = try JSONDecoder().decode([Album].self, from: albums)
                    let artistArray: [Artist] = try JSONDecoder().decode([Artist].self, from: artists)
                    
                    await MainActor.run {
                        self.searchResults = (songArray, artistArray, albumArray)
                    }
                }
            } else {
                NSLog("f:\(#file)l:\(#line) Error: No country code found, unable to perform search")
                // TODO: - Display erre in MessageController
            }
        }
    }
    
    // MARK: - Music Control Functions
    
    func set(time: TimeInterval) async {
        await player.currentPlaybackTime = time
    }
    
    func toggle() async throws {
        isPlaying ? await pause() : try await play()
    }
    
    @MainActor
    func skipToPreviousItem() async {
        guard await checkAuthorized() else { return }
        
        if currentPlaybackTime <= 5 {
            player.skipToPreviousItem()
        } else {
            await set(time: 0)
        }
    }
    
    @MainActor
    func skipToNextItem() async {
        guard await checkAuthorized() else { return }
        
        player.skipToNextItem()
    }
    
    @MainActor
    func setQueue(with songs: [Song]) async {
        guard await checkAuthorized() else { return }
        
        queue.clear()
        queue.push(songs)
    }
    
    @MainActor
    func setQueue(with album: Album) async {
        await setQueue(with: album.items)
    }
    
    @MainActor
    func setQueue(with artist: Artist) async {
        await setQueue(with: artist.items)
    }
    
    @MainActor
    func addToUpNext(_ song: Song) {
        addToUpNext([song])
    }
    
    @MainActor
    func addToUpNext(_ songs: [Song]) {
        queue.pushToFront(songs)
    }
    
    @MainActor
    func addToUpNext(_ album: Album) {
        addToUpNext(album.items)
    }
    
    @MainActor
    func addToUpNext(_ artist: Artist) {
        addToUpNext(artist.items)
    }
    
    @MainActor
    func addToUpLater(_ song: Song) {
        addToUpLater([song])
    }
    
    @MainActor
    func addToUpLater(_ songs: [Song]) {
        queue.push(songs)
    }
    
    @MainActor
    func addToUpLater(_ album: Album) {
        addToUpLater(album.items)
    }
    
    @MainActor
    func addToUpLater(_ artist: Artist) {
        addToUpLater(artist.items)
    }
    
    // MARK: - Song Functions
    
    func album(for id: UInt64) throws -> Album {
        let temp: Album
        
        if let album = Self.albumCache.value(for: id) {
            temp = album
        // TODO: Support AM alternatives
        } else if let items = MPMediaQuery(filterPredicates: [MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)]).items, let item = items.first {
            temp = Album(title: item.albumTitle, artwork: item.artwork?.image(at: CGSize(width: 500, height: 500)), items: items.map { AMSong($0) }, id: id)
            Self.albumCache.cache(value: temp, for: id)
        } else {
            // TODO: - Use AppError
            throw NSError()
        }
        
        return temp
    }
    
    func artist(for id: UInt64) throws -> Artist {
        let temp: Artist
        
        if let artist = Self.artistCache.value(for: id) {
            temp = artist
        } else if let items = MPMediaQuery(filterPredicates: [MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyArtistPersistentID, comparisonType: .equalTo)]).items, let item = items.first {
            
            var albums = [[MPMediaItem]]()
            
            for media in items {
                var createNewArr = true
                
                for i in 0..<albums.count {
                    if albums[i].count > 0 && albums[i][0].albumPersistentID == media.albumPersistentID {
                        albums[i].append(media)
                        createNewArr = false
                        break
                    }
                }
                
                if createNewArr {
                    albums.append([media])
                }
            }
            
            temp = Artist(name: item.artist, albums: albums.compactMap { arr in
                if let temp = arr.first {
                    let song = AMSong(temp)
                    return Album(title: song.album, artwork: song.albumArtwork, items: arr.map { AMSong($0) }, id: song.persistentID)
                }
                
                return nil
            }, id: id)
        } else {
            // TODO: - Use NSError
            throw NSError()
            // TODO: - Spotify, Youtube, Soundcloud support
        }
        
        return temp
    }
    
    func album(for song: Song) throws -> Album {
        if let song = song as? AMSong {
            return try album(for: song.albumPersistentID)
        } else {
            // TODO: - Other cases
        }
        
        return .noAlbum
    }
    
    func artist(for song: Song) throws -> Artist {
        if let song = song as? AMSong {
            return try artist(for: song.artistPersistentID)
        } else {
            // TODO: - Other cases
        }
        
        return .noArtist
    }
    
    func artist(for album: Album) throws -> Artist {
        try artist(for: album.items[0])
    }
    
    @MainActor
    func getEntry(at offset: Int = 0, with date: Date = Date(), size: WidgetFamily = .systemSmall) -> (entry: NeoTimelineEntry, isPlaying: Bool) {
        var media: [MPMediaItem?] = [item(at: currentIndex + offset)]
        
        if size != .systemSmall {
            for i in 1...3 {
                
                media.append(item(at: currentIndex + offset + i))
            }
            
            if size == .systemLarge {
                
            }
        }
        
        media = media.compactMap { $0 }
        
        return (NeoTimelineEntry(songs: media.map { AMSong($0) }, date: date), isPlaying)
    }
    
    // MARK: - Objective-C Functions
    
    @objc
    private func playbackStatusChanged() {
        DispatchQueue.main.async {
            self.isPlaying = self.player.playbackState == .playing
        }
    }
    
    @MainActor
    @objc func songChanged() {
        guard let media = player.nowPlayingItem else { return }
        self.currentSong = AMSong(media)
    }
    
    // MARK: - Static Variables
    
    static var songCache = Cache<UInt64, AMSong>()
    static var albumCache = Cache<UInt64, Album>()
    static var artistCache = Cache<UInt64, Artist>()
}

extension MusicController: QueueDelegate {
    func queueDidPush() {
        
    }
    
    func queueDidPushToFront() {
        
    }
    
    func queueDidPop() {
        
    }
}

// MARK: - MusicController Extension: Dynamic Player

extension MusicController {
    var songCount: Int {
        return dynamicPlayer.numberOfItems.unwrapped() ?? 0
    }
    
    @MainActor
    var currentIndex: Int {
        return player.indexOfNowPlayingItem
    }
    
    @MainActor
    var upNextSongs: [Song] {
        queue.arr
    }
    
    func changeCurrentIndex(to item: AMSong) {
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

// MARK: - MusicController Extension: SearchCategory, SearchType, NetworkError

extension MusicController {
    enum SearchCategory {
        case title, artist, album
    }
    
    enum NetworkError: Error {
        case encodingError
        case badResponse
        case noData
        case badDecode
        case noAuth
        case invalidInput
        case otherError(String)
    }
}

enum SearchType {
    case library, applemusic
}
