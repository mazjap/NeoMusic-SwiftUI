import SwiftUI

struct Message {
    let value: String
    let type: MessageType
    
}

// MARK: - Message Extension: Type

extension Message {
    enum MessageType {
        case error
        case message
        case none
        
        var color: Color {
            switch self {
            case .error:
                return .red
            case .message:
                return SettingsController.shared.colorScheme.textColor.color
            case .none:
                return .clear
            }
        }
    }
}
