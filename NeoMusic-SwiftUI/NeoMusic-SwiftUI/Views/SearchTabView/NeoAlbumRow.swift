//
//  NeoAlbumRow.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/18/20.
//

import SwiftUI

struct NeoAlbumRow: View {
    
    // MARK: - State
    
    @Binding var selectedAlbum: Album?
    
    // MARK: - Variables
    
    let backgroundColor: Color
    let textColor: Color
    let album: Album
    let cornerRadius: CGFloat = 20
    
    var gesture: some Gesture {
        TapGesture(count: 1)
            .onEnded { _ in
                selectedAlbum = album
            }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.clear
            
            HStack {
                Image(uiImage: album.artwork)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .padding(.vertical, Constants.spacing / 2)
                
                VStack(alignment: .leading) {
                    Text(album.title)
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

struct NeoAlbumRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NeoAlbumRow(selectedAlbum: Binding<Optional<Album>>(get: { .noAlbum }, set: { _ in }), backgroundColor: JCColorScheme.default.backgroundGradient.first, textColor: JCColorScheme.default.textColor.color, album: .noAlbum)
            
            NeoAlbumRow(selectedAlbum: Binding<Optional<Album>>(get: { .noAlbum }, set: { _ in }), backgroundColor: .falseBlack, textColor: .gray, album: .noAlbum)
            
            NeoAlbumRow(selectedAlbum: Binding<Optional<Album>>(get: { .noAlbum }, set: { _ in }), backgroundColor: .falseWhite, textColor: .gray, album: .noAlbum)
        }
    }
}
