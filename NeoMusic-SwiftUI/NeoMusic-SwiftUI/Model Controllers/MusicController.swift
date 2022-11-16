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
    
    private(set) var queue = Queue<Song>()
    
    private let baseURL = URL(string: "https://api.music.apple.com/v1/")!
    private let apiKey: String = Hidden.apple_music_api_key // Place your Apple Music API Key here
    
    private var task: DispatchWorkItem? = nil
    
    var currentPlaybackTime: TimeInterval {
        player.currentPlaybackTime
    }
    
    var totalPlaybackTime: TimeInterval {
        return currentSong.duration
    }
    
    var isEmpty: Bool {
        return searchResults.songs.isEmpty && searchResults.albums.isEmpty && searchResults.artists.isEmpty
    }
    
    private var userToken: String? = nil
    private var countryCode: String? = nil
    
    weak var delegate: MusicControllerDelegate?
    
    // MARK: - Published Variables
    
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
    
    @Published var searchResults: (songs: [AMSong], artists: [Artist], albums: [Album]) = ([], [], [])
    @Published var isSearching: Bool = false {
        didSet {
            NSLog(isSearching && !searchTerm.isEmpty ? "Searching for songs with search term, \"\(searchTerm)\"" : "Done searching.")
        }
    }
    
    @Published var searchType: SearchType {
        didSet {
            if !searchTerm.isEmpty {
                search()
            }
        }
    }
    
    @Published var searchTerm: String {
        didSet {
            task?.cancel()
            
            task = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.search()
            }
            
            if let task = task {
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now().advanced(by: DispatchTimeInterval.seconds(1)), execute: task)
            }
        }
    }
    
    // MARK: - Initializers
    
    init(searchTerm: String = "", searchType: SearchType = .library, lastPlayed: [AMSong] = []) {
        self.lastPlayed = lastPlayed
        self.searchType = searchType
        self.searchTerm = ""
        self.dynamicPlayer = Dynamic(player)
        
        let auth = SKCloudServiceController.authorizationStatus()
        self.isCloudAuthorized = auth == .authorized || auth == .restricted
        
        queue.delegate = self
        
        if auth == .notDetermined {
            SKCloudServiceController.requestAuthorization { status in
                switch status {
                case .authorized, .restricted:
                    self.isCloudAuthorized = true
                default:
                    NSLog("Cloud access was denied")
                    self.isCloudAuthorized = false
                }
            }
        }
        
        fetchUserToken { [weak self] token in
            self?.userToken = token
        }
        
        fetchCountryCode { [weak self] code in
            self?.countryCode = code
        }
        
        self.searchTerm = searchTerm
        
        if checkAuthorized() {
            setup()
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
    }
    
    func checkAuthorized() -> Bool {
        switch MPMediaLibrary.authorizationStatus() {
        case .authorized, .restricted:
            return true
        case .notDetermined:
            MPMediaLibrary.requestAuthorization { [weak self] auth in
                if auth == .authorized || auth == .restricted {
                    self?.setup()
                }
            }
            
            return false
        default:
            
            
            return false
        }
    }
    
    private func pause() {
        guard checkAuthorized() else { return }
        
        player.pause()
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func play() {
        guard checkAuthorized() else { return }
        
        player.prepareToPlay { error in
            if let error = error {
                NSLog("f:\(#file)l:\(#line) Error: \(error)")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.player.play()
            }
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func addToUpNext(media: [MPMediaItem]) {
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: media))
        
        player.prepend(descriptor)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func addToUpLater(media: [MPMediaItem]) {
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: media))
        
        player.append(descriptor)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func setQueue(media: [MPMediaItem]) {
        let ids = media.map { $0.playbackStoreID }
        
        DispatchQueue.main.async {
            self.player.setQueue(with: ids)
            self.player.prepareToPlay()
            self.player.play()
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func fetchUserToken(completion: @escaping (String?) -> Void) {
        SKCloudServiceController().requestUserToken(forDeveloperToken: self.apiKey) { token, error in
            if let error = error {
                NSLog("f:\(#file)l:\(#line) Error: \(error)")
            }
            
            completion(token)
        }
    }
    
    private func fetchCountryCode(completion: @escaping (String?) -> Void) {
        SKCloudServiceController().requestStorefrontCountryCode { cc, error in
            if let error = error {
                NSLog("f:\(#file)l:\(#line) Error: \(error)")
            }
            
            completion(cc)
        }
    }
    
    // MARK: - Public Functions
    
    func search() {
        DispatchQueue.main.async {
            self.isSearching = true
        }
        
        guard !searchTerm.isEmpty else {
            DispatchQueue.main.async {
                self.isSearching = false
            }
            return
        }
        
        let search = searchTerm.lowercased()
        
        if searchType == .library {
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
            let artistList = artistIDSet.compactMap { artist(for: $0) }
            let albumList = albumIDSet.compactMap { album(for: $0) }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.searchResults = (songList, artistList, albumList)
                self.isSearching = false
            }
        } else if searchType == .applemusic {
            if let countryCode = countryCode {
                let url = baseURL
                    .appendingPathComponent("catalog")
                    .appendingPathComponent(countryCode)
                    .appendingPathComponent("search")
                
                var urlComponenets = URLComponents(url: url, resolvingAgainstBaseURL: false)
                
                urlComponenets?.queryItems = [
                    URLQueryItem(name: "term", value: searchTerm),
                    URLQueryItem(name: "limit", value: "3"),
                    URLQueryItem(name: "types", value: "songs,artists,albums")
                ]
                
                if let requestURL = urlComponenets?.url {
                    var request = URLRequest(url: requestURL)
                    request.httpMethod = HTTPMethod.get.rawValue
                    
                    request.setValue("Bearer \(self.apiKey)", forHTTPHeaderField: "Authorization")
                    request.setValue(userToken, forHTTPHeaderField: "Music-User-Token")
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            NSLog("f:\(#file)l:\(#line) Error: \(error)")
                            // TODO: - Display error in MessageController
                            return
                        }
                        
                        if let response = response as? HTTPURLResponse,
                           response.statusCode != 200 {
                            NSLog("Invalid response code returned: \(response.statusCode)")
                            return
                        }
                        
                        guard let data = data else {
                            NSLog("f:\(#file)l:\(#line) Error: No data returned from server")
                            return
                        }
                        
                        do {
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
                            
                            print(songJson)
                            print(albumJson)
                            print(artistJson)
                            
                            let songs = try JSONSerialization.data(withJSONObject: songJson)
                            let albums = try JSONSerialization.data(withJSONObject: albumJson)
                            let artists = try JSONSerialization.data(withJSONObject: artistJson)
                            
                            
                            let songArray: [AMSong] = try JSONDecoder().decode([AMSong].self, from: songs)
                            let albumArray: [Album] = try JSONDecoder().decode([Album].self, from: albums)
                            let artistArray: [Artist] = try JSONDecoder().decode([Artist].self, from: artists)
                            
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                
                                self.searchResults = (songArray, artistArray, albumArray)
                            }
                        } catch {
                            NSLog("f:\(#file)l:\(#line) Error: \(error)")
                        }
                    }.resume()
                }
            } else {
                NSLog("f:\(#file)l:\(#line) Error: No country code found, unable to perform search")
                // TODO: - Display erre in MessageController
            }
        }
    }
    
    // MARK: - Music Control Functions
    
    func set(time: TimeInterval) {
        guard checkAuthorized() else { return }
        
        player.currentPlaybackTime = time
    }
    
    func toggle() {
        guard checkAuthorized() else { return }
        
        isPlaying ? pause() : play()
    }
    
    func skipToPreviousItem() {
        guard checkAuthorized() else { return }
        
        if currentPlaybackTime <= 5 {
            player.skipToPreviousItem()
        } else {
            set(time: 0)
        }
    }
    
    func skipToNextItem() {
        guard checkAuthorized() else { return }
        
        player.skipToNextItem()
    }
    
    func setQueue(with songs: [Song]) {
        guard checkAuthorized() else { return }
        
        queue.clear()
        queue.push(songs)
    }
    
    func setQueue(with album: Album) {
        guard checkAuthorized() else { return }
        
        setQueue(with: album.items)
    }
    
    func setQueue(with artist: Artist) {
        guard checkAuthorized() else { return }
        
        setQueue(with: artist.items)
    }
    
    func addToUpNext(_ song: Song) {
        addToUpNext([song])
    }
    
    func addToUpNext(_ songs: [Song]) {
        queue.pushToFront(songs)
    }
    
    func addToUpNext(_ album: Album) {
        addToUpNext(album.items)
    }
    
    func addToUpNext(_ artist: Artist) {
        addToUpNext(artist.items)
    }
    
    func addToUpLater(_ song: Song) {
        addToUpLater([song])
    }
    
    func addToUpLater(_ songs: [Song]) {
        queue.push(songs)
    }
    
    func addToUpLater(_ album: Album) {
        addToUpLater(album.items)
    }
    
    func addToUpLater(_ artist: Artist) {
        addToUpLater(artist.items)
    }
    
    // MARK: - Song Functions
    
    func album(for id: UInt64) -> Album {
        let temp: Album
        
        if let album = Self.albumCache.value(for: id) {
            temp = album
        // TODO: Support AM alternatives
        } else if let items = MPMediaQuery(filterPredicates: [MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)]).items, let item = items.first {
            temp = Album(title: item.albumTitle, artwork: item.artwork?.image(at: CGSize(width: 500, height: 500)), items: items.map { AMSong($0) }, id: id)
            Self.albumCache.cache(value: temp, for: id)
        } else {
            temp = .noAlbum
        }
        
        return temp
    }
    
    func artist(for id: UInt64) -> Artist {
        var temp: Artist = .noArtist
        
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
            // TODO: - Spotify, Youtube, Soundcloud support
        }
        
        return temp
    }
    
    func album(for song: Song) -> Album {
        if let song = song as? AMSong {
            return album(for: song.albumPersistentID)
        } else {
            // TODO: - Other cases
        }
        
        return .noAlbum
    }
    
    func artist(for song: Song) -> Artist {
        if let song = song as? AMSong {
            return artist(for: song.artistPersistentID)
        } else {
            // TODO: - Other cases
        }
        
        return .noArtist
    }
    
    func artist(for album: Album) -> Artist {
        artist(for: album.items[0])
    }
    
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
    
    @objc func songChanged() {
        guard let media = player.nowPlayingItem else { return }
        DispatchQueue.main.async {
            self.currentSong = AMSong(media)
        }
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
    
    var currentIndex: Int {
        return player.indexOfNowPlayingItem
    }
    
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
    
    enum SearchType {
        case library, applemusic
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
