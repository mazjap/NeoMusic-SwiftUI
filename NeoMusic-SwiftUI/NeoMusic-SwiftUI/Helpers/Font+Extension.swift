import SwiftUI

extension Font {
    var size: CGFloat {
        let font: UIFont
        
        switch self {
        case .callout:
            font = UIFont.preferredFont(forTextStyle: .callout)
        case .caption:
            font = UIFont.preferredFont(forTextStyle: .caption1)
        case .caption2:
            font = UIFont.preferredFont(forTextStyle: .caption2)
        case .footnote:
            font = UIFont.preferredFont(forTextStyle: .footnote)
        case .headline:
            font = UIFont.preferredFont(forTextStyle: .headline)
        case .largeTitle:
            font = UIFont.preferredFont(forTextStyle: .largeTitle)
        case .subheadline:
            font = UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            font = UIFont.preferredFont(forTextStyle: .title1)
        case .title2:
            font = UIFont.preferredFont(forTextStyle: .title2)
        case .title3:
            font = UIFont.preferredFont(forTextStyle: .title3)
        default: // Handle body and other cases
            font = UIFont.preferredFont(forTextStyle: .body)
        }
        
        return font.lineHeight
    }
}
