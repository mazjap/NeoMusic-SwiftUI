//
//  BarButton.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/26/20.
//

import SwiftUI

struct BarButton: View {
    
    // MARK: - Variables
    
    private let action: () -> Void
    private let image: Image
    private let color: Color
    private let text: String?
    
    
    // MARK: - Initializers
    
    init(image: Image, buttonColor: Color, action: @escaping () -> Void) {
        self.image = image
        self.color = buttonColor
        self.action = action
        self.text = nil
    }
    
    init(title: String, buttonColor: Color, action: @escaping () -> Void) {
        self.text = title
        self.color = buttonColor
        self.action = action
        self.image = .placeholder
    }
    
    init(systemImageName: String, buttonColor: Color, action: @escaping () -> Void) {
        self.init(image: Image(systemName: systemImageName), buttonColor: buttonColor, action: action)
    }
    
    init(assetImageName: String, buttonColor: Color, action: @escaping () -> Void) {
        self.init(image: Image(assetImageName), buttonColor: buttonColor, action: action)
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            if let title = text {
                Text(title)
            } else {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: Self.size)
            }
        }
        .foregroundColor(color)
    }
    
    static let size = UIScreen.main.bounds.width / 18
}

// MARK: - Preview

struct BarButton_Previews: PreviewProvider {
    static var previews: some View {
        BarButton(systemImageName: "circle.fill", buttonColor: .red) { }
    }
}
