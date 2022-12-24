import SwiftUI

struct ColorSchemeView: View {
    enum PickerItem: Hashable {
        case presets
        case schemeItem(JCColorScheme.ColorType)
        
        var rawValue: String {
            switch self {
            case .presets:
                return "Presets"
            case let .schemeItem(item):
                return item.rawValue
            }
        }
        
        static var allCases: [PickerItem] {
            [.presets] + JCColorScheme.ColorType.allCases.map(PickerItem.schemeItem)
        }
    }
    
    @EnvironmentObject private var settingsController: SettingsController
    @State private var selected: PickerItem = .presets
    @State private var isOpen = false
    
    private let background: Color
    
    init(backgroundColor: Color) {
        self.background = backgroundColor
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Picker("Theme Item", selection: $selected) {
                    ForEach(PickerItem.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 160)
                
                if case let .schemeItem(item) = selected {
                    ColorPickerDetailView(type: item)
                } else {
                    CSPresets()
                }
            }
        }
        .navigationTitle("Theme")
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
