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
    let padding: CGFloat = 2
    
    var body: some View {
        GeometryReader { geometry in
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: colorScheme.backgroundGradient.colors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .padding(padding)
                    )
                    .neumorph(color: colorScheme.backgroundGradient.first.average(to: colorScheme.backgroundGradient.last), size: .button, cornerRadius: .infinity, isConcave: false)
        }
    }
    
}

struct WidgetArtwork_Previews: PreviewProvider {
    static var previews: some View {
        WidgetArtwork(colorScheme: Constants.defaultColorScheme, image: .placeholder)
    }
}
