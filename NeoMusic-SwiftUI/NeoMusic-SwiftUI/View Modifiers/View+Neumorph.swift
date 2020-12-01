//
//  View+Neumorph.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/9/20.
//

import SwiftUI

extension View {
    func neumorph(color: Color, size: NeumorphSize) -> some View {
        let brightness = color.perceivedBrightness
        let opacities = (black: 1 - brightness, white: brightness)
        let distance = size.distance
        let radius = size.rawValue
        
        return self
            .shadow(color: Color.black.opacity(opacities.black), radius: radius, x: distance, y: distance)
            .shadow(color: Color.white.opacity(opacities.white), radius: radius, x: -distance, y: -distance)
    }
}

enum NeumorphSize: CGFloat {
    case list = 7
    case artwork = 8
    case button = 5
    case tinyButton = 2
    case other = 6
    
    var distance: CGFloat {
        switch self {
        case .list:
            return 4
        case .artwork:
            return 8
        case .button:
            return 3
        case .tinyButton:
            return 2
        default:
            return 2
        }
    }
}
