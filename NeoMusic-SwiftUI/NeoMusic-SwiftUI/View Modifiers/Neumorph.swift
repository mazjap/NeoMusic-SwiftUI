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
    
    // MARK: - Variables
    
    private let opacities: (black: Double, white: Double)
    private let distance: CGFloat
    private let radius: CGFloat
    
    // MARK: - Initializer
    
    init(color: Color?, size: Size) {
        if let color = color {
            let brightness = color.perceivedBrightness
            self.opacities = (1 - brightness, brightness)
        } else {
            self.opacities = Self.noOpacity
        }
        self.distance = size.distance
        self.radius = size.rawValue
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        ZStack {
            if opacities == Self.noOpacity {
                content
            } else {
                content
                    .shadow(color: Color.black.opacity(opacities.black), radius: radius, x: distance, y: distance)
                    .shadow(color: Color.white.opacity(opacities.white), radius: radius, x: -distance, y: -distance)
            }
        }
    }
    
    static private let noOpacity = (Double.zero, Double.zero)
}

// MARK: - Preview

struct Neumorph_Previews: PreviewProvider {
    static var previews: some View {
//        VStack(spacing: 0) {
//            ZStack {
//                Color.blue
//                    .ignoresSafeArea()
//                HStack {
//                    Spacer()
//
//                    DefaultButton(imageName: "location.north.fill", imageColor: .white, buttonColor: .blue, type: .circle) {}
//
//                    Spacer()
//
//                    DefaultButton(imageName: "bolt.slash.circle.fill", imageColor: .white, buttonColor: .blue, type: .roundedSquare(rawValue: 20)) {}
//
//                    Spacer()
//
//                    DefaultButton(imageName: "bubble.right.fill", imageColor: .white, buttonColor: .blue, type: .square) {}
//
//                    Spacer()
//                }
//            }
//
//            ZStack {
//                Color.falseBlack
//                    .ignoresSafeArea()
//                HStack {
//                    Spacer()
//
//                    DefaultButton(imageName: "paperplane.circle.fill", imageColor: .gray, buttonColor: .falseBlack, type: .circle) {}
//
//                    Spacer()
//
//                    DefaultButton(imageName: "externaldrive.fill.badge.checkmark", imageColor: .gray, buttonColor: .falseBlack, type: .roundedSquare(rawValue: 20)) {}
//
//                    Spacer()
//
//                    DefaultButton(imageName: "terminal.fill", imageColor: .gray, buttonColor: .falseBlack, type: .square) {}
//
//                    Spacer()
//                }
//            }
//
//            ZStack {
//                Color.falseWhite
//                    .ignoresSafeArea()
//                HStack {
//                    Spacer()
//
//                    DefaultButton(imageName: "magnifyingglass", imageColor: .gray, buttonColor: .falseWhite, type: .circle) {}
//
//                    Spacer()
//
//                    DefaultButton(imageName: "newspaper.fill", imageColor: .gray, buttonColor: .falseWhite, type: .roundedSquare(rawValue: 20)) {}
//
//                    Spacer()
//
//                    DefaultButton(imageName: "circle.fill.square.fill", imageColor: .gray, buttonColor: .falseWhite, type: .square) {}
//
//                    Spacer()
//                }
//            }
//
//            ZStack {
//                Color.red
//                    .ignoresSafeArea()
//                HStack {
//                    Spacer()
//
//                    DefaultButton(imageName: "phone.down.circle.fill", imageColor: .white, buttonColor: .red, type: .circle) {}
//
//                    Spacer()
//
//                    DefaultButton(imageName: "opticaldisc", imageColor: .white, buttonColor: .red, type: .roundedSquare(rawValue: 20)) {}
//
//                    Spacer()
//
//                    DefaultButton(imageName: "tv.fill", imageColor: .white, buttonColor: .red, type: .square) {}
//
//                    Spacer()
//                }
//            }
//        }
        
        Text("")
    }
}

// MARK: - Neumorph Extension: Size

extension Neumorph {
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
