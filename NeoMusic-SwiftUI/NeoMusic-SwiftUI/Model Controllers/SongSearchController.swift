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

class SongSearchController: ObservableObject {
    
    // MARK: - Published Variables
    
    @Published var songs: (byTitle: [Song], byArtist: [Song], byAlbum: [Song])
    @Published var lastPlayed: [Song]
    @Published var searchType: SearchType
    @Published var isSearching: Bool = false {
        didSet {
            NSLog(isSearching ? "Searching for songs with search term, \"\(searchTerm)\"" : "Done searching.")
        }
    }
    
    // MARK: - Variables
    
    private var task: DispatchWorkItem? = nil
    
    var searchTerm: String {
        didSet {
            task?.cancel()
            
            task = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.search(for: self.searchTerm)
            }

            if let task = task {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: task)
            }
        }
    }
    
    // MARK: - Initializer
    
    init(search term: String = "", searchType: SearchType = .library, lastPlayed: [Song] = []) {
        self.songs = ([], [], [])
        self.lastPlayed = lastPlayed
        self.searchType = searchType
        self.searchTerm = term
    }
    
    // MARK: - Functions
    
    func getAllSongs() -> [Song] {
        var songs = [Song]()
        switch searchType {
        case .library:
            guard let collections = MPMediaQuery.songs().collections else { return [] }
            for collection in collections {
                songs += collection.items.compactMap { Song($0) }
            }
        case .applemusic:
            // TODO: - Add online music search support
            break
        }
        
        return songs
    }
    
    func search(for term: String) {
        isSearching = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard !term.isEmpty else {
                DispatchQueue.main.async {
                    self.isSearching = false
                }
                return
            }
            
            let search = term.lowercased()
            let allSongs = self.getAllSongs()
            
            var byTitle = [Song]()
            var byArtist = [Song]()
            var byAlbum = [Song]()
            
            for song in allSongs {
                if song.title.lowercased().contains(search) {
                    byTitle.append(song)
                }
                
                if song.artist.lowercased().contains(search) {
                    byArtist.append(song)
                }
                
                if song.albumTitle.lowercased().contains(search) {
                    byAlbum.append(song)
                }
            }
            
            DispatchQueue.main.async {
                self.songs = (byTitle, byArtist, byAlbum)
                self.isSearching = false
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
