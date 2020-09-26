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
    var r: Double = 0.0
    var g: Double = 0.0
    var b: Double = 0.0
    var a: Double = 0.0
    
    var color: Color {
        Color(red: Double(r), green: Double(g), blue: Double(b))
    }

    init(_ color: Color) {
        let vals = color.rgb
        r = vals.r
        g = vals.g
        b = vals.b
    }
}
