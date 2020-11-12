//
//  Image+Extension.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Static references to asset images
//

import SwiftUI

extension Image {
    static let placeholders = [
        Image("Placeholder1"),
        Image("Placeholder2"),
        Image("Placeholder3")
    ]
    
    static var placeholder: Image {
        placeholders[Int.random(in: 0..<placeholders.count)]
    }
}
