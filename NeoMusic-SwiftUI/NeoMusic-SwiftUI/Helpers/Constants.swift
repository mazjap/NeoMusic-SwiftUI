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
        backgroundGradient: EasyGradient([.falseWhite, .falseWhite]),
        sliderGradient: EasyGradient([.gray, .lightGray]),
        textColor: .gray,
        mainButtonColor: .falseBlack,
        secondaryButtonColor: .black)
    
    static let darkColorScheme = JCColorScheme(
        backgroundGradient: EasyGradient([.falseBlack, .falseBlack]),
        sliderGradient: EasyGradient([.purple, .red]),
        textColor: .falseWhite, mainButtonColor: .white,
        secondaryButtonColor: .falseWhite)
    
    static let noArtist = "No Artist Found"
    static let noAlbum = "No Album Found"
    static let noSong = "No Song Found"
    
    static var cacheCount = 0
    
    static var cacheNumber: Int {
        cacheCount += 1
        return cacheCount
        
    }
}
