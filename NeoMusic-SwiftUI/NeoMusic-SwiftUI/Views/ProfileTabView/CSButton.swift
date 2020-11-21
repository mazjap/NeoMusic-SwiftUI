//
//  CSButton.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/12/20.
//

import SwiftUI

struct CSButton: View {
    @Binding private var isEditing: Bool
    @Binding private var selectedScheme: JCColorScheme
    
    private let colorScheme: JCColorScheme
    private let title: String
    
    init(colorScheme: JCColorScheme, title: String, selectedScheme: Binding<JCColorScheme>, isEditing: Binding<Bool>) {
        self.colorScheme = colorScheme
        self.title = title
        self._selectedScheme = selectedScheme
        self._isEditing = isEditing
    }
    
    var body: some View {
        Button {
            selectedScheme = colorScheme
            UIApplication.shared.setNeedsStatusBarAppearanceUpdate()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom))
                VStack {
                    Text(title)
                        .foregroundColor(colorScheme.textColor.color)
                }
            }
        }
        .onLongPressGesture {
            isEditing = true
        }
        .offset(x: isEditing ? -10 : 0)
        .animation(isEditing ? Animation.default.repeatForever() : nil)
    }
}

struct CSButton_Previews: PreviewProvider {
    @State static var isEditing = false
    @State static var selectedScheme: JCColorScheme = .default
    
    static var previews: some View {
        CSButton(colorScheme: JCColorScheme.default, title: "Color Scheme", selectedScheme: $selectedScheme, isEditing: $isEditing)
            .environmentObject(SettingsController.shared)
    }
}
