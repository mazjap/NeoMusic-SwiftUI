//
//  DefaultButtonStyle.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Round button with custom gradient and image, for UI
//

import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    private let buttonColor: Color
    private let padding: CGFloat
    private let type: ButtonType
    private let neoSize: Neumorph.Size
    private let isSelected: Bool
    
    init(color: Color, padding: CGFloat = Constants.buttonPadding, isSelected: Bool = false, type: ButtonType = .circle, neoSize: Neumorph.Size = .button) {
        self.buttonColor = color
        self.padding = padding
        self.type = type
        self.neoSize = neoSize
        self.isSelected = isSelected
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(padding)
            .if(type == .circle) {
                $0.contentShape(Circle())
            } else: {
                $0.contentShape(RoundedRectangle(cornerRadius: type.cornerRadius))
            }
            .neumorph(color: buttonColor, size: neoSize, cornerRadius: type == .circle ? .infinity : type.cornerRadius, isConcave: configuration.isPressed || isSelected)
    }
}

// MARK: - Preview

struct DefaultButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.falseWhite
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Button")
                    }
                    .buttonStyle(DefaultButtonStyle(color: .falseWhite, padding: 30))
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - DefaultButtonStyle Extension: ButtonType

extension DefaultButtonStyle {
    enum ButtonType: Equatable {
        case square
        case circle
        case roundedSquare(rawValue: CGFloat)
        
        var cornerRadius: CGFloat {
            switch self {
            case .square:
                return 0
            case .circle:
                return .infinity
            case .roundedSquare(rawValue: let val):
                return val
            }
        }
    }
}
