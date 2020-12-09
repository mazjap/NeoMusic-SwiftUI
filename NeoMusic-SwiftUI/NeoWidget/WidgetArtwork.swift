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
                    .neumorph(color: colorScheme.backgroundGradient.first.average(to: colorScheme.backgroundGradient.last), size: .button)
                
                image
                    .resizable()
                    .scaledToFit()
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
