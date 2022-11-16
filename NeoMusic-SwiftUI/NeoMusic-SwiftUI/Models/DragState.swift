import CoreGraphics

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var isDragging: Bool {
        if case .dragging = self {
            return true
        }
        
        return false
    }
    
    var width: CGFloat {
        if case let .dragging(translation) = self {
            return translation.width
        }
        
        return 0
    }
    
    var height: CGFloat {
        if case let .dragging(translation) = self {
            return translation.height
        }
        
        return 0
    }
}
