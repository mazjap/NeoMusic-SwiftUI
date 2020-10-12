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
    @EnvironmentObject var musicController: MusicPlayerController
    
    // MARK: - Variables
    
    let impact = UIImpactFeedbackGenerator(style: .rigid)
    var searchController = SongSearchController()
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: geometry.size.height - TabBar.height)
                    .offset(y: -TabBar.height / 2)
                
                TabBar {
                    TabItem(title: "Search", imageName: "magnifyingglass", impact: impact) {
                        SearchView(searchController: searchController)
                    }
                    
                    TabItem(title: "Music", imageName: musicController.isPlaying ? "pause.fill" : "play.fill", impact: impact) {
                        Text("Content here")
                    }
                    
                    TabItem(title: "History", imageName: "clock.fill", impact: impact) {
                        Text("Content here")
                    }
                    
                    TabItem(title: "Profile", imageName: "person.fill", impact: impact) {
                        Text("Content here")
                    }
                }
                .accentColor(settingsController.colorScheme.textColor.color)
                
//                MusicPlayer(impact: impact)
//                    .frame(height: geometry.size.height - TabBar.height)
//                    .offset(y: -TabBar.height / 2)
            }
        }
    }
}

// MARK: - Preview

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(SettingsController())
            .environmentObject(MusicPlayerController())
    }
}
