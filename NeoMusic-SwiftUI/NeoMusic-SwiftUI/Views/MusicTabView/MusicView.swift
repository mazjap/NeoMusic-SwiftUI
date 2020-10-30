//
//  MusicView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/22/20.
//

import SwiftUI

struct MusicView: View {
    @EnvironmentObject var settingsController: SettingsController
    @EnvironmentObject var musicController: MusicPlayerController
    
    var body: some View {
        Text("Hello, World!")
            .foregroundColor(settingsController.colorScheme.textColor.color)
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView()
            .environmentObject(SettingsController.shared)
            .environmentObject(MusicPlayerController())
    }
}
