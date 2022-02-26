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
    
//    @Published private(set) var colorScheme: JCColorScheme = JCColorScheme.default
    @Published private(set) var feedbackEnabled: Bool = true
    
    @AppStorage(SettingsController.keys.colorSchemeKey, store: .standard) private(set) var colorScheme = JCColorScheme.default
    
    private let queue = DispatchQueue(label: "com.mazjap.NeoMusic-SwiftUI.SettingsController.settingsQueue", attributes: .concurrent)
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
        
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.userDefaults.set(data, forKey: Self.keys.colorSchemeKey)
            
            DispatchQueue.main.async {
                self.colorScheme = scheme
            }
        }
    }
    
    func setFeedbackEnabled(_ bool: Bool) {
        
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.userDefaults.set(bool, forKey: Self.keys.feedbackEnabledKey)
            
            DispatchQueue.main.async {
                self.feedbackEnabled = bool
            }
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
    
    // MARK: - Static Variables
    
    static let shared = SettingsController()
    
    static private let keys = (
        colorSchemeKey: "com.mazjap.NeoMusic-SwiftUI.SettingsController.colorScheme",
        feedbackEnabledKey: "com.mazjap.NeoMusic-SwiftUI.SettingsController.feedbackEnabled",
        userSavedColorSchemes: "com.mazjap.NeoMusic-SwiftUI.SettingsController.userSaved_colorSchemes"
    )
}
