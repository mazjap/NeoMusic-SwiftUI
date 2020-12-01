//
//  NeoSongRow.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/2/20.
//

import SwiftUI

struct NeoSongRow: View {
    
    // MARK: - State
    
    @Binding var selectedSong: Song?
    
    // MARK: - Variables
    
    let backgroundColor: Color
    let textColor: Color
    let song: Song
    let cornerRadius: CGFloat = 20
    
    var gesture: some Gesture {
        TapGesture(count: 1)
            .onEnded { _ in
                selectedSong = song
            }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: backgroundColor.offsetColors), startPoint: .top, endPoint: .bottom)
                .cornerRadius(20)
            
            HStack {
                song.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .padding(.vertical, Constants.spacing / 2)
                
                VStack(alignment: .leading) {
                    Text(song.title)
                        .lineLimit(1)
                        .font(.callout)
                        .foregroundColor(textColor)
                    
                    Text(song.artistName)
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(textColor)
                }
                
                Spacer()
                
                Button(action: {
                    // TODO: Add/Remove song to/from favorites
                }) {
                    Image(systemName: song.isFavorite ?? false ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(song.isFavorite ?? false ? Color.red : textColor)
                }
                .padding(.vertical, SearchView.cellHeight / 3)
                .padding(.horizontal, Constants.spacing / 2)
                
            }
            .padding(.horizontal, Constants.spacing / 2)
        }
        .frame(height: SearchView.cellHeight)
        .padding(.bottom, 10)
        .gesture(gesture)
    }
}

// MARK: - Previews

struct NeoSongRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NeoSongRow(selectedSong: Binding<Optional<Song>>(get: { .noSong }, set: { _ in }), backgroundColor: JCColorScheme.default.backgroundGradient.first, textColor: JCColorScheme.default.textColor.color, song: .noSong)
            
            NeoSongRow(selectedSong: Binding<Optional<Song>>(get: { .noSong }, set: { _ in }), backgroundColor: .falseBlack, textColor: .gray, song: .noSong)
            
            NeoSongRow(selectedSong: Binding<Optional<Song>>(get: { .noSong }, set: { _ in }), backgroundColor: .falseWhite, textColor: .gray, song: .noSong)
        }
    }
}
