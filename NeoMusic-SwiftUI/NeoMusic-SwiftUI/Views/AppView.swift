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
        let tab = UITabBar.appearance()
        
        tab.barTintColor = color.uiColor
        tab.isTranslucent = false
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            MusicPlayer(musicController: musicController)
                .statusBar(hidden: true)
                .edgesIgnoringSafeArea(.top)
                .tabItem {
                Image(systemName: musicController.isPlaying ? "pause.fill" : "play.fill")
                Text("Music")
            }
        }
        .foregroundColor(.black)
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
