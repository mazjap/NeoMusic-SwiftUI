//
//  UIImage+Extension.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/12/20.
//

import UIKit.UIImage

extension UIImage {
    static let placeholders = [
        UIImage(named: "Placeholder1")!,
        UIImage(named: "Placeholder2")!,
        UIImage(named: "Placeholder3")!,
        UIImage(named: "Placeholder4")!,
        UIImage(named: "Placeholder5")!,
        UIImage(named: "Placeholder6")!,
        UIImage(named: "Placeholder7")!
    ]
    
    static var placeholder: UIImage {
        placeholders[Int.random(in: 0..<placeholders.count)]
    }
}
