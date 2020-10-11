//
//  CustomListHeader.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/10/20.
//

import SwiftUI

public struct CustomListHeader: ViewModifier {
    var backgroundColor: Color
    var textColor: Color
    
    public func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(width: UIScreen.main.bounds.width - 20, height: 28, alignment: .leading)
            .background(backgroundColor)
            .foregroundColor(textColor)
    }
}
