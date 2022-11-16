import SwiftUI

extension AnyTransition {
    static var scaleAndSlide = Self.slide.combined(with: .scale)
}
