//
//  SliderShape.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/17/20.
//

import SwiftUI

struct SliderShape: Shape {
    var touch: CGPoint?
    
    init(touch: CGPoint? = nil) {
        self.touch = touch
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addRoundedRect(in: CGRect(x: rect.maxX - ColorSlider.width, y: 0, width: ColorSlider.width, height: rect.height), cornerSize: CGSize(width: ColorSlider.width / 2, height: ColorSlider.width / 2))
        
        return path
    }
}

struct SliderShape_Previews: PreviewProvider {
    static var previews: some View {
        SliderShape()
    }
}
