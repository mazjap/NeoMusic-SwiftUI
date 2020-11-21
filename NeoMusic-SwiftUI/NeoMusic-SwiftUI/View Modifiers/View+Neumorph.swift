//
//  View+Neumorph.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/9/20.
//

import SwiftUI

extension View {
    func neumorph(color: Color?, size: Neumorph.Size) -> some View {
        self
            .modifier(Neumorph(color: color, size: size))
    }
}
