//
//  CDEasyColor+Convenience.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/20/20.
//

import CoreData

extension CDEasyColor {
    convenience init(_ easyColor: EasyColor, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.r = easyColor.r
        self.g = easyColor.g
        self.b = easyColor.b
    }
    
    override public var description: String {
        "R:\(r) G:\(g) B:\(b)"
    }
    
    var easy: EasyColor {
        EasyColor(red: r, green: g, blue: b)
    }
    
    static func == (lhs: CDEasyColor, rhs: EasyColor) -> Bool {
        return lhs.r == rhs.r &&
               lhs.g == rhs.g &&
               lhs.b == rhs.b
    }
    
    static func != (lhs: CDEasyColor, rhs: EasyColor) -> Bool {
        return !(lhs == rhs)
    }
}
