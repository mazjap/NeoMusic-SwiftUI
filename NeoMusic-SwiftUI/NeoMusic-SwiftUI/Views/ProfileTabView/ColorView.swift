//
//  ColorView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/26/20.
//

import SwiftUI

struct ColorView: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    
    // MARK: - Variables
    
    let type: JCColorScheme.ColorType
    
    // MARK: - Body
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Preview

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView(type: .backgroundGradient)
    }
}
