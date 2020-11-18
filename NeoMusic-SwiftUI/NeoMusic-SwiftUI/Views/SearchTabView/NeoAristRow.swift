//
//  NeoAristRow.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/18/20.
//

import SwiftUI

struct NeoArtistRow: View {
    
    // MARK: - State
    
    @Binding var selectedArtist: Artist?
    
    // MARK: - Variables
    
    let backgroundColor: Color
    let textColor: Color
    let artist: Artist
    let cornerRadius: CGFloat = 20
    
    var gesture: some Gesture {
        TapGesture(count: 1)
            .onEnded { _ in
                selectedArtist = artist
            }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.clear
            
            HStack {
//                Image(uiImage: artist.image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .clipShape(Circle())
//                    .padding(.vertical, Constants.spacing / 2)
                
                VStack(alignment: .leading) {
                    Text(artist.name)
                        .lineLimit(1)
                        .font(.callout)
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

struct NeoArtistRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NeoArtistRow(selectedArtist: Binding<Optional<Artist>>(get: { .noArtist }, set: { _ in }), backgroundColor: JCColorScheme.default.backgroundGradient.first, textColor: JCColorScheme.default.textColor.color, artist: .noArtist)
            
            NeoArtistRow(selectedArtist: Binding<Optional<Artist>>(get: { .noArtist }, set: { _ in }), backgroundColor: .falseBlack, textColor: .gray, artist: .noArtist)
            
            NeoArtistRow(selectedArtist: Binding<Optional<Artist>>(get: { .noArtist }, set: { _ in }), backgroundColor: .falseWhite, textColor: .gray, artist: .noArtist)
        }
    }
}
