//
//  CSButton.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/12/20.
//

import SwiftUI

struct CSButton: View {
    
    @EnvironmentObject private var settingsController: SettingsController
    @Binding private var isEditing: Bool
    
    private let colorScheme: JCColorScheme
    private let title: String
    
    init(colorScheme: JCColorScheme, title: String, isEditing: Binding<Bool>) {
        self.colorScheme = colorScheme
        self.title = title
        self._isEditing = isEditing
    }
    
    var body: some View {
        Button {
            settingsController.setCurrentColorScheme(colorScheme)
            UIApplication.shared.setNeedsStatusBarAppearanceUpdate()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom))
                
                Text(title)
                    .foregroundColor(colorScheme.textColor.color)
            }
        }
        .offset(x: isEditing ? -10 : 0)
        .onLongPressGesture {
            isEditing = true
        }
        .animation(isEditing ? Animation.default.repeatForever() : nil)
    }
}

struct CSButton_Previews: PreviewProvider {
    @State static var isEditing = false
    
    static var previews: some View {
        CSButton(colorScheme: JCColorScheme.default, title: "Color Scheme", isEditing: $isEditing)
            .environmentObject(SettingsController.shared)
    }
}
