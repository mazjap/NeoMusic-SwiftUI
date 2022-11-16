import SwiftUI

struct NeoAlbumRow: View {
    
    // MARK: - Variables
    
    let backgroundColor: Color
    let textColor: Color
    let album: Album
    let cornerRadius: CGFloat = 20
    
    // MARK: - Body
    
    var body: some View {
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
        .spacing(.horizontal)
        .frame(height: SearchView.cellHeight)
    }
}

// MARK: - Previews

struct NeoAlbumRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NeoAlbumRow(backgroundColor: JCColorScheme.default.backgroundGradient.first, textColor: JCColorScheme.default.textColor.color, album: .noAlbum)
            
            NeoAlbumRow(backgroundColor: .falseBlack, textColor: .gray, album: .noAlbum)
            
            NeoAlbumRow(backgroundColor: .falseWhite, textColor: .gray, album: .noAlbum)
        }
    }
}
