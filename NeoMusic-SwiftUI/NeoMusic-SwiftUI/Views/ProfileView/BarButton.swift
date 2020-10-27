//
//  BarButton.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/26/20.
//

import SwiftUI

struct BarButton: View {
    private let action: () -> Void
    private let image: Image
    private let color: Color
    
    
    init(image: Image, buttonColor: Color, action: @escaping () -> Void) {
        self.image = image
        self.action = action
        self.color = buttonColor
    }
    
    init(imageName: String, buttonColor: Color, action: @escaping () -> Void) {
        self.image = Image(systemName: imageName)
        self.action = action
        self.color = buttonColor
    }
    
    var body: some View {
        Button(action: action) {
            image
        }
        .foregroundColor(color)
    }
}

struct BarButton_Previews: PreviewProvider {
    static var previews: some View {
        BarButton(imageName: "circle.fill", buttonColor: .red) { }
    }
}
