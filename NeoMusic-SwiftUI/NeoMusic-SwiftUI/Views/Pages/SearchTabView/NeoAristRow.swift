import SwiftUI

struct NeoArtistRow: View {
    
    // MARK: - Variables
    
    let backgroundColor: Color
    let textColor: Color
    let artist: Artist
    let cornerRadius: CGFloat = 20
    
    // MARK: - Body
    
    var body: some View {
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
        .spacing(.horizontal)
        .frame(height: SearchView.cellHeight)
    }
}

// MARK: - Previews

struct NeoArtistRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NeoArtistRow(backgroundColor: JCColorScheme.default.backgroundGradient.first, textColor: JCColorScheme.default.textColor.color, artist: .noArtist)
            
            NeoArtistRow(backgroundColor: .falseBlack, textColor: .gray, artist: .noArtist)
            
            NeoArtistRow(backgroundColor: .falseWhite, textColor: .gray, artist: .noArtist)
        }
    }
}
