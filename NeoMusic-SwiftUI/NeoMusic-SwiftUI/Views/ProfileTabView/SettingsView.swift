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
        NavigationView {
            List {
                NavigationLink(destination: ColorView()) {
                    Text("Color Scheme")
                        .foregroundColor(settingsController.colorScheme.textColor.color)
                }
            }
            .navigationBarTitle("Settings")
        }
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
