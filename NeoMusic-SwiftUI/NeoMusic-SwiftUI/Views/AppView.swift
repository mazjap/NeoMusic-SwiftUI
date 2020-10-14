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
    
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var musicController: MusicPlayerController {
        didSet {
            musicController.delegate = searchController
        }
    }
    @EnvironmentObject private var feedback: FeedbackGenerator
    
    @State private var musicPlayerIsOpen: Bool = true
    
    // MARK: - Variables
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
                    TabItem(title: "Search", imageName: "magnifyingglass") {
                        SearchView(searchController: searchController)
                    }
                    
                    TabItem(title: "Music", imageName: musicController.isPlaying ? "pause.fill" : "play.fill") {
                        Text("Content here")
                    }
                    
                    TabItem(title: "Profile", imageName: "person.fill") {
                        Text("Content here")
                    }
                }
                .accentColor(settingsController.colorScheme.textColor.color)
                
                MusicPlayer(isOpen: $musicPlayerIsOpen)
                    .frame(height: geometry.size.height - TabBar.height)
                    .offset(y: -TabBar.height / 2)
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
