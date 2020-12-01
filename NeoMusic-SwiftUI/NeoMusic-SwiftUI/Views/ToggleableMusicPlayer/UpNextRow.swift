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
        ZStack {
            colorScheme.backgroundGradient.last
            
            HStack(spacing: 7) {
                Image(uiImage: song.artwork)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Self.rowHeight - 5, height: Self.rowHeight - 5)
                    .clipShape(Circle())
                    .spacing(.leading)
                
                VStack(alignment: .leading) {
                    Text(song.title)
                        .font(.body)
                        .foregroundColor(colorScheme.textColor.color)
                        
                    Text(song.artistName)
                        .font(.caption)
                        .foregroundColor(colorScheme.textColor.color)
                }
                .spacing(.vertical)
                
                Spacer()
            }
        }
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
