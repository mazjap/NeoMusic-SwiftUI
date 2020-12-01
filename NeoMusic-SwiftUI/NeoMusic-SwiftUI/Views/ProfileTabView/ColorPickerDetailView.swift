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
    
    @Namespace private var nspace
    
    @State private var colorOption: Int = 0
    @State private var brightness: Double = 0
    @State private var hex1: String
    @State private var hex2: String
    
    @State private var color1: EasyColor
    @State private var color2: EasyColor
    
    // MARK: - Variables
    
    let type: JCColorScheme.ColorType
    
    // MARK: - Initializers
    
    init(type: JCColorScheme.ColorType) {
        let sc = SettingsController.shared
        
        self.type = type
        
        let c1: State<EasyColor>
        let c2: State<EasyColor>
        
        switch type {
        case .backgroundGradient:
            c1 = State(wrappedValue: sc.colorScheme.backgroundGradient[0])
            c2 = State(wrappedValue: sc.colorScheme.backgroundGradient[1])
        case .sliderGradient:
            c1 = State(wrappedValue: sc.colorScheme.sliderGradient[0])
            c2 = State(wrappedValue: sc.colorScheme.sliderGradient[1])
        case .textColor:
            c1 = State(wrappedValue: sc.colorScheme.textColor)
            c2 = State(wrappedValue: sc.colorScheme.textColor)
        case .buttonColor:
            c1 = State(wrappedValue: sc.colorScheme.mainButtonColor)
            c2 = State(wrappedValue: sc.colorScheme.mainButtonColor)
        case .secondaryButtonColor:
            c1 = State(wrappedValue: sc.colorScheme.secondaryButtonColor)
            c2 = State(wrappedValue: sc.colorScheme.secondaryButtonColor)
        }
        
        self._color1 = c1
        self._color2 = c2
        self._hex1 = .init(initialValue: c1.wrappedValue.hex)
        self._hex2 = .init(initialValue: c2.wrappedValue.hex)
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all, edges: .top)
            
            VStack(spacing: 20) {
                if type.isGradient {
                    SegmentedControl(index: $colorOption, textColor: settingsController.colorScheme.textColor.color, background: settingsController.colorScheme.backgroundGradient.first)
                        .options(["Top Color", "Bottom Color"])
                        .spacing()
                }
                
                GeometryReader { geometry in
                    VStack {
                        HStack {
                            ZStack {
                                color1.color
                                    .cornerRadius(20)
                                
                                if colorOption == 0 {
                                TextField("", text: $hex1.onChanged(userChangedColor1Hex(to:)))
                                    .multilineTextAlignment(.center)
                                    .font(.title2)
                                    .foregroundColor(settingsController.colorScheme.textColor.color)
                                } else {
                                    Text(hex1)
                                        .font(.title2)
                                        .foregroundColor(settingsController.colorScheme.textColor.color)
                                }
                            }
                            .frame(height: 100)
                            
                            if colorOption == 0 {
                                ColorSlider(($color1).onChanged(sliderChangedColor(to:)), size: CGSize(width: geometry.size.width, height: 100))
                                    .frame(height: 100)
                                    .spacing(.leading)
                                    .matchedGeometryEffect(id: Self.sliderKey, in: nspace)
                            }
                        }
                        .spacing(.horizontal)
                        
                        if type.isGradient {
                            HStack {
                                ZStack {
                                    color2.color
                                        .cornerRadius(20)
                                    
                                    if colorOption == 1 {
                                    TextField("", text: $hex2.onChanged(userChangedColor2Hex(to:)))
                                        .multilineTextAlignment(.center)
                                        .font(.title2)
                                        .foregroundColor(settingsController.colorScheme.textColor.color)
                                    } else {
                                        Text(hex2)
                                            .font(.title2)
                                            .foregroundColor(settingsController.colorScheme.textColor.color)
                                    }
                                }
                                .frame(height: 100)
                                
                                if colorOption == 1 {
                                    ColorSlider(($color2).onChanged(sliderChangedColor(to:)), size: CGSize(width: geometry.size.width, height: 100))
                                        .frame(height: 100)
                                        .spacing(.leading)
                                        .matchedGeometryEffect(id: Self.sliderKey, in: nspace)
                                }
                            }
                            .spacing(.horizontal)
                        }
                    }
                }
            }
        }
    }
    
    func userChangedColor1Hex(to newVal: String) {
        color1 = EasyColor(newVal) ?? color1
        sliderChangedColor(to: color1)
    }
    
    func userChangedColor2Hex(to newVal: String) {
        color2 = EasyColor(newVal) ?? color2
        sliderChangedColor(to: color2)
    }
    
    func sliderChangedColor(to color: EasyColor) {
        var cs = settingsController.colorScheme
        
        switch type {
        case .backgroundGradient:
            cs.backgroundGradient.removeColor(at: colorOption)
            cs.backgroundGradient.addColor(color, at: colorOption)
        case .sliderGradient:
            cs.sliderGradient.removeColor(at: colorOption)
            cs.sliderGradient.addColor(color, at: colorOption)
        case .textColor:
            cs.textColor = color
        case .buttonColor:
            cs.mainButtonColor = color
        case .secondaryButtonColor:
            cs.secondaryButtonColor = color
        }
        
        if colorOption == 0 {
            hex1 = color.hex
        } else {
            hex2 = color.hex
        }
        
        settingsController.setCurrentColorScheme(cs)
        UIApplication.shared.setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Static Variables
    
    static private let base = "ColorPickerDetailView."
    
    static let sliderKey = base + "ColorSlider"
}

// MARK: - Preview

struct ColorPickerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerDetailView(type: .backgroundGradient)
    }
}
