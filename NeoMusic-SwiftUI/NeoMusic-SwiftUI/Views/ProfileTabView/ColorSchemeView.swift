//
//  ColorSchemeView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/1/20.
//

import SwiftUI

struct ColorSchemeView: View {
    @EnvironmentObject private var settingsController: SettingsController
    @State private var selectedIndex = 0
    @State private var isOpen = false
    
    private let background: Color
    
    init(backgroundColor: Color) {
        self.background = backgroundColor
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                .cornerRadius(20)
            VStack {
                ZStack {
                    let font: Font = .title
                    
                    VStack {
                        DropDownView(isOpen: $isOpen, selectedItem: $selectedIndex.onChanged(selectedIndexChanged(to:)), backgroundColor: settingsController.colorScheme.backgroundGradient.first.opacity(0.75)) {
                            DropDownItem(label: "Background Gradient", detail: nil)
                            DropDownItem(label: "Slider Gradient", detail: nil)
                            DropDownItem(label: "Text Color", detail: nil)
                            DropDownItem(label: "Button Color", detail: nil)
                            DropDownItem(label: "Secondary Button Color", detail: nil)
                            DropDownItem(label: "Color Scheme Presets", detail: nil)
                        }
                        .usesSeperator(true)
                        .showsScrollingIndicator(false)
                        .font(font)
                        .roundedCorners(20)
                        .tableHeight(200)
                        .cellColor(settingsController.colorScheme.backgroundGradient.first)
                        .textColor(settingsController.colorScheme.textColor.color)
                        .cellSpacing(4)
                        .frame(height: 100)
                        .spacing(.horizontal)
                        .zIndex(1)
                    
                        if selectedIndex == 5 {
                            CSPresets()
                        } else {
                            switch selectedIndex {
                            case 0:
                                ColorPickerDetailView(type: .backgroundGradient)
                            case 1:
                                ColorPickerDetailView(type: .sliderGradient)
                            case 2:
                                ColorPickerDetailView(type: .textColor)
                            case 3:
                                ColorPickerDetailView(type: .buttonColor)
                            default:
                                ColorPickerDetailView(type: .secondaryButtonColor)
                            }
                            
                            Text("\(selectedIndex)")
                        }
                    }
                    .zIndex(0)
                    .offset(y: font.size + Constants.spacing)
                }
            }
            
            Spacer()
                .frame(height: MusicPlayer.musicPlayerHeightOffset + TabBar.height)
        }
    }
    
    func selectedIndexChanged(to index: Int) {
        print(index)
    }
}

struct ColorSchemeView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemeView(backgroundColor: .black)
    }
}
