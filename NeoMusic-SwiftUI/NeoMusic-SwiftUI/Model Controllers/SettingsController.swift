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
    
    // MARK: - Variables
    
    @Published var colorScheme: JCColorScheme = JCColorScheme.default
    @Published var feedbackEnabled: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    // MARK: - Initializers
    
    private init() {
        colorScheme = fetchCurrentColorScheme()
        feedbackEnabled = fetchFeedbackEnabled()
    }
    
    // MARK: - Functions
    
    func setCurrentColorScheme(_ scheme: JCColorScheme) {
        let data = try? encoder.encode(scheme)
        
        userDefaults.set(data, forKey: Self.keys.colorSchemeKey)
        
        colorScheme = scheme
    }
    
    func setFeedbackEnabled(_ bool: Bool) {
        userDefaults.set(bool, forKey: Self.keys.feedbackEnabledKey)
        
        feedbackEnabled = bool
    }
    
    func addUserColorScheme() {
        var arr = fetchUserColorSchemes()
        
        if !arr.contains(colorScheme) {
            arr.append(colorScheme)
            
            let data = try? encoder.encode(arr)
            userDefaults.set(data, forKey: Self.keys.userSavedColorSchemes)
        }
    }
    
    func removeUserColorScheme(_ cs: JCColorScheme) {
        var arr = fetchUserColorSchemes()
        
        if let index = arr.firstIndex(of: cs) {
            arr.remove(at: index)
            
            let data = try? encoder.encode(arr)
            userDefaults.set(data, forKey: Self.keys.userSavedColorSchemes)
        }
    }
    
    private func fetchCurrentColorScheme() -> JCColorScheme {
        if let data = userDefaults.object(forKey: Self.keys.colorSchemeKey) as? Data, let scheme = try? decoder.decode(JCColorScheme.self, from: data) {
            return scheme
        }
        
        return Constants.defaultColorScheme
    }
    
    private func fetchFeedbackEnabled() -> Bool {
        return userDefaults.value(forKey: Self.keys.feedbackEnabledKey) as? Bool ?? true
    }
    
    func fetchUserColorSchemes() -> [JCColorScheme] {
        var userSchemes = [JCColorScheme]()
        if let data = userDefaults.value(forKey: Self.keys.userSavedColorSchemes) as? Data, let schemes = try? decoder.decode([JCColorScheme].self, from: data) {
            userSchemes = schemes
        }
        
        return userSchemes
    }
    
    // MARK: - Static Variables
    
    static let shared = SettingsController()
    
    static private let keys = (
        colorSchemeKey: "com.mazjap.NeoMusic-SwiftUI.SettingsController.colorScheme",
        feedbackEnabledKey: "com.mazjap.NeoMusic-SwiftUI.SettingsController.feedbackEnabled",
        userSavedColorSchemes: "com.mazjap.NeoMusic-SwiftUI.SettingsController.userSaved_colorSchemes"
    )
}
