//
//  Neumorph.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 9/26/20.
//
//  Purpose:
//  ViewModifier that adds black and white shadow to some view
//

import SwiftUI

struct Neumorph: ViewModifier {
    let opacities: (black: Double, white: Double)
    let distance: CGFloat
    
    init(color: Color, size: Size) {
        let brightness = color.perceivedBrightness
        
        self.opacities = (1 - brightness, brightness)
        self.distance = size.distance
    }
    
    func body(content: Content) -> some View {
        ZStack {
        content
            .shadow(color: Color.black.opacity(opacities.black), radius: 3, x: distance - 1, y: distance - 1)
            .shadow(color: Color.white.opacity(opacities.white), radius: 4, x: -distance, y: -distance)
        }
    }
}

struct Neumorph_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ZStack {
                Color.falseWhite
                    .ignoresSafeArea()
            
                DefaultButton(imageName: "play.fill", imageColor: .gray, buttonColor: .falseWhite, type: .circle) {
                    print("Button pressed")
                }
            }
            
            ZStack {
                Color.falseBlack
                    .ignoresSafeArea()
                
                DefaultButton(imageName: "pause.fill", imageColor: .gray, buttonColor: .falseBlack, type: .square) {
                    print("Button pressed")
                }
            }
            
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                
                DefaultButton(imageName: "magnifyingglass", imageColor: .gray, buttonColor: .blue, type: .roundedSquare(rawValue: 20)) {
                    print("Button pressed")
                }
            }
        }
    }
}

extension Neumorph {
    enum Size: CGFloat {
        case artwork = 20
        case button = 12
        case other = 10
        
        var distance: CGFloat {
            switch self {
            case .artwork:
                return 8
            case .button:
                return 3
            default:
                return 2
            }
        }
    }
}
