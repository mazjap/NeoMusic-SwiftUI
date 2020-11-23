//
//  CDEasyGradient+Convenience.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/20/20.
//

import CoreData

extension CDEasyGradient {
    convenience init(_ easyGradient: EasyGradient, context: NSManagedObjectContext) {
        self.init(context: context)
        self.easyColors = NSOrderedSet(array: easyGradient.easyColors.map { CDEasyColor($0, context: context) })
    }
    
    override public var description: String {
        "\(easyColors ?? [])"
    }
    
    var easy: EasyGradient {
        if let ezColors = easyColors?.array as? [CDEasyColor] {
            return EasyGradient(ezColors.map { $0.easy })
        } else {
            return EasyGradient([EasyColor.clear])
        }
    }
    
    static func == (lhs: CDEasyGradient, rhs: EasyGradient) -> Bool {
        if let colors = lhs.easyColors?.array as? [CDEasyColor], colors.count == rhs.easyColors.count {
            for i in 0..<colors.count {
                if colors[i] != rhs.easyColors[i] {
                    return false
                }
            }
            
            return true
        } else {
            return rhs.easyColors.count == 0
        }
    }
    
    static func != (lhs: CDEasyGradient, rhs: EasyGradient) -> Bool {
        return !(lhs == rhs)
    }
}
