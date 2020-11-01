//
//  ResignFirstResponderOnDrag.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/2/20.
//

import SwiftUI

struct ResignFirstResponderOnDrag: ViewModifier {
    
    // MARK: - Variables
    
    private var gesture = DragGesture().onChanged { _ in
        UIApplication.shared.endEditing(true)
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

// MARK: SearchBar Extension: ResignFirstResponderOnDrag

extension SearchBar {
    func resignsFirstResponderOnDrag() -> some View {
        self
            .modifier(ResignFirstResponderOnDrag())
    }
}
