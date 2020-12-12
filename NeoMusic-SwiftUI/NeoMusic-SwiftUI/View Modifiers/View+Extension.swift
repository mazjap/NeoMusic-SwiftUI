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
    
    func spacing(_ edges: Edge.Set = .all) -> some View {
        self
            .padding(edges, Constants.spacing)
    }
    
    func frame(size: CGSize) -> some View {
        self
            .frame(width: size.width, height: size.height)
    }
    
    // Conditionally modify view
    @ViewBuilder
    func `if`<TrueContent, FalseContent>(_ condition: Bool,
                       trueModification: (Self) -> TrueContent,
                       else falseModification: ((Self) -> FalseContent)? = nil) ->
                       some View where TrueContent: View, FalseContent: View {
        if condition {
            trueModification(self)
        } else if let falseModification = falseModification {
            falseModification(self)
        } else {
            self
        }
    }
}

extension UIDevice {
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}
