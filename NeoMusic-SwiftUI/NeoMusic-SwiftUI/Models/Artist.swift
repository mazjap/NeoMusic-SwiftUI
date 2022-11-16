import MediaPlayer

struct Artist: Identifiable {
    
    // MARK: - Variables
    
    let name: String
    let albums: [Album]
    let id: String
    
    var items: [Song] {
        var songList = [Song]()
        
        for album in albums {
            songList += album.items
        }
        
        return songList
    }
    
    var persistentID: UInt64 {
        UInt64(id) ?? 0
    }
    
    // MARK: - Initializers
    
    init(name: String? = nil, albums: [Album] = [], id: UInt64 = 0) {
        if let name = name {
            self.name = name
        } else {
            self.name = Constants.noArtist
        }
        
        self.albums = albums
        self.id = "\(id)"
    }
    
    // MARK: - Static Variables
    
    static let noArtist = Artist()
}

extension Artist: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case relationships
        case attributes
        
        enum RelationshipsCodingKeys: String, CodingKey {
            case albums
            
            enum AlbumsCodingKeys: String, CodingKey {
                case data
            }
        }
        
        enum AttributesCodingKeys: String, CodingKey {
            case name
        }
    }
    
    init(from decoder: Decoder) throws {
        var name = Constants.noArtist
        var id: UInt64 = 0
        var albums = [Album]()
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let relationshipsContainer = try container.nestedContainer(keyedBy: CodingKeys.RelationshipsCodingKeys.self, forKey: .relationships)
            let attributesContainer = try container.nestedContainer(keyedBy: CodingKeys.AttributesCodingKeys.self, forKey: .attributes)
            let albumsContainer = try relationshipsContainer.nestedContainer(keyedBy: CodingKeys.RelationshipsCodingKeys.AlbumsCodingKeys.self, forKey: .albums)
            
            name = try attributesContainer.decode(String.self, forKey: .name)
            albums = try albumsContainer.decode([Album].self, forKey: .data)
        } catch {
            NSLog("Unable to create Artist from json data: \(error)")
        }
        
        self.name = name
        self.id = "\(id)"
        self.albums = albums
    }
}
