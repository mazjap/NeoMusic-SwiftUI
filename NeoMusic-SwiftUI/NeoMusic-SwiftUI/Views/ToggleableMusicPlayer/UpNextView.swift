//
//  UpNextView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/18/20.
//

import SwiftUI

struct UpNextView: View {
    @EnvironmentObject private var musicController: MusicPlayerController
    
    @State var selectedSong: Song = .noSong
    @State var section: Section = .current
    
    let colorScheme: JCColorScheme
    
    var body: some View {
        ScrollViewReader { reader in
            List {
                ForEach(musicController.upNextSongs) { song in
                    UpNextRow(selectedSong: Binding<Song>(get: { return selectedSong }, set: { newValue in
                        selectedSong = newValue
                        musicController.changeCurrentIndex(to: song)
                    }), song: song, colorScheme: colorScheme)
                }
            }
        }
    }
}

struct UpNextView_Previews: PreviewProvider {
    static var previews: some View {
        UpNextView(colorScheme: .default)
    }
}

extension UpNextView {
    enum Section: String {
        case previous = "Perviously Played"
        case current = "Currently Playing"
        case next = "Up Next"
    }
}
