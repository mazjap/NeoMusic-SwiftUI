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
    
    // MARK: - Body
    
    var body: some View {
        List {
            let background = settingsController.colorScheme.backgroundGradient.first
            
            NavigationLink(destination: ColorPickerDetailView(type: .backgroundGradient)) {
                Text("Background Gradient Colors")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(background)
            
            NavigationLink(destination: ColorPickerDetailView(type: .sliderGradient)) {
                Text("Slider Gradient Colors")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(background)
            
            NavigationLink(destination: ColorPickerDetailView(type: .textColor)) {
                Text("Text Color")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(background)
            
            NavigationLink(destination: ColorPickerDetailView(type: .buttonColor)) {
                Text("Button Color")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(background)
            
            NavigationLink(destination: ColorPickerDetailView(type: .secondaryButtonColor)) {
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
