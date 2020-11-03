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
        
        let appearance = UITableView.appearance()
        
        appearance.backgroundColor = .clear
        appearance.tableFooterView = UIView()
        appearance.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            SearchBar(searchText: Binding<String>(get: {
                return text
            }, set: { newVal in
                text = newVal
                searchController.searchTerm = text
            }), font: nil, colorScheme: settingsController.colorScheme,
            onEditingChanged: { isEditing in }, onCommit: {})
                .resignsFirstResponderOnDrag()
                .frame(height: 50)
                .padding(16)
            
            GeometryReader { geometry in
                ZStack {
                    List {
                        let background = settingsController.colorScheme.backgroundGradient.first
                        let text = settingsController.colorScheme.textColor.color
                        
                        let selectedSong = Binding<Optional<Song>>(get: { return nil }, set: { song in
                            guard let song = song else { return }
                            
                            musicController.addToUpNext(song)
                            musicController.skipToNextItem()
                        })
                        
                        Section(header:
                                    Text("Songs")
                                    .customHeader(backgroundColor: background, textColor: text)) {
                            ForEach(searchController.songs.byTitle) { song in
                                NeoSongRow(selectedSong: selectedSong, backgroundColor: settingsController.colorScheme.backgroundGradient.first, textColor: settingsController.colorScheme.textColor.color, song: song)
                                    .listRowBackground(LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.first.average(to: settingsController.colorScheme.backgroundGradient.last).offsetColors), startPoint: .top, endPoint: .bottom)
                                                        .clipped()
                                                        .cornerRadius(20))
                            }
                        }
                        
                        Section(header: Text("Artists")
                                    .customHeader(backgroundColor: background, textColor: text)) {
                            ForEach(searchController.songs.byArtist) { song in
                                NeoSongRow(selectedSong: selectedSong, backgroundColor: settingsController.colorScheme.backgroundGradient.first, textColor: settingsController.colorScheme.textColor.color, song: song)
                                Spacer()
                            }
                        }
                        
                        Section(header: Text("Albums")
                                    .customHeader(backgroundColor: background, textColor: text)) {
                            ForEach(searchController.songs.byAlbum) { song in
                                NeoSongRow(selectedSong: selectedSong, backgroundColor: settingsController.colorScheme.backgroundGradient.first, textColor: settingsController.colorScheme.textColor.color, song: song)
                            }
                            
                            Rectangle()
                                .frame(height: offsetHeight / 2 + MusicPlayer.musicPlayerHeightOffset)
                                .foregroundColor(settingsController.colorScheme.backgroundGradient.first)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                }
                .if(searchController.songs.byTitle.isEmpty && searchController.songs.byArtist.isEmpty && searchController.songs.byAlbum.isEmpty) {
                    $0.opacity(0)
                } else: {
                    $0.opacity(1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding([.top, .leading, .trailing], 16)
                .frame(height: geometry.size.height + offsetHeight)
                .offset(y: offsetHeight / 2)
                .neumorph(color: settingsController.colorScheme.backgroundGradient.first.average(to: settingsController.colorScheme.backgroundGradient.last), size: .list)
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
