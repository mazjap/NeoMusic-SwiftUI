import SwiftUI

struct NeoSongRow: View {
    
    // MARK: - State
    
    @EnvironmentObject private var musicController: MusicController
    
    // MARK: - Variables
    
    let backgroundColor: Color
    let textColor: Color
    let song: AMSong
    let cornerRadius: CGFloat = 20
    
    // MARK: - Body
    
    var body: some View {
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
                
                Text(song.artist)
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundColor(textColor)
            }
            
            Spacer()
            
            Button(action: {
                // TODO: Add/Remove song to/from favorites
            }) {
                // TODO: Use user controller to check if song is favorite
                Image(systemName: false ? "heart.fill" : "heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(false ? Color.red : textColor)
            }
            .padding(.vertical, SearchView.cellHeight / 3)
        }
        .spacing(.horizontal)
        .frame(height: SearchView.cellHeight)
    }
}

// MARK: - Previews

struct NeoSongRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NeoSongRow(backgroundColor: JCColorScheme.default.backgroundGradient.first, textColor: JCColorScheme.default.textColor.color, song: .noSong)
            
            NeoSongRow(backgroundColor: .falseBlack, textColor: .gray, song: .noSong)
            
            NeoSongRow(backgroundColor: .falseWhite, textColor: .gray, song: .noSong)
        }
    }
}
