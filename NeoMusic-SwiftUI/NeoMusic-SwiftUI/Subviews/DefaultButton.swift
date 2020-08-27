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
    let image: String
    let imageColor: Color
    let gradient: [Color]
    let mult: CGFloat
    let action: () -> Void
    
    init(imageName: String, imageColor: Color = .white, gradientColors: [Color], mult: CGFloat = 1, action: @escaping () -> Void) {
        self.image = imageName
        self.imageColor = imageColor
        self.gradient = gradientColors
        self.mult = mult
        self.action = action
        
    }
    
    var body: some View {
        let buttonSize = UIScreen.main.bounds.size.width / 5.5 * mult
        
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: gradient), startPoint: .topLeading, endPoint: .bottomTrailing))
                
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: gradient.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: buttonSize * 0.95, height: buttonSize * 0.95)
                
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(imageColor)
                    .frame(width: buttonSize * 0.35, height: buttonSize * 0.35)
            }
        }
        .frame(width: buttonSize, height: buttonSize)
    }
}

struct DefaultButton_Previews: PreviewProvider {
    static var previews: some View {
        let previewSize = UIScreen.main.bounds.size.width / 5
        
        DefaultButton(imageName: "play.fill", gradientColors: Constants.defaultColorScheme.backgroundGradient.colors) {
            
        }
        .previewLayout(.fixed(width: previewSize, height: previewSize))
    }
}
