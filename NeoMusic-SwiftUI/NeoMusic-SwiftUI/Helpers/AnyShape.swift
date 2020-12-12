//
//  AnyShape.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/12/20.
//

import SwiftUI

public struct AnyShape: InsettableShape {
    private var base: (CGRect) -> Path
    private var insetAmount: CGFloat = 0
    
    public init<S: Shape>(_ shape: S) {
        base = shape.path(in:)
    }
    
    public func path(in rect: CGRect) -> Path {
        base(rect)
    }
    
    public func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount = amount
        return shape
    }
}

extension Shape {
    func asAnyShape() -> AnyShape {
        return AnyShape(self)
    }
}
