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
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: gradient.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.95)
                    .clipShape(Circle())
            }
        }
    }
}

struct Artwork_Previews: PreviewProvider {
    static var previews: some View {
        MusicArtwork(gradient: Constants.defaultColorScheme.backgroundGradient.colors, image: .placeholder)
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
