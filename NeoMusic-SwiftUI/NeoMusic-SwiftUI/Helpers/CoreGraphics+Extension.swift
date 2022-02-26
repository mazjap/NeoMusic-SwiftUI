//
//  CoreGraphics+Extension.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/13/21.
//

import CoreGraphics

extension CGFloat {
    static let root2 = 1.4142857
}

extension CGPoint {
    func applying(x: CGFloat, y: CGFloat) -> CGPoint {
        applying(CGPoint(x: x, y: y))
    }
    
    func applying(_ offset: CGPoint) -> CGPoint {
        CGPoint(x: self.x + offset.x, y: self.y + offset.y)
    }
    
    func scaledBy(_ factor: Double) -> CGPoint {
        scaledBy(x: factor, y: factor)
    }
    
    func scaledBy(x xFactor: Double, y yFactor: Double) -> CGPoint {
        CGPoint(x: x * xFactor, y: y * yFactor)
    }
    
}

extension CGSize {
    func applying(x: CGFloat, y: CGFloat) -> CGSize {
        applying(CGPoint(x: x, y: y))
    }
    
    func applying(_ offset: CGPoint) -> CGSize {
        CGSize(width: width + offset.x, height: height + offset.y)
    }
    
    func scaledBy(_ factor: Double) -> CGSize {
        scaledBy(x: factor, y: factor)
    }
    
    func scaledBy(x xFactor: Double, y yFactor: Double) -> CGSize {
        CGSize(width: width * xFactor, height: height * yFactor)
    }
}
