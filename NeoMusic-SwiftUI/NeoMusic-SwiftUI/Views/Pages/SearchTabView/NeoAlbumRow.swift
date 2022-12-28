import SwiftUI

protocol SearchResultType {
    var artwork: UIImage { get }
    var name: String { get }
}

protocol Favoritable {}

extension Album: SearchResultType {
    var name: String {
        title
    }
}

extension Artist: SearchResultType {
    var artwork: UIImage {
        .placeholder
    }
}

extension AMSong: SearchResultType {
    var artwork: UIImage {
        albumArtwork
    }
    
    var name: String {
        title
    }
    
}

struct SearchResultRow<ResultType: SearchResultType>: View {
    
    // MARK: - Variables
    
    let backgroundColor: Color
    let textColor: Color
    let result: ResultType
    let cornerRadius: CGFloat = 20
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            if let artwork = result.artwork {
                Image(uiImage: artwork)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .padding(.vertical, Constants.spacing / 2)
            }
            
            VStack(alignment: .leading) {
                Text(result.name)
                    .lineLimit(1)
                    .font(.callout)
                    .foregroundColor(textColor)
                
            }
            
            Spacer()
            
            if ResultType.self is Favoritable {
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
        .spacing(.horizontal)
        .frame(height: SearchView.cellHeight)
    }
}

// MARK: - Previews

struct NeoAlbumRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SearchResultRow(backgroundColor: JCColorScheme.default.backgroundGradient.first, textColor: JCColorScheme.default.textColor.color, result: Album.noAlbum)
            
            SearchResultRow(backgroundColor: .falseBlack, textColor: .gray, result: Album.noAlbum)
            
            SearchResultRow(backgroundColor: .falseWhite, textColor: .gray, result: Album.noAlbum)
        }
    }
}
