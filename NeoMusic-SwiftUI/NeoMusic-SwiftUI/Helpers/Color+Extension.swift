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
    
    static let sliderGradientTop = Color("SliderGradientDark")
    static let sliderGradientBottom = Color("SliderGradientLight")
    
    static let playGradientTop = Color("PlayGradientDark")
    static let playGradientBottom = Color("PlayGradientLight")
    
    static let falseWhite = Color(red: 0.92, green: 0.92, blue: 0.98)
    static let falseBlack = Color(red: 0.08, green: 0.08, blue: 0.12)
    
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
    
    func average(to color: Color, at percent: Double = 0.5) -> Color {
        let c1 = hsb
        let c2 = color.hsb
        
        return Color(hue: percent * c1.h + (1 - percent) * c2.h, saturation: percent * c1.s + (1 - percent) * c2.s, brightness: percent * c1.b + (1 - percent) * c2.b)
    }
    
    var offsetColors: [Color] {
        let vals = hsb
        
        // If colors brightness is greater than 0.9 or less than 0.1
        //     Use self as one of the offsets and offset the other color's brightness by 0.2
        // Else
        //     offset the color's brightness by 0.1 in both directions
        
        if vals.b - 0.1 < 0 {
            return [
                self,
                Color(hue: vals.h, saturation: vals.s, brightness: vals.b + 0.2)
            ]
        } else if vals.b + 0.1 > 1 {
            return [
                Color(hue: vals.h, saturation: vals.s, brightness: vals.b - 0.2),
                self
            ]
        } else {
            return [
                Color(hue: vals.h, saturation: vals.s, brightness: vals.b - 0.1),
                Color(hue: vals.h, saturation: vals.s, brightness: vals.b + 0.1)
            ]
        }
    }
    
    var offsetGradient: Gradient {
        Gradient(colors: offsetColors)
    }
}
