//
//  DoubleChevron.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/13/21.
//

import SwiftUI

struct DoubleChevronRight: Chevron {
    var lineWidth: CGFloat = 5
    
    init() {}
    
    func path(in rect: CGRect) -> Path {
        doubleChevron(in: rect)
    }
}

struct DoubleChevronLeft: Chevron {
    var lineWidth: CGFloat = 5
    
    init() {}
    
    func path(in rect: CGRect) -> Path {
        let rotation = doubleChevron(in: rect)
            .rotation(.radians(.pi))
        
        return rotation.path(in: rect)
    }
}

struct DoubleChevron_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DoubleChevronRight(lineWidth: 12)
                .fill(.red)
                .frame(width: 200)
            
            DoubleChevronLeft(lineWidth: 10)
                .stroke(.black, lineWidth: 1)
                .frame(width: 275, height: 300)
        }
    }
}
