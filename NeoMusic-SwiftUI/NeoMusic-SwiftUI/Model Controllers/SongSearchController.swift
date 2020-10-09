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
    @Published var songsByTitle = [Song]()
    @Published var songsByArtist = [Song]()
    @Published var songsByAlbum = [Song]()
    
    var searchType: SearchType = .library
    
    var searchTerm: String = "" {
        didSet {
            // TODO: - Use timer to wait until user has stopped typing before searching
            songsByTitle = search(for: searchTerm, by: .title)
            songsByArtist = search(for: searchTerm, by: .artist)
            songsByAlbum = search(for: searchTerm, by: .album)
        }
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
    
    func search(for term: String, by category: SearchCategory) -> [Song] {
        let allSongs = getAllSongs()
        
        let filteredSongs: [Song]
        
        switch category {
        case .title:
            filteredSongs = allSongs.filter { $0.title.contains(term) }
        case .artist:
            filteredSongs = allSongs.filter { $0.artist.contains(term) }
        case .album:
            filteredSongs = allSongs.filter { $0.albumTitle.contains(term) }
        }
        
        return filteredSongs
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
