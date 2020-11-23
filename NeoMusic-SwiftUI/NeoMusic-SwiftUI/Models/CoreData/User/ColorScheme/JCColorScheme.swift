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

struct JCColorScheme: Codable, Equatable, Identifiable, Hashable {
    var id: String {
        "\(backgroundGradient),\(sliderGradient),\(textColor),\(mainButtonColor),\(secondaryButtonColor)"
    }
    
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
    
    // MARK: - Static Variables
    
    static var `default` = Constants.defaultColorScheme

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
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
