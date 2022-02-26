//
//  Play.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/13/21.
//

import SwiftUI

struct Play: Shape, ShapeAccessible {
    var cornerRadius: CGFloat = 2
    
    func path(in rect: CGRect) -> Path {
        triangle(
            in: rect,
            cornerRadius: cornerRadius
        )
    }
}

struct Play_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Play(cornerRadius: 10)
                .stroke(.red, lineWidth: 10)
                .frame(width: 82, height: 80)
            
            Play(cornerRadius: 20)
                .fill(.blue)
                .frame(width: 200, height: 200)
        }
    }
}
