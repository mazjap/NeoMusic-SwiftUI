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
    
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(entity: CDColorScheme.entity(), sortDescriptors: []) var colorSchemes: FetchedResults<CDColorScheme>
    
    @State private var isEditing = false
    
    // MARK: - Body
    
    var body: some View {
        let schemes = colorSchemes.compactMap { $0.jc }
        
        ZStack {
            LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .top)
            // TODO: - Use ScrollView
            VStack {
                let selectedScheme = Binding<JCColorScheme>(get: { return .default }, set: { newVal in
                    settingsController.setCurrentColorScheme(newVal)
                })
                
                HStack {
                    CSButton(colorScheme: Constants.defaultColorScheme, title: "Default", selectedScheme: selectedScheme, isEditing: $isEditing)
                    
                    CSButton(colorScheme: Constants.lightColorScheme, title: "White", selectedScheme: selectedScheme, isEditing: $isEditing)
                    
                    CSButton(colorScheme: Constants.darkColorScheme, title: "Black", selectedScheme: selectedScheme, isEditing: $isEditing)
                }
                .frame(height: 100)
                .spacing(.horizontal)
                
                let arrs = schemes.arrs
                
                ForEach(0..<arrs.count) { i in
                    let arr = arrs[i]
                    HStack {
                        ForEach(arr) { cs in
                            CSButton(colorScheme: cs, title: "Saved", selectedScheme: selectedScheme, isEditing: $isEditing)
                        }
                    }
                    .frame(height: 100)
                    .spacing(.horizontal)
                }
                
                Spacer()
            }
        }
        .if(!(schemes + Constants.defaults).contains(settingsController.colorScheme)) {
            $0.navigationBarItems(trailing: BarButton(title: "Save", buttonColor: settingsController.colorScheme.mainButtonColor.color) {
                _ = CDColorScheme(settingsController.colorScheme, context: context)
                CoreDataStack.shared.save(context: context)
            })
        }
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
        var tempArr: [[JCColorScheme]] = [[]]
        for colorScheme in self {
            if tempArr[tempArr.count - 1].count == 3 {
                tempArr.append([colorScheme])
            } else {
                tempArr[tempArr.count - 1].append(colorScheme)
            }
        }
        return tempArr
    }
}
