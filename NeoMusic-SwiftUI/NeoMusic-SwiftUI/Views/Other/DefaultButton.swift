//
//  DefaultButton.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Round button with custom gradient and image, for UI
//

import SwiftUI

struct DefaultButton: View {
    
    // MARK: - Variables
    
    private let isSelected: Bool
    private let image: Image
    private let imageColor: Color
    private let buttonColor: Color
    private let size: CGFloat
    private let type: ButtonType
    private let neoSize: Neumorph.Size
    private let action: () -> Void
    
    var cornerRadius: CGFloat {
        type.cornerRadius(size: size)
    }
    
    // MARK: - Initializers
    
    init(image: Image, imageColor: Color, buttonColor: Color, type: ButtonType = .circle, neoSize: Neumorph.Size = .button, mult: CGFloat = 1, isSelected: Bool = false, action: @escaping () -> Void) {
        self.image = image
        self.imageColor = imageColor
        self.buttonColor = buttonColor
        self.size = (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) / 6 * mult
        self.type = type
        self.neoSize = neoSize
        self.isSelected = isSelected
        self.action = action
    }
    
    init(imageName: String, imageColor: Color, buttonColor: Color, type: ButtonType = .circle, neoSize: Neumorph.Size = .button, mult: CGFloat = 1, isSelected: Bool = false, action: @escaping () -> Void) {
        self.init(image: Image(systemName: imageName), imageColor: imageColor, buttonColor: buttonColor, type: type, mult: mult, isSelected: isSelected, action: action)
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    LinearGradient(gradient: Gradient(colors: buttonColor.offsetColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .clipShape(Circle())
                } else {
                    buttonColor
                        .cornerRadius(cornerRadius)
                        .neumorph(color: buttonColor, size: neoSize)
                }
                    
                
                image
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(imageColor)
                    .frame(width: size * 0.35, height: size * 0.35)
            }
            .frame(width: size, height: size)
        }
    }
}

// MARK: - Preview

struct DefaultButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.falseWhite
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    
                    DefaultButton(imageName: "backward.fill", imageColor: .blue, buttonColor: .falseWhite, action: {})
                    
                    Spacer()
                    
                    DefaultButton(imageName: "pause.fill", imageColor: .blue, buttonColor: .falseWhite, isSelected: true, action: {})
                    
                    Spacer()
                    
                    DefaultButton(imageName: "forward.fill", imageColor: .blue, buttonColor: .falseWhite, action: {})
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - DefaultButton Extension: ButtonType

extension DefaultButton {
    enum ButtonType {
        case square
        case circle
        case roundedSquare(rawValue: CGFloat)
        
        func cornerRadius(size: CGFloat) -> CGFloat {
            switch self {
            case .square:
                return 0
            case .circle:
                return size / 2
            case .roundedSquare(rawValue: let val):
                if val > size / 2 {
                    return size / 2
                } else if val < 0 {
                    return 0
                }
                
                return val
            }
        }
    }
}
