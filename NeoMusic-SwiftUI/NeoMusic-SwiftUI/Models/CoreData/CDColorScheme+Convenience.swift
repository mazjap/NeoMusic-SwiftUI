//
//  CDColorScheme+Convenience.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/20/20.
//

import CoreData

extension CDColorScheme {
    convenience init(_ scheme: JCColorScheme, context: NSManagedObjectContext) {
        self.init(context: context)
        self.backgroundGradient = CDEasyGradient(scheme.backgroundGradient, context: context)
        self.sliderGradient = CDEasyGradient(scheme.sliderGradient, context: context)
        self.textColor = CDEasyColor(scheme.textColor, context: context)
        self.mainButtonColor = CDEasyColor(scheme.mainButtonColor, context: context)
        self.secondaryButtonColor = CDEasyColor(scheme.secondaryButtonColor, context: context)
    }
    
    public var id: String {
        "\(String(describing: backgroundGradient)),\(String(describing: sliderGradient)),\(String(describing: textColor)),\(String(describing: mainButtonColor)),\(String(describing: secondaryButtonColor))"
    }
    
    public override var description: String {
        id
    }
    
    var jc: JCColorScheme? {
        if let bg: EasyGradient = backgroundGradient?.easy,
           let sg: EasyGradient = sliderGradient?.easy,
           let tc: EasyColor = textColor?.easy,
           let mbc: EasyColor = mainButtonColor?.easy,
           let sbc: EasyColor = secondaryButtonColor?.easy {
            return JCColorScheme(backgroundGradient: bg, sliderGradient: sg, textColor: tc, mainButtonColor: mbc, secondaryButtonColor: sbc)
        }
        
        return nil
    }
    
    static func == (lhs: CDColorScheme, rhs: JCColorScheme) -> Bool {
        return lhs.id == rhs.id
    }
}
