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
        let nbAppearance = UINavigationBar.appearance()
        let textColor = sc.colorScheme.textColor.color.uiColor
        
        nbAppearance.titleTextAttributes = [.foregroundColor: textColor]
        nbAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]
        nbAppearance.barTintColor = sc.colorScheme.backgroundGradient.last.uiColor
    }
    
    // MARK: - Body
    
    var body: some View {
        List {
            NavigationLink(destination: ColorView(type: .backgroundGradient)) {
                Text("Background Gradient Colors")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(settingsController.colorScheme.backgroundGradient.last)
            
            NavigationLink(destination: ColorView(type: .sliderGradient)) {
                Text("Slider Gradient Colors")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(settingsController.colorScheme.backgroundGradient.last)
            
            NavigationLink(destination: ColorView(type: .textColor)) {
                Text("Text Color")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(settingsController.colorScheme.backgroundGradient.last)
            
            NavigationLink(destination: ColorView(type: .buttonColor)) {
                Text("Button Color")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(settingsController.colorScheme.backgroundGradient.last)
            
            NavigationLink(destination: ColorView(type: .secondaryButtonColor)) {
                Text("Secondary Button Color")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
            .listRowBackground(settingsController.colorScheme.backgroundGradient.last)
        }
        .navigationBarTitle("Settings")
    }
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let setCon = SettingsController.shared
        
        return ZStack {
            LinearGradient(gradient: setCon.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
        
            SettingsView()
                .environmentObject(setCon)
        }
    }
}
