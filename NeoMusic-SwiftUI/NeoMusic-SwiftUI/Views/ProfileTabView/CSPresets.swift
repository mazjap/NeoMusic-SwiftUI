//
//  CSPresets.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/12/20.
//

import SwiftUI

struct CSPresets: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    
    @State private var isEditing = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .top)
            // TODO: - Use ScrollView
            VStack {
                HStack {
                    CSButton(colorScheme: Constants.defaultColorScheme, title: "Default", isEditing: $isEditing)
                    
                    CSButton(colorScheme: Constants.lightColorScheme, title: "White", isEditing: $isEditing)
                    
                    CSButton(colorScheme: Constants.darkColorScheme, title: "Black", isEditing: $isEditing)
                }
                .frame(height: 100)
                .spacing(.horizontal)
                
                let arrs = settingsController.fetchUserColorSchemes().arrs
                
                ForEach(0..<arrs.count) { i in
                    HStack {
                        ForEach(arrs[i]) { cs in
                            CSButton(colorScheme: cs, title: "Saved", isEditing: $isEditing)
                        }
                    }
                    .frame(height: 100)
                    .spacing(.horizontal)
                }
                
                Spacer()
            }
        }
        .navigationBarItems(trailing: BarButton(title: "Save", buttonColor: settingsController.colorScheme.mainButtonColor.color) {
                settingsController.addUserColorScheme()
            }
        )
    }
}

// MARK: - Preview

struct CSPresets_Previews: PreviewProvider {
    static var previews: some View {
        CSPresets()
    }
}

// MARK: - Extension Array: JCColorScheme

extension Array where Element == JCColorScheme {
    var arrs: [[JCColorScheme]] {
        var tempArr = [[JCColorScheme]]()
        var index = 0
        for (i, colorScheme) in enumerated() {
            if i % 3 == 0 {
                tempArr.append([colorScheme])
                index += 1
            } else {
                tempArr[index].append(colorScheme)
            }
        }
        return tempArr
    }
}
