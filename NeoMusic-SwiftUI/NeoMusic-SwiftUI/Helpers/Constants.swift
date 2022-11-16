import SwiftUI

struct Constants {
    static let spacing: CGFloat = 16
    
    static let buttonSize: CGFloat = 70
    static var buttonPadding: CGFloat {
        #if os(iOS)
        return UIScreen.main.bounds.width / 14
        #else
        return 30
        #endif
    }
    
    static let defaults = [defaultColorScheme, lightColorScheme, darkColorScheme]
    
    static let defaultColorScheme = JCColorScheme(
        backgroundGradient: EasyGradient([.defaultGradientTop, .defaultGradientBottom]),
        sliderGradient: EasyGradient([.sliderGradientTop, .sliderGradientBottom]),
        textColor: .white,
        mainButtonColor: .white,
        secondaryButtonColor: .white,
        dateAdded: Date(timeIntervalSince1970: 0),
        name: "Default")
    
    static let lightColorScheme = JCColorScheme(
        backgroundGradient: EasyGradient([.falseWhite, .falseWhite]),
        sliderGradient: EasyGradient([.gray, .lightGray]),
        textColor: .gray,
        mainButtonColor: .falseBlack,
        secondaryButtonColor: .black,
        dateAdded: Date(timeIntervalSince1970: 1),
        name: "White")
    
    static let darkColorScheme = JCColorScheme(
        backgroundGradient: EasyGradient([.falseBlack, .falseBlack]),
        sliderGradient: EasyGradient([.orange, .yellow]),
        textColor: .falseWhite, mainButtonColor: .white,
        secondaryButtonColor: .falseWhite,
        dateAdded: Date(timeIntervalSince1970: 2),
        name: "Black")
        
    
    static let noArtist = "No Artist Found"
    static let noAlbum = "No Album Found"
    static let noSong = "No Song Found"
    
    static let coreDataUserModelName = "User"
    
    private static var cacheCount = 0
    
    static var cacheNumber: Int {
        cacheCount += 1
        return cacheCount
        
    }
}
