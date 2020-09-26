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
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(1), radius: 20, x: 5, y: 5)
            .shadow(color: Color.white.opacity(0.3), radius: 10, x: -5, y: -5)
    }
}

struct Neumorph_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorScheme.default.backgroundGradient.color2.color
                .ignoresSafeArea()
            
            Circle()
                .fill(Color.red)
                .neumorph()
                .padding(30)
        }
    }
}
