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

// MARK: - JCColorScheme

struct JCColorScheme: Codable, Equatable, Identifiable {
    var id: String {
        "BG:\(backgroundGradient), SG:\(sliderGradient), TC:\(textColor), MBC:\(mainButtonColor), SBC:\(secondaryButtonColor)"
    }
    
    
    // MARK: - Variables
    
    var backgroundGradient: EasyGradient
    var sliderGradient: EasyGradient
    
    var textColor: EasyColor
    var mainButtonColor: EasyColor
    var secondaryButtonColor: EasyColor
    
    // MARK: - Initializer
    
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
    
    // MARK: - Static Variables
    
    static var `default` = Constants.defaultColorScheme
}

// MARK: - EasyGradient

struct EasyGradient: Codable, Equatable, CustomStringConvertible {
    
    // MARK: - Variables
    
    var description: String {
        "\(colors)"
    }
    
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
        return easyColors.first?.color ?? .clear
    }
    
    var last: Color {
        return easyColors.last?.color ?? .clear
    }
    
    // MARK: - Initializer
    
    init(_ colors: [Color]) {
        if colors.count == 0 {
            self.easyColors = [EasyColor.none]
        } else {
            self.easyColors = colors.map { EasyColor($0) }
        }
    }
    
    // MARK: - Functions
    
    subscript(i: Int) -> EasyColor {
        guard i >= 0 else { return easyColors[0] }
        guard i < easyColors.count else {return easyColors[easyColors.count - 1]}
        return easyColors[i]
    }
    
    mutating func addColor(_ color: EasyColor, at i: Int? = nil) {
        if colors.count == 1 && colors[0] == .clear {
            easyColors[0] = color
            return
        }
        
        if let index = i, index <= count, index >= 0 {
            easyColors.insert(color, at: index)
        } else {
            easyColors.append(color)
        }
    }
    
    mutating func addColor(_ color: Color, at i: Int? = nil) {
        addColor(EasyColor(color), at: i)
    }
    
    @discardableResult
    mutating func removeColor(at index: Int) -> EasyColor? {
        guard count != 0, index >= 0, index < count else { return nil }
        
        let ezclr = easyColors.remove(at: index)
        if count == 0 {
            addColor(EasyColor.none.color)
        }
        
        return ezclr
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

// MARK: - EasyColor

struct EasyColor: Codable, Equatable, CustomStringConvertible {
    
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
}

// MARK: - JCColorScheme Extension: ColorType

extension JCColorScheme {
    enum ColorType {
        case backgroundGradient
        case sliderGradient
        case textColor
        case buttonColor
        case secondaryButtonColor
        
        var isGradient: Bool {
            switch self {
            case .backgroundGradient, .sliderGradient:
                return true
            default:
                return false
            }
        }
    }
}

// MARK: Gradient Extension: reversed

extension Gradient {
    var reversed: Gradient {
        Gradient(colors: stops.map { $0.color }.reversed())
    }
    
    var caGradient: CAGradientLayer {
        let g = CAGradientLayer()
        g.colors = [stops.map { $0.color.uiColor.cgColor }]
        g.startPoint = CGPoint(x: 0.5, y: 1.0)
        g.endPoint = CGPoint(x: 0.5, y: 0.0)
        g.locations = [0, 1]
        
        return g
    }
}


extension EasyColor {
    static let red = EasyColor(.red)
    static let black = EasyColor(.black)
    static let blue = EasyColor(.blue)
}
