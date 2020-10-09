//
//  SearchView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 9/30/20.
//

import SwiftUI

struct SearchView: View {
    @State var text: String = ""
    
    @EnvironmentObject var settingsController: SettingsController
    @ObservedObject var musicController: MusicPlayerController
    @ObservedObject var searchController = SongSearchController()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)

            VStack {
                SearchBar(searchText: $text, font: nil, colorScheme: settingsController.colorScheme, onEditingChanged: { _ in }, onCommit: { searchController.searchTerm = text })
                    .resignsFirstResponderOnDrag()
                    .frame(height: 50)
                    .padding(16)
                
//                ScrollView(.vertical, showsIndicators: false) {
//                    ForEach(searchController.songsByTitle) { song in
//                        NeoRow(colorScheme: settingsController.colorScheme, song: song)
//                    }
//
//                    ForEach(searchController.songsByArtist) { song in
//                        NeoRow(colorScheme: settingsController.colorScheme, song: song)
//                    }
//
//                    ForEach(searchController.songsByArtist) { song in
//                        NeoRow(colorScheme: settingsController.colorScheme, song: song)
//                    }
//                }
                
                List {
                    Section(header: Text("Titles")) {
                        ForEach(searchController.songsByTitle) { song in
                            NeoSongRow(backgroundColor: settingsController.colorScheme.backgroundGradient.first, textColor: settingsController.colorScheme.textColor.color, song: song)
                                .padding(.horizontal)
                        }
                    }

                    Section(header: Text("Artists")) {
                        ForEach(searchController.songsByArtist) { song in
                            NeoSongRow(backgroundColor: settingsController.colorScheme.backgroundGradient.first, textColor: settingsController.colorScheme.textColor.color, song: song)
                        }
                    }

                    Section(header: Text("Albums")) {
                        ForEach(searchController.songsByArtist) { song in
                            NeoSongRow(backgroundColor: settingsController.colorScheme.backgroundGradient.first, textColor: settingsController.colorScheme.textColor.color, song: song)
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding([.top, .leading, .trailing], 16)
                .neumorph(color: settingsController.colorScheme.backgroundGradient.first, size: .list)
            }
        }
    }
    
    func timerFired() {
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(musicController: MusicPlayerController())
    }
}
