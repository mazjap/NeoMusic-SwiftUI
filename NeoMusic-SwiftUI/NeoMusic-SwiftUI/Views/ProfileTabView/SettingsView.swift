//
//  SettingsView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/26/20.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    
    init() {
        let sc = SettingsController.shared
        let textColor = sc.colorScheme.textColor.color.uiColor
        let nbAppearance = UINavigationBar.appearance()
        
        nbAppearance.titleTextAttributes = [.foregroundColor: textColor]
        nbAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]
        nbAppearance.barTintColor = .clear
    }
    
    // MARK: - Body
    
    var body: some View {
        List {
            let background = settingsController.colorScheme.backgroundGradient.first
            
            NavigationLink(destination: ColorView(type: .backgroundGradient)) {
                Text("Background Gradient Colors")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(background)
            
            NavigationLink(destination: ColorView(type: .sliderGradient)) {
                Text("Slider Gradient Colors")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(background)
            
            NavigationLink(destination: ColorView(type: .textColor)) {
                Text("Text Color")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(background)
            
            NavigationLink(destination: ColorView(type: .buttonColor)) {
                Text("Button Color")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(background)
            
            NavigationLink(destination: ColorView(type: .secondaryButtonColor)) {
                Text("Secondary Button Color")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(background)
            
            NavigationLink(destination: CSPresets()) {
                Text("Color Scheme Presets")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(background)
        }
        .navigationBarTitle("Settings")
    }
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let setCon = SettingsController.shared
        
        SettingsView()
            .environmentObject(setCon)
    }
}
