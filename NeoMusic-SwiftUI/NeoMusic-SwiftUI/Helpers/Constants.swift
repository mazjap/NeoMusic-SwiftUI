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
    static let spacing: CGFloat = 10
    
    static let defaultColorScheme =
        JCColorScheme(
            backgroundGradient: EasyGradient([.defaultGradientTop, .defaultGradientBottom]),
            sliderGradient: EasyGradient([.pauseGradientTop, .pauseGradientBottom]),
            textColor: .white,
            mainButtonColor: .white,
            secondaryButtonColor: .white)
    
    static let lightColorScheme = JCColorScheme(
        backgroundGradient: EasyGradient([.falseWhite]),
        sliderGradient: EasyGradient([.gray]),
        textColor: .gray,
        mainButtonColor: .falseBlack,
        secondaryButtonColor: .black)
    
    static let darkColorScheme = JCColorScheme(backgroundGradient: EasyGradient([.falseBlack]), sliderGradient: EasyGradient([.gray]), textColor: .gray, mainButtonColor: .falseWhite, secondaryButtonColor: .white)
    
    static let codeLineLocation = "@f\(#file)l\(#line)"
}
