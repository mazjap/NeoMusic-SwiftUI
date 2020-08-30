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
    
    let image: String
    let mult: CGFloat
    let gradientColors: [Color]
    let buttonColor: Color
    let action: () -> Void
    
    // MARK: - Initializer
    
    init(imageName: String, gradient: [Color], buttonColor: Color, mult: CGFloat = 1, action: @escaping () -> Void) {
        self.image = imageName
        self.mult = mult
        self.gradientColors = gradient
        self.buttonColor = buttonColor
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            let size = UIScreen.main.bounds.width / 5.5 * mult
            
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: gradientColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .shadow(color: Color.black.opacity(1), radius: 20, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.3), radius: 10, x: -5, y: -5)
                
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: size * 0.95, height: size * 0.95)
                
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(buttonColor)
                    .frame(width: size * 0.35, height: size * 0.35)
            }
            .frame(width: size, height: size)
        }
    }
}

// MARK: - Preview

struct DefaultButton_Previews: PreviewProvider {
    static var previews: some View {
        DefaultButton(imageName: "play.fill", gradient: Constants.defaultColorScheme.backgroundGradient.colors, buttonColor: .white) {
            
        }
        .previewLayout(.fixed(width: 100, height: 100))
    }
}
