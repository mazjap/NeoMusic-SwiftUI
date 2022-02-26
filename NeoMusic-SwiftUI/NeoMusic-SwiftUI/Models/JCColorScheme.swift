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

struct JCColorScheme {
    
    // MARK: - Variables
    
    var backgroundGradient: EasyGradient
    var sliderGradient: EasyGradient
    
    var textColor: EasyColor
    var mainButtonColor: EasyColor
    var secondaryButtonColor: EasyColor
    
    var dateAdded: Date
    var name: String?
    
    // MARK: - Initializers
    
    init(backgroundGradient: EasyGradient,
         sliderGradient: EasyGradient,
         textColor: Color,
         mainButtonColor: Color,
         secondaryButtonColor: Color,
         dateAdded: Date = Date(),
         name: String? = nil) {
        self.init(backgroundGradient: backgroundGradient, sliderGradient: sliderGradient, textColor: EasyColor(textColor), mainButtonColor: EasyColor(mainButtonColor), secondaryButtonColor: EasyColor(secondaryButtonColor), dateAdded: dateAdded, name: name)
    }
    
    init(backgroundGradient: EasyGradient,
         sliderGradient: EasyGradient,
         textColor: EasyColor,
         mainButtonColor: EasyColor,
         secondaryButtonColor: EasyColor,
         dateAdded: Date = Date(),
         name: String? = nil) {
        
        self.backgroundGradient = backgroundGradient
        self.sliderGradient = sliderGradient
        self.textColor = textColor
        self.mainButtonColor = mainButtonColor
        self.secondaryButtonColor = secondaryButtonColor
        self.dateAdded = dateAdded
        self.name = name
    }
    
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let value = try? JSONDecoder().decode(JCColorScheme.self, from: data)
        else {
            return nil
        }
        
        self = value
    }
    
    // MARK: - Static Variables
    
    static var `default` = Constants.defaultColorScheme

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension JCColorScheme: Codable {
    enum CodingKeys: String, CodingKey {
        case backgroundGradient
        case sliderGradient
        case textColor
        case mainButtonColor
        case secondaryButtonColor
        case dateAdded
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.backgroundGradient = try container.decode(EasyGradient.self, forKey: .backgroundGradient)
        self.sliderGradient = try container.decode(EasyGradient.self, forKey: .sliderGradient)
        self.textColor = try container.decode(EasyColor.self, forKey: .textColor)
        self.mainButtonColor = try container.decode(EasyColor.self, forKey: .mainButtonColor)
        
        self.secondaryButtonColor = try container.decode(EasyColor.self, forKey: .secondaryButtonColor)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        let timeInterval = try container.decode(Double.self, forKey: .dateAdded)
        self.dateAdded = Date(timeIntervalSince1970: timeInterval)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(backgroundGradient, forKey: .backgroundGradient)
        try container.encode(sliderGradient, forKey: .sliderGradient)
        try container.encode(textColor, forKey: .textColor)
        try container.encode(mainButtonColor, forKey: .mainButtonColor)
        try container.encode(secondaryButtonColor, forKey: .secondaryButtonColor)
        try container.encode(dateAdded.timeIntervalSince1970, forKey: .dateAdded)
        try container.encodeIfPresent(name, forKey: .name)
    }
}

// MARK: - JCColorSchemeExtension: Codable, Identifiable, CustomStringConvertible, Hashable, RawRepresentable

extension JCColorScheme: Identifiable, CustomStringConvertible, Hashable, RawRepresentable {
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
        "[backgroundGradient: \(backgroundGradient), sliderGradient: \(sliderGradient), textColor: \(textColor), buttonColor: \(mainButtonColor), secondaryButtonColor: \(secondaryButtonColor)]"
    }
    
    var id: String { rawValue }
}

// MARK: - JCColorScheme Extension: ColorType

extension JCColorScheme {
    
    
    enum ColorType: CaseIterable {
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
