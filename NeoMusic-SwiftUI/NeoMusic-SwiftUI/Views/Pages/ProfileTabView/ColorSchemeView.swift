import SwiftUI

struct ColorSchemeView: View {
    enum Items: String, CaseIterable {
        case backgroundGradient = "Background Gradient"
        case sliderGradient = "Slider Gradient"
        case textColor = "Text Color"
        case buttonColor = "Button Color"
        case secondaryButtonColor = "Secondary Button Color"
        case colorSchemePresets = "Color Scheme Presets"
    }
    
    @EnvironmentObject private var settingsController: SettingsController
    @State private var selectedIndex = 0
    @State private var isOpen = false
    
    private let background: Color
    
    init(backgroundColor: Color) {
        self.background = backgroundColor
    }
    
    var body: some View {
        ZStack {
//            LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
//                .cornerRadius(20)
//            VStack {
//                ZStack {
//                    let font: Font = .title
//
//                    VStack {
//                        DropDownView(data: .constant(Items.allCases), isOpen: $isOpen, backgroundColor: settingsController.colorScheme.backgroundGradient.first.opacity(0.75)) { item in
//                            Text(item.rawValue)
//                                .padding()
//                                .onTapGesture {
//                                    // Do stuff with item
//                                }
//                        }
//                        DropDownView(isOpen: $isOpen, selectedItem: $selectedIndex.onChanged(selectedIndexChanged(to:)), backgroundColor: settingsController.colorScheme.backgroundGradient.first.opacity(0.75)) {
//                            DropDownItem(label: "Background Gradient", detail: nil)
//                            DropDownItem(label: "Slider Gradient", detail: nil)
//                            DropDownItem(label: "Text Color", detail: nil)
//                            DropDownItem(label: "Button Color", detail: nil)
//                            DropDownItem(label: "Secondary Button Color", detail: nil)
//                            DropDownItem(label: "Color Scheme Presets", detail: nil)
//                        }
//                        .font(font)
//                        .frame(height: 100)
//                        .zIndex(1)
//
//                        if selectedIndex == 5 {
//                            CSPresets()
//                        } else {
//                            switch selectedIndex {
//                            case 0:
//                                ColorPickerDetailView(type: .backgroundGradient)
//                            case 1:
//                                ColorPickerDetailView(type: .sliderGradient)
//                            case 2:
//                                ColorPickerDetailView(type: .textColor)
//                            case 3:
//                                ColorPickerDetailView(type: .buttonColor)
//                            default:
//                                ColorPickerDetailView(type: .secondaryButtonColor)
//                            }
//
//                            Text("\(selectedIndex)")
//                        }
//                    }
//                    .zIndex(0)
//                    .offset(y: font.size + Constants.spacing)
//                }
//            }
//
//            Spacer()
//                .frame(height: MusicPlayer.musicPlayerHeightOffset + tabBarHeight)
        }
    }
    
    func selectedIndexChanged(to index: Int) {
        print(index)
    }
}

struct ColorSchemeView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemeView(backgroundColor: .black)
            .environmentObject(SettingsController.shared)
    }
}
