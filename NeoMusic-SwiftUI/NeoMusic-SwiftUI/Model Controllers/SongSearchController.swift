//
//  SongSearchController.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/6/20.
//
//  Purpose:
//  Search through songs locally or on cloud
//

import MediaPlayer
import StoreKit

extension Array where Element == MPMediaItem {
    func toSongs() -> [Song] {
        return compactMap{ Song($0) }
    }
}

class SongSearchController: ObservableObject {
    
    // MARK: - Published Variables
    
    @Published var songs: [Song]
    @Published var albums: [Album]
    @Published var artists: [Artist]
    @Published var lastPlayed: [Song]
    @Published var searchType: SearchType {
        didSet {
            if !searchTerm.isEmpty {
                search()
            }
        }
    }
    @Published var isAuthorized: Bool
    @Published var isSearching: Bool = false {
        didSet {
            NSLog(isSearching && !searchTerm.isEmpty ? "Searching for songs with search term, \"\(searchTerm)\"" : "Done searching.")
        }
    }
    
    // MARK: - Variables
    
    private let baseURL = URL(string: "https://api.music.apple.com/v1/")!
    private let apiKey: String = Hidden.apple_music_api_key // Place your Apple Music API Key here
    private let cloudServiceController = SKCloudServiceController()
    
    private var userToken: String?
    private var countryCode: String?
    private var task: DispatchWorkItem? = nil
    
    var searchTerm: String {
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
    
    var isEmpty: Bool {
        return songs.isEmpty && albums.isEmpty && artists.isEmpty
    }
    
    // MARK: - Initializers
    
    init(search term: String = "", searchType: SearchType = .library, lastPlayed: [Song] = []) {
        self.songs = []
        self.albums = []
        self.artists = []
        self.lastPlayed = lastPlayed
        self.searchType = searchType
        self.searchTerm = term
        
        let auth = SKCloudServiceController.authorizationStatus()
        self.isAuthorized = auth == .authorized || auth == .restricted
        
        if auth == .notDetermined {
            SKCloudServiceController.requestAuthorization { status in
                switch status {
                case .authorized, .restricted:
                    self.isAuthorized = true
                default:
                    NSLog("Cloud access was denied")
                    self.isAuthorized = false
                }
            }
        }
        
        cloudServiceController.requestStorefrontCountryCode { countryCode, error in
            if let error = error {
                NSLog("f:\(#file)l:\(#line) Unable to fetch country code with error: \(error)")
                // TODO: - Display error to user
            } else {
                self.countryCode = countryCode
            }
        }
        
        cloudServiceController.requestUserToken(forDeveloperToken: apiKey) { userToken, error in
            if let error = error {
                NSLog("f:\(#file)l:\(#line) Unable to fetch user token with error: \(error)")
                // TODO: - Display error to user
            } else {
                self.userToken = userToken
            }
        }
    }
    
    // MARK: - Functions
    
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
            
            titleQuery.addFilterPredicate(MPMediaPropertyPredicate(value: search, forProperty: MPMediaItemPropertyTitle, comparisonType:MPMediaPredicateComparison.contains))
            artistQuery.addFilterPredicate(MPMediaPropertyPredicate(value: search, forProperty: MPMediaItemPropertyArtist, comparisonType:MPMediaPredicateComparison.contains))
            albumQuery.addFilterPredicate(MPMediaPropertyPredicate(value: search, forProperty: MPMediaItemPropertyAlbumTitle, comparisonType:MPMediaPredicateComparison.contains))
            
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
            
            let albumList = albumIDSet.compactMap { Album.createAlbum(for: $0) }
            let artistList = artistIDSet.compactMap { Artist.createArtist(for: $0) }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let mediaList = titleQuery.items {
                    DispatchQueue.main.async {
                        self.songs = mediaList.toSongs()
                    }
                }
                
                self.albums = albumList
                self.artists = artistList
            
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
                                  let albumsJson = tempAlbums["data"],
                                  let artistJson = tempArtists["data"] else { return }
                            
                            let songs = try JSONSerialization.data(withJSONObject: songJson)
                            let albums = try JSONSerialization.data(withJSONObject: albumsJson)
                            let artists = try JSONSerialization.data(withJSONObject: artistJson)
                            
                            let songArray: [Song] = try JSONDecoder().decode([Song].self, from: songs)
                            let albumArray: [Album] = try JSONDecoder().decode([Album].self, from: albums)
                            let artistArray: [Artist] = try JSONDecoder().decode([Artist].self, from: artists)
                            
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                self.songs = songArray
                                self.albums = albumArray
                                self.artists = artistArray
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
}

// MARK: - SongSearchController Extension: SearchCategory, SearchType, NetworkError

extension SongSearchController {
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

// MARK: - SongSearchController Extension: MusicPlayerControllerDelegate

extension SongSearchController: MusicPlayerControllerDelegate {
    func songChanged(previousSong: Song) {
        lastPlayed.append(previousSong)
    }
}
