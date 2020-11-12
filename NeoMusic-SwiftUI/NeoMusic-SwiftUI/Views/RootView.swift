//
//  RootView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Root view, separates app into tabs, creates shared values.
//

import SwiftUI

struct RootView: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var feedback: FeedbackGenerator
    @EnvironmentObject private var musicController: MusicPlayerController {
        didSet {
            musicController.delegate = searchController
        }
    }
    
    @StateObject private var searchController = SongSearchController()
    @StateObject private var messageController = MessageController.shared
    @State private var musicPlayerIsOpen: Bool = true
    
    
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
                        MusicView()
                    }
                    
                    TabItem(title: "Profile", imageName: "person.fill") {
                        ProfileView()
                    }
                }
                .accentColor(settingsController.colorScheme.textColor.color)
                
                MusicPlayer(isOpen: $musicPlayerIsOpen)
                    .frame(height: geometry.size.height - TabBar.height)
                    .offset(y: musicPlayerIsOpen ? -TabBar.height / 2 : geometry.size.height / 2 - TabBar.height - MusicPlayer.musicPlayerHeightOffset / 2)
                
                if let message = messageController.message {
                    let size = CGSize(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.15)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(settingsController.colorScheme.backgroundGradient.first.opacity(0.75))
                            .frame(size: size)
                        
                        Text(message.value)
                            .foregroundColor(message.type.color)
                            .frame(size: size)
                    }
                    .offset(y: size.height - UIScreen.main.bounds.height / 2)
                }
            }
        }
    }
}

// MARK: - Preview

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(SettingsController.shared)
            .environmentObject(MusicPlayerController())
    }
}
