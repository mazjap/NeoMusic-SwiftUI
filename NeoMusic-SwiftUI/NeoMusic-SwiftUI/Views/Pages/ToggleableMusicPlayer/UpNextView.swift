//
//  UpNextView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/18/20.
//

import SwiftUI

struct UpNextView: View {
    @EnvironmentObject private var musicController: MusicController
    
    @State private var selectedSong: AMSong = .noSong
    @State private var selectedIndex: IndexPath = .zero
    @State private var section: Section = .current
    
    let colorScheme: JCColorScheme
    
    var body: some View {
        ScrollViewReader { reader in
            Table(selectedIndexPath: $selectedIndex.onChanged(selectionChanged(to:))) {
                ForEach(musicController.upNextSongs, id: \.id) { song in
                    BasicTableCell(label: song.title, detail: song.artist, image: Image(uiImage: song.albumArtwork))
                        .foregroundColor(colorScheme.backgroundGradient.last)
                }
            }
            .foregroundColor(colorScheme.textColor.color)
            .background(colorScheme.backgroundGradient.last)
        }
    }
    
    private func selectionChanged(to index: IndexPath) {
        selectedSong = AMSong(musicController.item(at: musicController.currentIndex + index.item))
        // TODO: - Use musicController to play selected item
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
