//
//  MusicView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/22/20.
//

import SwiftUI

struct MusicView: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var musicController: MusicPlayerController
    
    // MARK: - Body
    
    var body: some View {
        Text("Hello, World!")
            .foregroundColor(settingsController.colorScheme.textColor.color)
    }
}

// MARK: - Preview

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView()
            .environmentObject(SettingsController.shared)
            .environmentObject(MusicPlayerController())
    }
}
