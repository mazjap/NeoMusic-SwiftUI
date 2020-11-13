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
    
    @State private var colorOption: Int = 0
    
    @Binding private var color1: Color
    @Binding private var color2: Color
    
    // MARK: - Variables
    
    let type: JCColorScheme.ColorType
    
    // MARK: - Initializer
    
    init(type: JCColorScheme.ColorType) {
        let sc = SettingsController.shared
        
        self.type = type
        
        self._color1 = .init(get: {
            switch type {
            case .backgroundGradient:
                return sc.colorScheme.backgroundGradient.first
            case .sliderGradient:
                return sc.colorScheme.sliderGradient.first
            case .textColor:
                return sc.colorScheme.textColor.color
            case .buttonColor:
                return sc.colorScheme.mainButtonColor.color
            case .secondaryButtonColor:
                return sc.colorScheme.secondaryButtonColor.color
            }
        }, set: { color in
            switch type {
            case .backgroundGradient:
                sc.colorScheme.backgroundGradient.removeColor(at: 0)
                sc.colorScheme.backgroundGradient.addColor(color, at: 0)
            case .sliderGradient:
                sc.colorScheme.sliderGradient.removeColor(at: 0)
                sc.colorScheme.sliderGradient.addColor(color, at: 0)
            case .textColor:
                sc.colorScheme.textColor = EasyColor(color)
            case .buttonColor:
                sc.colorScheme.mainButtonColor = EasyColor(color)
            case .secondaryButtonColor:
                sc.colorScheme.secondaryButtonColor = EasyColor(color)
            }
            sc.setCurrentColorScheme(sc.colorScheme)
            UIApplication.shared.setNeedsStatusBarAppearanceUpdate()
        })
        
        self._color2 = .init(get: {
            switch type {
            case .backgroundGradient:
                return sc.colorScheme.backgroundGradient.last
            case .sliderGradient:
                return sc.colorScheme.sliderGradient.last
            case .textColor:
                return sc.colorScheme.textColor.color
            case .buttonColor:
                return sc.colorScheme.mainButtonColor.color
            case .secondaryButtonColor:
                return sc.colorScheme.secondaryButtonColor.color
            }
        }, set: { color in
            switch type {
            case .backgroundGradient:
                sc.colorScheme.backgroundGradient.removeColor(at: 1)
                sc.colorScheme.backgroundGradient.addColor(color, at: 1)
            case .sliderGradient:
                sc.colorScheme.sliderGradient.removeColor(at: 1)
                sc.colorScheme.sliderGradient.addColor(color, at: 1)
            default:
                return
            }
            
            sc.setCurrentColorScheme(sc.colorScheme)
            UIApplication.shared.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all, edges: .top)
            
            VStack {
                HStack {
                    ColorPicker("", selection: colorOption == 0 ? $color1 : $color2)
                    Spacer()
                }
                
                if type.isGradient {
                    Picker("Select Color", selection: $colorOption) {
                        Text("Top Color").tag(0)
                        Text("Bottom Color").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
    }
}

// MARK: - Preview

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView(type: .backgroundGradient)
    }
}
