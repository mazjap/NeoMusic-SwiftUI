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
    
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var musicController: MusicPlayerController
    @EnvironmentObject private var feedback: FeedbackGenerator
    
    @ObservedObject var searchController: SongSearchController
    
    let offsetHeight: CGFloat = 20
    
    init(searchController: SongSearchController) {
        self.searchController = searchController
        self.text = searchController.searchTerm
        
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
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
                        Spacer()
                    }
                }
                
                Section(header: Text("Albums")
                            .customHeader(backgroundColor: background, textColor: text)) {
                    ForEach(searchController.songs.byAlbum) { song in
                        NeoSongRow(selectedSong: selectedSong, backgroundColor: settingsController.colorScheme.backgroundGradient.first, textColor: settingsController.colorScheme.textColor.color, song: song)
                    }
                    
                    Rectangle()
                        .frame(height: offsetHeight / 2 + 100)
                        .foregroundColor(settingsController.colorScheme.backgroundGradient.first)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .asAny()
                
            
            GeometryReader { geometry in
                ZStack {
                    searchController.songs.byTitle.isEmpty && searchController.songs.byArtist.isEmpty && searchController.songs.byAlbum.isEmpty ? TupleView((list.asAny(), rect.asAny())) : TupleView((rect.asAny(), list.asAny()))
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchController: SongSearchController())
            .environmentObject(SettingsController())
            .environmentObject(MusicPlayerController())
    }
}
