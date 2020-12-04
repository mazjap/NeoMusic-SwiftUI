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
    
    @State private var showSettingsBar: Bool = false
    
    @Namespace private var nspace
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            HStack {
                if showSettingsBar {
                    SettingsBar(backgroundColor: settingsController.colorScheme.backgroundGradient.first, namespace: nspace, isOpen: $showSettingsBar)
                        .padding(.horizontal, Constants.spacing / 2)
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
            
            Spacer()
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
