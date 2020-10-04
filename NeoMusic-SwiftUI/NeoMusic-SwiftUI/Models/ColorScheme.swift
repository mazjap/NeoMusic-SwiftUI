//
//  ColorScheme.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Contain all colors for updating ui
//

import SwiftUI

struct ColorScheme: Codable, Equatable {
    enum GradientOption {
        case background
        case play
        case pause
    }
    
    static var `default` = Constants.defaultColorScheme
    
    var backgroundGradient: EasyGradient
    var playGradient: EasyGradient
    var pauseGradient: EasyGradient
    
    var textColor: EasyColor
    var mainButtonColor: EasyColor
    var secondaryButtonColor: EasyColor
}

struct EasyGradient: Codable, Equatable {
    var color1: EasyColor
    var color2: EasyColor
    
    var colors: [Color] {
        [color1.color, color2.color]
    }
}

struct EasyColor: Codable, Equatable {
    var r = 0.0
    var g = 0.0
    var b = 0.0
    var a = 0.0
    
    var color: Color {
        Color(red: r, green: g, blue: b)
    }

    init(_ color: Color) {
        let vals = color.rgb
        r = vals.r
        g = vals.g
        b = vals.b
    }
    
    init(red: UInt8, green: UInt8, blue: UInt8) {
        r = Double(red) / 0xFF
        g = Double(green) / 0xFF
        b = Double(blue) / 0xFF
    }
    
    // Validate user-provided hex string, return nil if bad input
    init?(_ hex: String) {
        var newHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newHex[newHex.startIndex] == String.Element("#") {
            newHex.removeFirst()
        }
        
        guard let hexAsInt = UInt32(newHex, radix: 16) else { return nil }
        
        self.init(red: UInt8((hexAsInt >> 16) & 0xff), green: UInt8((hexAsInt >> 8) & 0xff), blue: UInt8(hexAsInt & 0xff))
    }
}
