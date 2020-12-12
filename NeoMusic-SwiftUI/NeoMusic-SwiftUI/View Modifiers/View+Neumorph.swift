//
//  View+Neumorph.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/9/20.
//

import SwiftUI

struct Neumorph: ViewModifier {
    let color: Color
    let size: Size
    let cornerRadius: CGFloat
    let isConcave: Bool
    
    func body(content: Content) -> some View {
        let brightness = 0.1 + 0.8 * color.perceivedBrightness
        let opacities = (black: 1 - brightness, white: brightness)
        let distance = size.distance
        let radius = size.rawValue
        
        
        let shape = (cornerRadius == .infinity ? Circle().asAnyShape() : RoundedRectangle(cornerRadius: cornerRadius).asAnyShape())
        
        return content
                .background(
                    Group {
                        if isConcave {
                        shape
                            .fill(color)
                            .overlay(
                                shape
                                    .strokeBorder(Color.black.opacity(opacities.black), lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: size.rawValue, y: size.rawValue)
                                    .mask(shape.fill(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(opacities.black), .clear]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                                )
                                .overlay(
                                    shape
                                        .stroke(Color.white.opacity(opacities.white), lineWidth: 8)
                                        .blur(radius: 4)
                                        .offset(x: -size.rawValue, y: -size.rawValue)
                                        .mask(shape.fill(LinearGradient(gradient: Gradient(colors: [.clear, Color.black.opacity(opacities.white)]), startPoint: .topLeading, endPoint: .bottomTrailing)))

                                )
                        } else {
                            shape
                                .fill(color)
                                .shadow(color: Color.black.opacity(opacities.black), radius: radius, x: distance, y: distance)
                                .shadow(color: Color.white.opacity(opacities.white), radius: radius, x: -distance, y: -distance)
                        }
                    }
        )
    }
    
    enum Size: CGFloat {
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
}

extension View {
    func neumorph(color: Color, size: Neumorph.Size, cornerRadius: CGFloat, isConcave: Bool) -> some View {
        return self
            .modifier(Neumorph(color: color, size: size, cornerRadius: cornerRadius, isConcave: isConcave))
    }
}
