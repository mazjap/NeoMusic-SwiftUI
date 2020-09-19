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
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            TabBar {
                TabItem(title: "Search", imageName: "magnifyingglass", impact: impact) {
                    Text("Content here")
                }
                
                TabItem(title: "Music", imageName: "play.fill", impact: impact) {
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
            
            MusicPlayer(musicController: musicController, impact: impact)
//                .frame(height: 500)
//                .offset(y: -40)
        }
    }
}

// MARK: - Preview

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(SettingsController())
    }
}
