//
//  Color+Extension.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Static references to asset colors
//

import SwiftUI

extension Color {
    static let defaultGradientTop = Color("DefaultGradientTop")
    static let defaultGradientBottom = Color("DefaultGradientBottom")
    
    static let pauseGradientTop = Color("PauseGradientDark")
    static let pauseGradientBottom = Color("PauseGradientLight")
    
    static let playGradientTop = Color("PlayGradientDark")
    static let playGradientBottom = Color("PlayGradientLight")
    
    static let falseWhite = Color(red: 0.92, green: 0.92, blue: 0.98)
    
    var rgb: (r: Double, g: Double, b: Double) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        
        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: nil) else {
            return (-1, -1, -1)
        }

        return (Double(r), Double(g), Double(b))
    }
    
    var hsb: (h: Double, s: Double, b: Double) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        
        guard NativeColor(self).getHue(&h, saturation: &s, brightness: &b, alpha: nil) else {
            return (-1, -1, -1)
        }
        
        return (Double(h), Double(s), Double(b))
    }
    
    // Credit to Darel Rex Finley: http://alienryderflex.com/hsp.html
    var perceivedBrightness: Double {
        let vals = rgb
        
        // brightness = sqrt(r^2 * 0.299 + g^2 * 0.587 + b^2 * 0.114)
        return sqrt(vals.r * vals.r * 0.299 + vals.g * vals.g * 0.587 + vals.b * vals.b * 0.114)
    }
    
    var uiColor: UIColor {
        return UIColor(self)
    }
    
    func average(to color: Color) -> Color {
        let c1 = hsb
        let c2 = color.hsb
        
        return Color(hue: (c1.h + c2.h) / 2, saturation: (c1.s + c2.s) / 2, brightness: (c1.b + c2.b) / 2)
    }
}
