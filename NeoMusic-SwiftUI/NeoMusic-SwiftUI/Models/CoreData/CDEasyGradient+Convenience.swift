//
//  CDEasyGradient+Convenience.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/20/20.
//

import CoreData

extension Array where Element == CDEasyColor {
    var easies: [EasyColor] {
        return map { $0.easy }
    }
}

extension CDEasyGradient {
    convenience init(_ easyGradient: EasyGradient, context: NSManagedObjectContext) {
        self.init(context: context)
        self.easyColors = NSOrderedSet(array: easyGradient.easyColors.map { CDEasyColor($0, context: context) })
    }
    
    override public var description: String {
        "\(easyColors ?? [])"
    }
    
    var easy: EasyGradient? {
        guard let cdColors = easyColors?.array as? [CDEasyColor] else { return nil }
        
        return EasyGradient(cdColors.easies)
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
