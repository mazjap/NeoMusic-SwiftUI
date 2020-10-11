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
    @Published var songs: (byTitle: [Song], byArtist: [Song], byAlbum: [Song])
    
    var searchTerm: String! {
        didSet {
            guard let searchTerm = searchTerm, !searchTerm.isEmpty else {
                songs = ([], [], [])
                return
            }
            // TODO: - Use timer to wait until user has stopped typing before searching
            songs = search(for: searchTerm)
        }
    }
    
    var searchType: SearchType
    
    init(search term: String = "", searchType: SearchType = .library) {
        self.searchType = searchType
        self.songs = ([], [], [])
        
        // Implicitly unwrapped optional so that didSet is called in init
        self.searchTerm = term
    }
    
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
    
    func search(for term: String) -> ([Song], [Song], [Song]) {
        
        let search = term.lowercased()
        let allSongs = getAllSongs()
        
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
        
        return (byTitle, byArtist, byAlbum)
    }
    
    func getLastPlayed(_ count: Int = 50) -> [Song] {
        // TODO: - Use MPMediaItem's lastPlayedDate to get last played songs
        return []
    }
}

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
