//
//  JCColorScheme.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Contain all colors for updating ui as well as default colorSchemes
//

import SwiftUI

struct JCColorScheme: Codable, Equatable {
    var backgroundGradient: EasyGradient
    var sliderGradient: EasyGradient
    
    var textColor: EasyColor
    var mainButtonColor: EasyColor
    var secondaryButtonColor: EasyColor
    
    init(backgroundGradient: EasyGradient,
         sliderGradient: EasyGradient,
         textColor: Color,
         mainButtonColor: Color,
         secondaryButtonColor: Color) {
        self.backgroundGradient = backgroundGradient
        self.sliderGradient = sliderGradient
        
        self.textColor = EasyColor(textColor)
        self.mainButtonColor = EasyColor(mainButtonColor)
        self.secondaryButtonColor = EasyColor(secondaryButtonColor)
    }
    
    static var `default` = Constants.defaultColorScheme
}

struct EasyGradient: Codable, Equatable {
    private var easyColors: [EasyColor]
    
    var count: Int {
        easyColors.count
    }
    
    var colors: [Color] {
        easyColors.map { $0.color }
    }
    
    var gradient: Gradient {
        Gradient(colors: colors)
    }
    
    var first: Color {
        guard let f = easyColors.first else { fatalError("EasyGradient contains no elements! This should not happen.") }
        return f.color
    }
    
    var last: Color {
        guard let l = easyColors.last else { fatalError("EasyGradient contains no elements! This should not happen.") }
        return l.color
    }
    
    init(_ colors: [Color]) {
        if colors.count == 0 {
            self.easyColors = [EasyColor.none]
        } else {
            self.easyColors = colors.map { EasyColor($0) }
        }
    }
    
    mutating func addColor(_ color: Color, at: Int? = nil) {
        let ezclr = EasyColor(color)
        
        if colors.count == 1 && colors[0] == .clear {
            easyColors[0] = EasyColor(color)
            return
        }
        
        if at == nil {
            easyColors.append(ezclr)
        } else if let index = at, index <= count, index >= 0 {
            easyColors.insert(ezclr, at: index)
        }
    }
    
    @discardableResult
    mutating func removeColor(at index: Int) -> Color? {
        guard count != 0, index >= 0, index < count else { return nil }
        
        let ezclr = easyColors.remove(at: index)
        if count == 0 {
            addColor(EasyColor.none.color)
        }
        
        return ezclr.color
    }
    
    func color(at index: Int) -> Color {
        let ezclr: EasyColor
        
        if count == 0 {
            ezclr = .none
        } else if index >= easyColors.count {
            ezclr = easyColors[easyColors.count - 1]
        } else if index < 0 {
            ezclr = easyColors[0]
        } else {
            ezclr = easyColors[index]
        }
        
        return ezclr.color
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
        
        self.init(red: UInt8((hexAsInt >> 16) & 0xFF), green: UInt8((hexAsInt >> 8) & 0xFF), blue: UInt8(hexAsInt & 0xFF))
    }
    
    static var none = EasyColor(.clear)
}

extension Gradient {
    var reversed: Gradient {
        Gradient(colors: stops.map { $0.color }.reversed())
    }
}
