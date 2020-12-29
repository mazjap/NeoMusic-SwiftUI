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
    @EnvironmentObject private var musicController: MusicController
    
    @State private var showSettingsBar: Bool = false
    @State private var profileRoation: Double = 0
    
    @Namespace private var nspace
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if showSettingsBar {
                        Spacer()
                            .frame(height: BarButton.size)
                    } else {
                        Spacer()
                        
                        BarButton(systemImageName: "gearshape.fill", buttonColor: settingsController.colorScheme.textColor.color) {
                            withAnimation {
                                showSettingsBar = true
                            }
                        }
                        .spacing(.trailing)
                        .matchedGeometryEffect(id: "BarButton", in: nspace)
                    }
                }
                
                RotatableImage(colorScheme: settingsController.colorScheme, image: .placeholder /* TODO: - Use user icon */, rotation: $profileRoation)
                    .frame(height: 200)
                
                Text("Username")
                    .font(.title)
                    .foregroundColor(settingsController.colorScheme.textColor.color)
                
                Spacer()
            }
            
            if showSettingsBar {
                VStack {
                    SettingsBar(backgroundColor: settingsController.colorScheme.backgroundGradient.first, namespace: nspace, isOpen: $showSettingsBar)
                        .padding(.horizontal, Constants.spacing / 2)
                    
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
                .environmentObject(MusicController())
        }
    }
}
