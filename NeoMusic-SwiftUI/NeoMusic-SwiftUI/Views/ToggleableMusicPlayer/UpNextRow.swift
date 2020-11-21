//
//  UpNextRow.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/19/20.
//

import SwiftUI

struct UpNextRow: View {
    @Binding var selectedSong: Song
    
    let song: Song
    let colorScheme: JCColorScheme
    
    var body: some View {
        HStack(spacing: 7) {
            Image(uiImage: song.artwork)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .spacing(.vertical)
            
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.body)
                    .foregroundColor(colorScheme.textColor.color)
                    
                Text(song.artistName)
                    .font(.caption)
                    .foregroundColor(colorScheme.textColor.color)
            }
            .spacing(.vertical)
        }
        .listRowBackground(colorScheme.backgroundGradient.last)
        .frame(height: Self.rowHeight)
    }
    
    static let rowHeight: CGFloat = 30
}

struct UpNextRow_Previews: PreviewProvider {
    @State static var selected: Song = .noSong
    
    static var previews: some View {
        UpNextRow(selectedSong: $selected, song: selected, colorScheme: .default)
    }
}
