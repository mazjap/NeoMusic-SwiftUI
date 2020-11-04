//
//  ProfileView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/22/20.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var musicController: MusicPlayerController
    
    @State private var showSettingsView: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: geometry.size.height + MusicPlayer.musicPlayerHeightOffset - TabBar.height)
                    .offset(y: -TabBar.height / 2)
                
                Text("Hello, World!")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
                
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(
                            destination: SettingsView(),
                            isActive: $showSettingsView) {
                            BarButton(systemImageName: "gearshape.fill", buttonColor: settingsController.colorScheme.mainButtonColor.color) {
                                showSettingsView = true
                            }
                        }
                    }
                    .spacing()
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Preview

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let setCon = SettingsController.shared
        
        ZStack {
            LinearGradient(gradient: setCon.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
            
            ProfileView()
                .environmentObject(setCon)
                .environmentObject(MusicPlayerController())
        }
    }
}
