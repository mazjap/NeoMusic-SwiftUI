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
    
    func customHeader(backgroundColor: Color, textColor: Color) -> some View {
        self
            .modifier(CustomListHeader(backgroundColor: backgroundColor, textColor: textColor))
    }
    
    // Conditionally modify view
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transformation: (Self) -> Transform) -> some View {
        if condition {
            transformation(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transformation: (Self) -> Transform, else falseTransformation: (Self) -> Transform) -> some View {
        if condition {
            transformation(self)
        } else {
            falseTransformation(self)
        }
    }
}
