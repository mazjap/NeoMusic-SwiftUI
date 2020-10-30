//
//  ProfileView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/22/20.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var settingsController: SettingsController
    @EnvironmentObject var musicController: MusicPlayerController
    
    @State private var showSettingsView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: SettingsView(),
                        isActive: $showSettingsView) {
                        BarButton(imageName: "gearshape.fill", buttonColor: settingsController.colorScheme.mainButtonColor.color) {
                            showSettingsView = true
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

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
