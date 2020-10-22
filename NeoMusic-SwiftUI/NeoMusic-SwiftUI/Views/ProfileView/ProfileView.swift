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
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SettingsController())
            .environmentObject(MusicPlayerController())
    }
}
