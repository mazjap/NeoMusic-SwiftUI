//
//  Constants.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Encapsulate project-wide reused variables
//

import SwiftUI

struct Constants {
    static let spacing: CGFloat = 16
    
    static let defaultColorScheme = JCColorScheme(
        backgroundGradient: EasyGradient([.defaultGradientTop, .defaultGradientBottom]),
        sliderGradient: EasyGradient([.sliderGradientTop, .sliderGradientBottom]),
        textColor: .white,
        mainButtonColor: .white,
        secondaryButtonColor: .white)
    
    static let lightColorScheme = JCColorScheme(
        backgroundGradient: EasyGradient([.falseWhite]),
        sliderGradient: EasyGradient([.gray]),
        textColor: .gray,
        mainButtonColor: .falseBlack,
        secondaryButtonColor: .black)
    
    static let darkColorScheme = JCColorScheme(
        backgroundGradient: EasyGradient([.falseBlack]),
        sliderGradient: EasyGradient([.purple, .red]),
        textColor: .falseWhite, mainButtonColor: .white,
        secondaryButtonColor: .falseWhite)
}
