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
            Table {
                ForEach(musicController.upNextSongs) { song in
                    UpNextRow(selectedSong: $selectedSong.onChanged(selectionChanged(_:)), song: song, colorScheme: colorScheme)
                }
            }
            .foregroundColor(colorScheme.textColor.color)
            .background(colorScheme.backgroundGradient.last)
        }
    }
    
    private func selectionChanged(_ newVal: Song) {
        musicController.changeCurrentIndex(to: newVal)
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
