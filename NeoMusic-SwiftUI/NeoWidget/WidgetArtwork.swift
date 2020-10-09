//
//  WidgetArtwork.swift
//  NeoWidgetExtension
//
//  Created by Jordan Christensen on 9/2/20.
//

import SwiftUI

struct WidgetArtwork: View {
    let colorScheme: JCColorScheme
    let image: Image
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: colorScheme.backgroundGradient.colors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .shadow(color: Color.black.opacity(1), radius: 20, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.3), radius: 10, x: -5, y: -5)
                
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.95)
                    .clipShape(Circle())
            }
        }
    }
}

struct WidgetArtwork_Previews: PreviewProvider {
    static var previews: some View {
        WidgetArtwork(colorScheme: Constants.defaultColorScheme, image: .placeholder)
    }
}
