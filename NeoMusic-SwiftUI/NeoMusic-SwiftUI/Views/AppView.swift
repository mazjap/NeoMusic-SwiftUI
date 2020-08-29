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
    @State var selectedIndex: Int = 0 {
        didSet {
            impact.impactOccurred()
        }
    }
    
    // MARK: - Variables
    
    let impact = UIImpactFeedbackGenerator(style: .rigid)
    
    // MARK: - Initializer
    
    init(color: Color = .black) {
        let tabBarAppearance = UITabBar.appearance()
        
        // Set Tab Bar to opaque custom color
        tabBarAppearance.barTintColor = color.uiColor
        tabBarAppearance.isTranslucent = false
        
        // Remove Tab Bar top shadow
        tabBarAppearance.backgroundImage = UIImage()
        tabBarAppearance.shadowImage = UIImage()
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            MusicPlayer(musicController: musicController, impact: impact)
                .statusBar(hidden: true)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }.tag(0)
            
            MusicPlayer(musicController: musicController, impact: impact)
                .tabItem {
                    Image(systemName: musicController.isPlaying ? "pause.fill" : "play.fill")
                    Text("Music")
                }.tag(1)
            
            Text("Not yet implemented")
                .foregroundColor(.white)
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }.tag(2)
            
            Text("Not yet implemented")
                .foregroundColor(.white)
                .statusBar(hidden: true)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }.tag(3)
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
