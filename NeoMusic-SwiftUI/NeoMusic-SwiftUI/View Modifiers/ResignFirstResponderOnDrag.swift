//
//  ResignFirstResponderOnDrag.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/2/20.
//

import SwiftUI

struct ResignFirstResponderOnDrag: ViewModifier {
    var gesture = DragGesture().onChanged { _ in
        UIApplication.shared.endEditing(true)
    }
    
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension SearchBar {
    func resignsFirstResponderOnDrag() -> some View {
        self
            .modifier(ResignFirstResponderOnDrag())
    }
}
