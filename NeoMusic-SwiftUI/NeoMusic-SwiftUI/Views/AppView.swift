//
//  AppView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Root view, separates apps into tabs, creates shared values.
//

import SwiftUI

struct AppView: View {
    
    // MARK: - State
    
    @EnvironmentObject var settingsController: SettingsController
    @ObservedObject var musicController = MusicController()
    
    // MARK: - Initializer
    
    init(color: Color = .black) {
        UITabBar.appearance().barTintColor = color.uiColor
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Rectangle()
             .foregroundColor(settingsController.colorScheme.backgroundGradient.color1.color)
             .edgesIgnoringSafeArea(.top)
             .frame(height: 0)
            
            TabView {
                MusicPlayer(musicController: musicController)
                .tabItem {
                    Image(systemName: musicController.isPlaying ? "pause.fill" : "play.fill")
                    Text("Music")
                }
            }
            .foregroundColor(.black)
        }
        .accentColor(settingsController.colorScheme.textColor.color)
    }
}

// MARK: - Preview

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        let setCon = SettingsController()
        
        AppView(color: setCon.colorScheme.backgroundGradient.color2.color)
            .environmentObject(setCon)
    }
}
