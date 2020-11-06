//
//  SearchView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 9/30/20.
//

import SwiftUI

struct SearchView: View {
    // MARK: - State
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var musicController: MusicPlayerController
    @EnvironmentObject private var feedback: FeedbackGenerator
    
    @ObservedObject private var searchController: SongSearchController
    
    @State private var text: String = ""
    
    // MARK: - Variables
    
    private let offsetHeight: CGFloat = 20
    
    // MARK: - Initializers
    
    init(searchController: SongSearchController) {
        self.searchController = searchController
        self.text = searchController.searchTerm
        
        let backgroundColor = SettingsController.shared.colorScheme.backgroundGradient.first.uiColor
        let tableAppearance = UITableView.appearance()
        let cellAppearance = UITableViewCell.appearance()
        
        tableAppearance.showsVerticalScrollIndicator = false
        tableAppearance.backgroundColor = backgroundColor
        cellAppearance.backgroundColor = backgroundColor
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: geometry.size.height + MusicPlayer.musicPlayerHeightOffset - TabBar.height)
                    .offset(y: -TabBar.height / 2)
                
                VStack {
                    SearchBar(searchText: Binding<String>(get: { return text }, set: { newVal in
                        text = newVal
                        searchController.searchTerm = text
                    }), font: nil, colorScheme: settingsController.colorScheme,
                    onEditingChanged: { isEditing in }, onCommit: {})
                        .resignsFirstResponderOnDrag()
                        .frame(height: 50)
                    .spacing([.top, .leading, .trailing])
                    
                    List {
                        let backgroundColor = settingsController.colorScheme.backgroundGradient.first
                        let textColor = settingsController.colorScheme.textColor.color
                        let selectedSong = Binding<Optional<Song>> { return nil } set: { song in
                            if let song = song {
                                musicController.addToUpNext(song)
                            }
                        }
                        
                        getSection(with: .title, backgroundColor: backgroundColor, textColor: textColor, selectedSong: selectedSong)
                        
                        getSection(with: .album, backgroundColor: backgroundColor, textColor: textColor, selectedSong: selectedSong)
                        
                        getSection(with: .artist, backgroundColor: backgroundColor, textColor: textColor, selectedSong: selectedSong)
                        
                        Spacer()
                            .frame(height: 100)
                            .listRowBackground(backgroundColor)
                    }
                    .cornerRadius(20)
                    .opacity(searchController.searchTerm.isEmpty || searchController.songs == ([], [], []) ? 0 : 1)
                    .spacing()
                    .offset(y: offsetHeight / 2)
                    .neumorph(color: settingsController.colorScheme.backgroundGradient.first.average(to: settingsController.colorScheme.backgroundGradient.last), size: .list)
                }
            }
        }
    }
    
    // MARK: - Functions
    
    // Extract Section View to function to avoid repeated code
    private func getSection(with type: SectionType, backgroundColor: Color, textColor: Color, selectedSong: Binding<Optional<Song>>) -> some View {
        let songs = type.songList(searchController: searchController)
        
        if songs.isEmpty {
            return Section {}
                .frame(width: 0, height: 0)
                .asAny()
        } else {
            return Section(header: Text(type.text).customHeader(backgroundColor: backgroundColor, textColor: textColor)) {
                ForEach(songs) { song in
                        NeoSongRow(selectedSong: selectedSong, backgroundColor: backgroundColor, textColor: textColor, song: song)
                    Spacer()
                        .listRowBackground(backgroundColor)
                }
            }.asAny()
        }
    }
    
    // MARK: - Static Variables
    
    static let cellHeight = UIScreen.main.bounds.height / 10
    
}

// MARK: - SearchView Extension: SectionType

extension SearchView {
    enum SectionType {
        case title
        case album
        case artist
        
        var text: String {
            switch self {
            case .title:
                return "Songs"
            case .album:
                return "Album"
            case .artist:
                return "Artist"
            }
        }
        
        func songList(searchController: SongSearchController) -> [Song] {
            switch self {
            case .title:
                return searchController.songs.byTitle
            case .album:
                return searchController.songs.byAlbum
            case .artist:
                return searchController.songs.byArtist
            }
        }
    }
}

// MARK: - Preview

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchController: SongSearchController())
            .environmentObject(SettingsController.shared)
            .environmentObject(MusicPlayerController())
    }
}
