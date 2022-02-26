//
//  Arrow.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/13/21.
//

import SwiftUI

struct ArrowRight: Chevron {
    var lineWidth: CGFloat = 2
    
    init() {}
    
    func path(in rect: CGRect) -> Path {
        arrow(in: rect)
    }
}

struct ArrowLeft: Chevron {
    var lineWidth: CGFloat = 2
    
    init() {}
    
    func path(in rect: CGRect) -> Path {
        arrow(in: rect)
            .rotation(.degrees(180))
            .path(in: rect)
    }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ArrowRight(lineWidth: 10)
                .frame(width: 100, height: 70)
            
            ArrowLeft(lineWidth: 20)
                .frame(width: 200, height: 160)
            
            ArrowRight(lineWidth: 10)
                .stroke(.red, lineWidth: 2)
                .foregroundColor(.white)
        }
    }
}
