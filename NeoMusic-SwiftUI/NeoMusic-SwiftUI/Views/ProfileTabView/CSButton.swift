//
//  CSButton.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/12/20.
//

import SwiftUI

struct CSButton: View {
    
    @EnvironmentObject private var settingsController: SettingsController
    
    private let colorScheme: JCColorScheme
    private let title: String
    
    init(colorScheme: JCColorScheme, title: String) {
        self.colorScheme = colorScheme
        self.title = title
    }
    
    var body: some View {
        Button {
            settingsController.setColorScheme(colorScheme)
            UIApplication.shared.setNeedsStatusBarAppearanceUpdate()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom))
                
                Text(title)
                    .foregroundColor(colorScheme.textColor.color)
            }
        }
    }
}

struct CSButton_Previews: PreviewProvider {
    static var previews: some View {
        CSButton(colorScheme: JCColorScheme.default, title: "Color Scheme")
            .environmentObject(SettingsController.shared)
    }
}
