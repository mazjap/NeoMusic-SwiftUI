//
//  EasyColor.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/21/20.
//

import SwiftUI

struct EasyColor: Codable, Equatable, Hashable, CustomStringConvertible {
    
    // MARK: - Variables
    
    var description: String {
        "R:\(r) G:\(g) B:\(b) A:\(a)"
    }
    
    var r = 0.0
    var g = 0.0
    var b = 0.0
    var a = 0.0
    
    var color: Color {
        Color(red: r, green: g, blue: b)
    }
    
    var uiColor: UIColor {
        UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
    }
    
    var hex: String {
        String(format:"%02X", Int(r * 0xff)) + String(format:"%02X", Int(g * 0xff)) + String(format:"%02X", Int(r * 0xff))
    }
    
    // MARK: - Initializers

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
    
    init(hue: Double, saturation: Double, brightness: Double) {
        self.init(Color(hue: hue, saturation: saturation, brightness: brightness))
    }
    
    // Validate user-provided hex string, return nil if bad input
    init?(_ hex: String) {
        guard hex.count > 0 else { return nil }
        
        var formattedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if formattedHex[formattedHex.startIndex] == String.Element("#") {
            formattedHex.removeFirst()
        }
        
        guard let hexAsInt = UInt32(formattedHex, radix: 16) else { return nil }
        
        self.init(red: UInt8((hexAsInt >> 16) & 0xFF),
                  green: UInt8((hexAsInt >> 8) & 0xFF),
                  blue: UInt8(hexAsInt & 0xFF))
    }
    
    // MARK: - Static Variables
    
    static var none = EasyColor(.clear)
    static let red = EasyColor(.red)
    static let black = EasyColor(.black)
    static let blue = EasyColor(.blue)
    static let clear = EasyColor(.clear)
}

extension EasyColor {
    init(red: Double, green: Double, blue: Double) {
        self.r = red
        self.g = green
        self.b = blue
    }
}
