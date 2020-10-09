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
    @Published var colorScheme: JCColorScheme = JCColorScheme.default
    
    // MARK: - Functions
    
    func setColorScheme(_ scheme: JCColorScheme) {
        let data = try? JSONEncoder().encode(scheme)
        
        userDefaults.set(data, forKey: SettingsController.colorSchemeKey)
        
        colorScheme = scheme
    }
    
    private func fetchColorScheme() -> JCColorScheme {
        if let data = userDefaults.object(forKey: SettingsController.colorSchemeKey) as? Data, let scheme = try? JSONDecoder().decode(JCColorScheme.self, from: data) {
            return scheme
        }
        
        return Constants.defaultColorScheme
    }
}
