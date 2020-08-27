//
//  SettingsController.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Persistently save user settings and info
//

import SwiftUI

class SettingsController: ObservableObject {
    // MARK: - Static Variables
    
    static let colorSchemeKey = "com.mazjap.NeoMusic-SwiftUI.SettingsController.colorScheme"
    
    // MARK: - Initializers
    
    init() {
        colorScheme = fetchColorScheme()
    }
    
    // MARK: - Variables
    
    let userDefaults = UserDefaults.standard
    @Published var colorScheme: ColorScheme = Constants.defaultColorScheme
    
    // MARK: - Functions
    
    func setColorScheme(_ scheme: ColorScheme) {
        let data = try? JSONEncoder().encode(scheme)
        
        userDefaults.set(data, forKey: SettingsController.colorSchemeKey)
        
        colorScheme = scheme
    }
    
    func setGradient(_ gradient: EasyGradient, for option: ColorScheme.GradientOption) {
        var scheme = fetchColorScheme()
        
        switch option {
        case .background:
            scheme.backgroundGradient = gradient
        case .play:
            scheme.playGradient = gradient
        case .pause:
            scheme.pauseGradient = gradient
        }
        
        setColorScheme(scheme)
    }
    
    private func fetchColorScheme() -> ColorScheme {
        if let data = userDefaults.object(forKey: SettingsController.colorSchemeKey) as? Data, let scheme = try? JSONDecoder().decode(ColorScheme.self, from: data) {
            return scheme
        }
        
        return Constants.defaultColorScheme
    }
}
