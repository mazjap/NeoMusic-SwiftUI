//
//  Chevron.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/13/21.
//

import SwiftUI

protocol Chevron: Shape, ShapeAccessible {
    var lineWidth: CGFloat { get set }
    init()
}

extension Chevron {
    init(lineWidth: CGFloat = 2) {
        self.init()
        self.lineWidth = lineWidth
    }
    
    var lineRadius: CGFloat {
        lineWidth / 2
    }
}

struct ChevronRight: Chevron {
    var lineWidth: CGFloat = 5
    
    init() {}
    
    func path(in rect: CGRect) -> Path {
        singleChevron(in: rect)
    }
}

struct ChevronLeft: Chevron {
    var lineWidth: CGFloat = 5
    
    init() {}
    
    func path(in rect: CGRect) -> Path {
        let rotation = singleChevron(in: rect)
            .rotation(.radians(.pi))
        
        return rotation.path(in: rect)
    }
}

struct Chevron_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ChevronRight()
                .stroke(.blue, lineWidth: 4)
                .frame(width: 80, height: 200)
                .border(.red, width: 0.25)
            
            ChevronLeft(lineWidth: 20)
                .fill(.red)
                .frame(width: 50, height: 80)
                .border(.blue, width: 0.25)
        }
        .foregroundColor(.red)
    }
}
