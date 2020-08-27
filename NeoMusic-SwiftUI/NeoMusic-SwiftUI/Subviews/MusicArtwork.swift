//
//  MusicArtwork.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Circle containing song artwork image, rotatable
//

import SwiftUI

struct MusicArtwork: View {
    let gradient: [Color]
    let image: Image
    
    var body: some View {
        let size = UIScreen.main.bounds.size.width * 0.9 - Constants.spacing * 2
        ZStack {
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: gradient.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: size, height: size)
            
            image
                .resizable()
                .scaledToFill()
                .frame(width: size * 0.95, height: size * 0.95)
                .clipShape(Circle())
        }
    }
}

struct Artwork_Previews: PreviewProvider {
    static var previews: some View {
        MusicArtwork(gradient: Constants.defaultColorScheme.backgroundGradient.colors, image: .placeholder)
    }
}
