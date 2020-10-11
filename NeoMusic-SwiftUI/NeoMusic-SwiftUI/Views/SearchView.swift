//
//  SearchView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 9/30/20.
//

import SwiftUI

struct SearchView: View {
    @State var text: String = ""
    @State var isLoading = false
    
    @EnvironmentObject var settingsController: SettingsController
    @EnvironmentObject var musicController: MusicPlayerController
    @ObservedObject var searchController = SongSearchController(search: "no")
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
            
            VStack {
                SearchBar(searchText: $text, font: nil, colorScheme: settingsController.colorScheme, onEditingChanged: { isEditing in
                }, onCommit: {
                    searchController.searchTerm = text
                })
                    .resignsFirstResponderOnDrag()
                    .frame(height: 50)
                    .padding(16)
                
                let rect = Rectangle()
                    .foregroundColor(settingsController.colorScheme.backgroundGradient.first)
                    
                
                let list = List {
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
                        }
                    }
                    
                    Section(header: Text("Albums")
                                .customHeader(backgroundColor: background, textColor: text)) {
                        ForEach(searchController.songs.byAlbum) { song in
                            NeoSongRow(selectedSong: selectedSong, backgroundColor: settingsController.colorScheme.backgroundGradient.first, textColor: settingsController.colorScheme.textColor.color, song: song)
                        }
                    }
                }
                
                ZStack {
                    searchController.songs.byTitle.isEmpty && searchController.songs.byArtist.isEmpty && searchController.songs.byAlbum.isEmpty ? TupleView((list.asAny(), rect.asAny())) : TupleView((rect.asAny(), list.asAny()))
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding([.top, .leading, .trailing], 16)
                .neumorph(color: settingsController.colorScheme.backgroundGradient.first.average(to: settingsController.colorScheme.backgroundGradient.last), size: .list)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SettingsController())
            .environmentObject(MusicPlayerController())
    }
}
