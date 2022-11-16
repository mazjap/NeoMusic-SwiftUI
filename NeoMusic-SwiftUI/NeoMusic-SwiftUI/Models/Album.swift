import MediaPlayer
import SwiftUI

struct Album: Identifiable {
    // MARK: - Variables
    
    let title: String
    let artist: String
    var artwork: UIImage
    let items: [Song]
    
    let id: String
    
    var persistentID: UInt64 {
        UInt64(id) ?? 0
    }
    
    // MARK: - Initializers
    
    init(title: String? = nil, artwork: UIImage? = nil, items: [AMSong] = [], id: UInt64 = 0) {
        if let title = title {
            self.title = title
        } else {
            self.title = Constants.noAlbum
        }
        
        if let artwork = artwork {
            self.artwork = artwork
        } else {
            self.artwork = .placeholder
        }
        
        self.items = items
        self.id = "\(id)"
        self.artist = items.first?.artist ?? Constants.noArtist
    }
    
    // Static Functions
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    // Static Variables
    
    static let noAlbum = Album()
}

extension Album: Decodable {
    enum CodingKeys: String, CodingKey {
        case attributes
        case storeID = "id"
    }
    
    enum AttributesCodingKeys: String, CodingKey {
        case title = "name"
        case artist = "artistName"
        case items
        
        case artwork
    }
    
    enum ArtworkCodingKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        var title: String = Constants.noAlbum
        var image: UIImage = .placeholder
        var artist: String = Constants.noArtist
        var id: String = ""
        var items = [Song]()
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let attributesContainer = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
            let artworkContainer = try attributesContainer.nestedContainer(keyedBy: ArtworkCodingKeys.self, forKey: .artwork)
            
            let urlString = try artworkContainer.decode(String.self, forKey: .url)
                .replacingOccurrences(of: "{w}", with: "500")
                .replacingOccurrences(of: "{h}", with: "500")
            
            
            if let url = URL(string: urlString), let img = try UIImage(data: Data(contentsOf: url)) {
                image = img
            }
            
            title = try attributesContainer.decode(String.self, forKey: .title)
            artist = try attributesContainer.decode(String.self, forKey: .artist)
            id = try container.decode(String.self, forKey: .storeID)
        
        } catch {
            NSLog("f:\(#file)l:\(#line) Error: \(error)")
        }
        
        self.title = title
        self.artwork = image
        self.id = id
        self.items = items
        self.artist = artist
    }
}
