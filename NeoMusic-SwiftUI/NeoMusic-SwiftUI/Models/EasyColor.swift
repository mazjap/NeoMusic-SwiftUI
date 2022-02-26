//
//  EasyColor.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/21/20.
//

import SwiftUI

struct EasyColor: Codable, Hashable, Identifiable, CustomStringConvertible, RawRepresentable {
    
    // MARK: - Variables
    
    var rawValue: String {
        do {
            if let value = String(data: try JSONEncoder().encode(self), encoding: .utf8) {
                return value
            }
        } catch {
            print(error)
        }
        
        return "[]"
    }
    
    var description: String {
        "R:\(r) G:\(g) B:\(b) A:\(a)"
    }
    
    var id: String {
        rawValue
    }
    
    var r = 0.0
    var g = 0.0
    var b = 0.0
    var a = 1.0
    
    var color: Color {
        Color(red: r, green: g, blue: b).opacity(a)
    }
    
    var uiColor: UIColor {
        UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
    }
    
    var hex: String {
        String(format:"%02X", Int(r * 0xff)) + String(format:"%02X", Int(g * 0xff)) + String(format:"%02X", Int(b * 0xff))
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
    
    init(uiColor: UIColor) {
        self.init(Color(uiColor))
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
    
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let value = try? JSONDecoder().decode(EasyColor.self, from: data)
        else {
            return nil
        }
        
        self = value
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

extension EasyColor {
    enum CodingKeys: String, CodingKey {
        case r
        case g
        case b
        case a
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.r = try container.decode(Double.self, forKey: .r)
        self.g = try container.decode(Double.self, forKey: .g)
        self.b = try container.decode(Double.self, forKey: .b)
        self.a = try container.decode(Double.self, forKey: .a)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(r, forKey: .r)
        try container.encode(g, forKey: .g)
        try container.encode(b, forKey: .b)
        try container.encode(a, forKey: .a)
    }
}
