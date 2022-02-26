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
        VStack(spacing: 20) {
            if type.isGradient {
                SegmentedControl(index: $colorOption, textColor: settingsController.colorScheme.textColor.color, background: settingsController.colorScheme.backgroundGradient.first)
                    .options(["Top Color", "Bottom Color"])
                    .spacing()
            }
            
            GeometryReader { geometry in
                VStack {
                    HStack {
                        if colorOption == 0 {
                            if type.isGradient {
                                color2.color
                                    .cornerRadius(20)
                                    .frame(width: ColorSlider.width)
                                    .matchedGeometryEffect(id: Self.color2Key, in: nspace)
                            }
                            
                            ZStack {
                                color1.color
                                    .cornerRadius(20)
                                    .matchedGeometryEffect(id: Self.color1Key, in: nspace)
                                
                                if colorOption == 0 {
                                    TextField("", text: $hex1.onChanged(userChangedColor1Hex(to:)))
                                        .multilineTextAlignment(.center)
                                        .font(.title2)
                                        .foregroundColor(color1.color.perceivedBrightness > 0.5 ? .black : .white)
                                        .matchedGeometryEffect(id: Self.hexKey, in: nspace)
                                }
                            }
                        } else if type.isGradient {
                            color1.color
                                .cornerRadius(20)
                                .frame(width: ColorSlider.width)
                                .matchedGeometryEffect(id: Self.color1Key, in: nspace)
                            
                            ZStack {
                                color2.color
                                    .cornerRadius(20)
                                    .matchedGeometryEffect(id: Self.color2Key, in: nspace)
                                
                                TextField("", text: $hex2.onChanged(userChangedColor2Hex(to:)))
                                    .multilineTextAlignment(.center)
                                    .font(.title2)
                                    .foregroundColor(color2.color.perceivedBrightness > 0.5 ? .black : .white)
                                    .matchedGeometryEffect(id: Self.hexKey, in: nspace)
                            }
                        }
                        
                        ColorSlider((colorOption == 0 ? $color1 : $color2).onChanged(colorOption == 0 ? sliderChangedColor1(to:) : sliderChangedColor2(to:)), size: CGSize(width: geometry.size.width, height: 100))
                            .frame(height: 100)
                            .spacing(.leading)
                    }
                    .frame(height: 100)
                    .spacing(.horizontal)
                }
            }
        }
    }
    
    func userChangedColor1Hex(to newVal: String) {
        color1 = EasyColor(newVal) ?? color1
        sliderChangedColor1(to: color1)
    }
    
    func userChangedColor2Hex(to newVal: String) {
        color2 = EasyColor(newVal) ?? color2
        sliderChangedColor2(to: color2)
    }
    
    func sliderChangedColor1(to color: EasyColor) {
        var cs = settingsController.colorScheme
        
        switch type {
        case .backgroundGradient:
            cs.backgroundGradient.replaceColor(at: 0, with: color)
        case .sliderGradient:
            cs.sliderGradient.replaceColor(at: 0, with: color)
        case .textColor:
            cs.textColor = color
        case .buttonColor:
            cs.mainButtonColor = color
        case .secondaryButtonColor:
            cs.secondaryButtonColor = color
        }
        
        hex1 = color.hex
        
        settingsController.setCurrentColorScheme(cs)
        UIApplication.shared.setNeedsStatusBarAppearanceUpdate()
    }
    
    func sliderChangedColor2(to color: EasyColor) {
        var cs = settingsController.colorScheme
        
        if type == .backgroundGradient {
            cs.backgroundGradient.replaceColor(at: 1, with: color)
        } else if type == .sliderGradient {
            cs.sliderGradient.replaceColor(at: 1, with: color)
        }
        
        hex2 = color.hex
        
        settingsController.setCurrentColorScheme(cs)
        UIApplication.shared.setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Static Variables
    
    static private let base = "ColorPickerDetailView."
    
    static let color1Key = base + "Color1"
    static let color2Key = base + "Color2"
    static let hexKey    = base + "HexTextField"
}

// MARK: - Preview

struct ColorPickerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerDetailView(type: .backgroundGradient)
    }
}
