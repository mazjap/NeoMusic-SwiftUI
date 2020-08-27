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
        ColorScheme(
            backgroundGradient: EasyGradient(color1: EasyColor(.defaultGradientTop), color2: EasyColor(.defaultGradientBottom)),
            playGradient: EasyGradient(color1: EasyColor(.playGradientTop), color2: EasyColor(.playGradientBottom)),
            pauseGradient: EasyGradient(color1: EasyColor(.pauseGradientTop), color2: EasyColor(.pauseGradientBottom)),
            textColor: EasyColor(.white),
            mainButtonColor: EasyColor(.white),
            secondaryButtonColor: EasyColor(.white)
        )
}
