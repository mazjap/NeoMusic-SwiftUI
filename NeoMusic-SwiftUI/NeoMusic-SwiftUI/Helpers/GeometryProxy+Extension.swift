import SwiftUI

extension GeometryProxy {
    var minSize: CGFloat {
        max(0, min(size.width, size.height))
    }
}

extension CGRect {
    var center: CGPoint {
        .init(x: origin.x + width / 2, y: origin.y + height / 2)
    }
}
