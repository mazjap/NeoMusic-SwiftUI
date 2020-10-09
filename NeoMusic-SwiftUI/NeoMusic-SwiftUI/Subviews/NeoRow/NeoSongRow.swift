//
//  NeoSongRow.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/2/20.
//

import SwiftUI

struct NeoSongRow: View {
    let backgroundColor: Color
    let textColor: Color
    let song: Song
    let cornerRadius: CGFloat = 20
    let height = UIScreen.main.bounds.height / 10
    
    var body: some View {
        HStack {
            song.artwork
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .padding(.vertical, 8)
            
            VStack(alignment: .leading) {
                Text(song.title)
                    .lineLimit(1)
                    .font(.title)
                    .foregroundColor(textColor)
                
                Text(song.artist)
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundColor(textColor)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(textColor)
            }
            .padding(.vertical, height / 2 - 10)
            .padding(.horizontal, 8)
            
        }
        .listRowBackground(LinearGradient(gradient: Gradient(colors: backgroundColor.offsetColors), startPoint: .top, endPoint: .bottom))
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

struct NeoListItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NeoSongRow(backgroundColor: JCColorScheme.default.backgroundGradient.first, textColor: JCColorScheme.default.textColor.color, song: .noSong)
            
            NeoSongRow(backgroundColor: .falseBlack, textColor: .gray, song: .noSong)
            
            NeoSongRow(backgroundColor: .falseWhite, textColor: .gray, song: .noSong)
        }
    }
}
