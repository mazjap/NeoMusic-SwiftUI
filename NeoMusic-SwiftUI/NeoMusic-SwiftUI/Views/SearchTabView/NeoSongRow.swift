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
            
            Color.clear
            
            HStack {
                song.artwork
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .padding(.vertical, Constants.spacing / 2)
                
                VStack(alignment: .leading) {
                    Text(song.title)
                        .lineLimit(1)
                        .font(.callout)
                        .foregroundColor(textColor)
                    
                    Text(song.artist)
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(textColor)
                }
                
                Spacer()
                
                Button(action: {
                    // TODO: Add/Remove song to/from favorites
                }) {
                    Image(systemName: "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(textColor)
                }
                .padding(.vertical, SearchView.cellHeight / 2)
                .padding(.horizontal, Constants.spacing / 2)
                
            }
        }
        .listRowBackground(LinearGradient(gradient: Gradient(colors: backgroundColor.offsetColors), startPoint: .top, endPoint: .bottom)
                            .clipped()
                            .cornerRadius(20)
                            .padding(.horizontal, 5)
                            .gesture(gesture))
        .frame(height: SearchView.cellHeight)
        .gesture(gesture)
    }
}

// MARK: - Previews

struct NeoListItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NeoSongRow(selectedSong: Binding<Optional<Song>>(get: { .noSong }, set: { _ in }), backgroundColor: JCColorScheme.default.backgroundGradient.first, textColor: JCColorScheme.default.textColor.color, song: .noSong)
            
            NeoSongRow(selectedSong: Binding<Optional<Song>>(get: { .noSong }, set: { _ in }), backgroundColor: .falseBlack, textColor: .gray, song: .noSong)
            
            NeoSongRow(selectedSong: Binding<Optional<Song>>(get: { .noSong }, set: { _ in }), backgroundColor: .falseWhite, textColor: .gray, song: .noSong)
        }
    }
}
