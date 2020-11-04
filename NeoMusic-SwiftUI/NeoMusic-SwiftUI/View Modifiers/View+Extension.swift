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
    
    // MARK: - Functions
    
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
    
    func spacing(_ edges: Edge.Set = .all) -> some View {
        self
            .padding(edges, Constants.spacing)
    }
    
    // Conditionally modify view
    @ViewBuilder
    func `if`<Content>(_ condition: Bool,
                       trueModification: (Self) -> Content,
                       else falseModification: ((Self) -> Content)? = nil) ->
                       some View where Content: View {
        if condition {
            trueModification(self)
        } else if let falseModification = falseModification {
            falseModification(self)
        } else {
            self
        }
    }
}
