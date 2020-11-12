//
//  CSPresets.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/12/20.
//

import SwiftUI

struct CSPresets: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .top)
            
            VStack {
                HStack {
                    CSButton(colorScheme: Constants.defaultColorScheme, title: "Default")
                    
                    CSButton(colorScheme: Constants.lightColorScheme, title: "White")
                    
                    CSButton(colorScheme: Constants.darkColorScheme, title: "Black")
                }
                .frame(height: 100)
                .spacing(.horizontal)
                
                // TODO: - Save user schemes and use ForEach to place them in HStacks
                
                Spacer()
            }
        }
    }
}

// MARK: - Preview

struct CSPresets_Previews: PreviewProvider {
    static var previews: some View {
        CSPresets()
    }
}
