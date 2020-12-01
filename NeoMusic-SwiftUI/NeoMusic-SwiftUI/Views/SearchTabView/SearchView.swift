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
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    
    @ObservedObject private var searchController: SongSearchController
    
    @State private var text: String = ""
    @State private var segmentedIndex: Int = 0
    
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
                    SegmentedControl(index: $segmentedIndex, textColor: settingsController.colorScheme.textColor.color, background: settingsController.colorScheme.backgroundGradient.first)
                        .options(["Library", "Apple Music"])
                        .onChange(of: segmentedIndex) { newVal in
                            searchController.searchType = newVal == 0 ? .library : .applemusic
                        }
                        .spacing()
                    
                    SearchBar(searchText: $text, font: nil, colorScheme: settingsController.colorScheme,
                    onEditingChanged: { isEditing in }, onCommit: {})
                        .resignsFirstResponderOnDrag()
                        .onChange(of: text) { newVal in
                            searchController.searchTerm = newVal
                        }
                        .frame(height: 50)
                        .spacing(.horizontal)
                    
                    Table {
                        let backgroundColor = settingsController.colorScheme.backgroundGradient.first
                        let textColor = settingsController.colorScheme.textColor.color
                        
                        TableSection(title: "Songs") {
                            let selectedSong = Binding<Optional<Song>> { return nil } set: { song in
                                if let song = song {
                                    musicController.addToUpNext(song)
                                }
                            }
                            
                            ForEach(searchController.songs) { song in
                                NeoSongRow(selectedSong: selectedSong, backgroundColor: backgroundColor, textColor: textColor, song: song)
                            }
                        }
                        
                        TableSection(title: "Albums") {
                            let selectedAlbum = Binding<Optional<Album>> { return nil } set: { album in
                                if let album = album {
                                    musicController.addToUpNext(album)
                                }
                            }
                            
                            ForEach(searchController.albums) { album in
                                NeoAlbumRow(selectedAlbum: selectedAlbum, backgroundColor: backgroundColor, textColor: textColor, album: album)
                            }
                        }
                        
                        TableSection(title: "Artists") {
                            let selectedArtist = Binding<Optional<Artist>> { return nil } set: { artist in
                                if let artist = artist {
                                    musicController.addToUpNext(artist)
                                }
                            }
                            
                            ForEach(searchController.artists) { artist in
                                NeoArtistRow(selectedArtist: selectedArtist, backgroundColor: backgroundColor, textColor: textColor, artist: artist)
                            }
                        }
                        
                        TableSection {
                            backgroundColor
                                .frame(height: 100)
                        }
                    }
                    .foregroundColor(settingsController.colorScheme.textColor.color)
                    .background(settingsController.colorScheme.backgroundGradient.first.cornerRadius(20))
                    .opacity(searchController.searchTerm.isEmpty || searchController.isEmpty ? 0 : 1)
                    .spacing()
                    .offset(y: offsetHeight / 2)
                    .neumorph(color: settingsController.colorScheme.backgroundGradient.first.average(to: settingsController.colorScheme.backgroundGradient.last), size: .list)
                }
            }
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
                return "Albums"
            case .artist:
                return "Artists"
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
