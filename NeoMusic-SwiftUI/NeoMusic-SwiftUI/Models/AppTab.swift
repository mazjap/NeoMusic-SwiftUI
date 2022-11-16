import SwiftUI

enum AppTab: String, CaseIterable, Tabbable {
    case search = "String"
    case music = "Music"
    case profile = "Profile"
    
    var image: Image {
        let imageName: String = {
            switch self {
            case .search:
                return "magnifyingglass"
            case .music:
                return "play.fill"
            case .profile:
                return "person.fill"
            }
        }()
        
        return Image(systemName: imageName)
    }
}
