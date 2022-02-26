//
//  ColorSlider.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/16/20.
//

import SwiftUI

struct ColorSlider: View {
    @EnvironmentObject private var settingsController: SettingsController
    
    @State var isEditingSaturation = false
    @State var saturationMid: CGFloat = 0
    
    @State private var hue: Double = 1
    @State private var saturation: Double = 1
    @State private var brightness: Double = 1
    
    
    static let width: CGFloat = 10
    private var dragWidth: CGFloat
    
    private var offsetRadius: CGFloat {
        return Self.width / 3
    }
    
    @Binding private var selectedColor: EasyColor
    
    init(_ color: Binding<EasyColor>? = nil, size: CGSize = .zero) {
        self._selectedColor = color ?? .init(get: {return .red}, set: {_ in})
        self.dragWidth = (size.width - Self.width) / 2
    }
    
    var body: some View {
        GeometryReader { geometry in
            settingsController.colorScheme.textColor.color
                .cornerRadius(Self.width / 2)
                .overlay(
                LinearGradient(gradient: Gradient(colors: colors()), startPoint: .top, endPoint: .bottom)
                    .frame(width: Self.width - offsetRadius, height: geometry.size.height - offsetRadius)
                    .cornerRadius((Self.width - offsetRadius) / 2)
            )
                .frame(width: Self.width)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let touch = value.location
                        let widthCondition = (touch.x < Self.width + dragWidth) && (touch.x > -dragWidth)

                        if widthCondition {
                            let y = min(geometry.size.height, max(0, touch.y))
                            let start = value.startLocation
                            let distance = CGSize(width: start.x - touch.x, height: start.y - touch.y)
                            
                            brightness = Double(max(0, min(1, 1 - abs(distance.width) / dragWidth)))
                            hue = min(1, max(0, Double(y / geometry.size.height)))
                        }
                        selectedColor = EasyColor(hue: hue, saturation: saturation, brightness: brightness)
                    }
                    .onEnded { _ in
                        isEditingSaturation = false
                        saturation = 1
                        hue = 0
                        brightness = 0
                    }
            )
        }
        .frame(width: Self.width)
    }
    
    func colors(saturation: Double = 1, brightness: Double = 1) -> [Color] {
        
        var tempColors = [Color]()
        
        for i in stride(from: 0.0, to: Self.total, by: 1) {
            tempColors.append(Color(hue: i / Self.total, saturation: saturation, brightness: brightness))
        }
        
        return tempColors
    }
    
    func color(at percent: Double = 0, saturation: Double = 1, brightness: Double = 1) -> EasyColor {
        let hue = percent <= 1 && percent >= 0 ? percent : 0 * Self.total / Self.total
        
        return EasyColor(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    private static let total: Double = 350
}

struct ColorSlider_Previews: PreviewProvider {
    static var previews: some View {
        ColorSlider()
    }
}
