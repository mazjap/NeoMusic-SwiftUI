//
//  ColorPickerDetailView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/26/20.
//

import SwiftUI

struct ColorPickerDetailView: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    
    @State private var colorOption: Int = 0
    @State private var brightness: Double = 0
    @State private var hex: String = ""
    
    @Binding private var color1: EasyColor
    @Binding private var color2: EasyColor
    
    // MARK: - Variables
    
    let type: JCColorScheme.ColorType
    
    // MARK: - Initializer
    
    init(type: JCColorScheme.ColorType) {
        let sc = SettingsController.shared
        
        self.type = type
        
        self._color1 = .init(get: {
            switch type {
            case .backgroundGradient:
                return sc.colorScheme.backgroundGradient[0]
            case .sliderGradient:
                return sc.colorScheme.sliderGradient[0]
            case .textColor:
                return sc.colorScheme.textColor
            case .buttonColor:
                return sc.colorScheme.mainButtonColor
            case .secondaryButtonColor:
                return sc.colorScheme.secondaryButtonColor
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
                sc.colorScheme.textColor = color
            case .buttonColor:
                sc.colorScheme.mainButtonColor = color
            case .secondaryButtonColor:
                sc.colorScheme.secondaryButtonColor = color
            }
            sc.setCurrentColorScheme(sc.colorScheme)
            UIApplication.shared.setNeedsStatusBarAppearanceUpdate()
        })
        
        self._color2 = .init(get: {
            switch type {
            case .backgroundGradient:
                return sc.colorScheme.backgroundGradient[1]
            case .sliderGradient:
                return sc.colorScheme.sliderGradient[1]
            case .textColor:
                return sc.colorScheme.textColor
            case .buttonColor:
                return sc.colorScheme.mainButtonColor
            case .secondaryButtonColor:
                return sc.colorScheme.secondaryButtonColor
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
        
        hex = color1.hex
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all, edges: .top)
            
            VStack(spacing: 20) {
                if type.isGradient {
                    Picker("Select Color", selection: $colorOption) {
                        Text("Top Color").tag(0)
                        Text("Bottom Color").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .spacing()
                }
                
                GeometryReader { geometry in
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor((colorOption == 0 ? color1 : color2).color)
                            TextField("", text: Binding<String>(get: { return hex }, set: { newHex in
                                                                    hex = newHex
                                                                    if colorOption == 0 {
                                                                        color1 = EasyColor(hex) ?? color1
                                                                    } else {
                                                                        color2 = EasyColor(hex) ?? color2
                                                                    }}))
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .foregroundColor(settingsController.colorScheme.textColor.color)
                                .frame(width: geometry.size.width / 2)
                        }
                            .frame(height: 100)
                            .spacing(.horizontal)
                        
                        ColorSlider(Binding<EasyColor>(get: {return .red}, set:
                                                        { newColor in
                                                            hex = newColor.hex
                                                            if (colorOption == 0) {
                                                                color1 = newColor
                                                            } else {
                                                                color2 = newColor
                                                            }
                                                            
                                                        }), size: CGSize(width: geometry.size.width, height: 100))
                            .frame(height: 100)
                            .padding()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct ColorPickerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerDetailView(type: .backgroundGradient)
    }
}
