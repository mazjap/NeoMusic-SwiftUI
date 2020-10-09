//
//  View+Extension.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 9/26/20.
//
//  Purpose:
//  Create modifier functions for custom ViewModifiers
//

import SwiftUI

extension View {
    func asAny() -> AnyView {
        AnyView(self)
    }
    
    func neumorph(color: Color, size: Neumorph.Size) -> some View {
        self
            .modifier(Neumorph(color: color, size: size))
    }
}
