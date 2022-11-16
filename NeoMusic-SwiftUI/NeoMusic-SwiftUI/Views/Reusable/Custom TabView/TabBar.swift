import SwiftUI

protocol Tabbable {
    var title: String { get }
    var image: Image { get }
}

extension Tabbable where Self: RawRepresentable, Self.RawValue == String {
    var title: String {
        rawValue
    }
}

struct TabBar<TabItem: CaseIterable & Tabbable, Content: View>: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    
    @GestureState private var dragOffset: DragState = .inactive
    
    @State private var selectedIndex: Int
    
    
    // MARK: - Variables
    
    private let content: (TabItem) -> Content
    private let items: [TabItem]
    
    private var contentOffset: CGFloat {
        CGFloat(selectedIndex) * UIScreen.main.bounds.width
    }
    
    // MARK: - Initializers
    
    init(tabItem: TabItem.Type, startIndex: Int = 0, @ViewBuilder content: @escaping (TabItem) -> Content) {
        self.content = content
        self.items = Array(tabItem.allCases)
        self._selectedIndex = .init(initialValue: (startIndex < TabItem.allCases.count && startIndex >= 0 ? startIndex : 0))
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    content(items[selectedIndex])
                        .frame(width: geometry.size.width)
                        .layoutPriority(2)
                    
                    ZStack(alignment: .leading) {
                        settingsController.colorScheme.backgroundGradient.last
                            .edgesIgnoringSafeArea(.bottom)
                            .zIndex(-2)
                        
                        HStack {
                            Spacer()
                            
                            ForEach(0..<items.count, id: \.self) { i in
                                item(at: i)
                                
                                Spacer()
                            }
                        }
                        .overlayPreferenceValue(TabBarPreferenceKey.self) {
                            self.indicator($0)
                        }
                    }
                    .frame(height: tabBarHeight)
                    .zIndex(-1)
                }
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func changeIndex(to index: Int) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 1)) {
            self.selectedIndex = index % items.count
        }
        
        feedbackGenerator.impactOccurred()
    }
    
    private func item(at index: Int) -> some View {
        Button(action: {
            changeIndex(to: index)
        }) {
            VStack {
                let tabItem = items[index]
                
                tabItem.image
                
                Text(tabItem.title)
            }
        }
        .anchorPreference(key: TabBarPreferenceKey.self, value: .bounds) {
            self.selectedIndex == index ? $0 : nil
        }
        .accentColor(index == selectedIndex ? settingsController.colorScheme.mainButtonColor.color : settingsController.colorScheme.secondaryButtonColor.color)
    }
    
    private func indicator(_ bounds: Anchor<CGRect>?) -> some View {
        GeometryReader { geometry in
            let frame = geometry[bounds!]
            if bounds != nil {
                settingsController.colorScheme.mainButtonColor.color
                    .cornerRadius(3)
                    .frame(width: frame.width, height: 3)
                    .offset(x: frame.minX, y: 6)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}

let tabBarHeight = UIScreen.main.bounds.height / 12

// MARK: - TabBar: PreferenceKey

struct TabBarPreferenceKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
        
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
    
}

// MARK: - Preview

struct TabBar_Previews: PreviewProvider {
    enum PreviewTab: String, CaseIterable, Tabbable {
        case circle = "Circle"
        case square = "Square"
        case square2
        case square3
        case square4
        
        var image: Image {
            let name: String = {
                switch self {
                case .circle:
                    return "circle.fill"
                default:
                    return "square.fill"
                }
            }()
            
            return Image(systemName: name)
        }
    }
    
    static var previews: some View {
        TabBar(tabItem: PreviewTab.self) { item in
            ZStack {
                Color.gray
                    .ignoresSafeArea(edges: .top)
                
                switch item {
                case .circle:
                    VStack {
                        Text("Content goes here:")
                        
                        Circle()
                            .foregroundColor(.blue)
                    }
                default:
                    VStack {
                        Text("Content goes here: \(item.title)")
                        
                        Rectangle()
                            .frame(width: 300, height: 300)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .environmentObject(SettingsController.shared)
        .environmentObject(FeedbackGenerator.init(feedbackEnabled: false))
    }
}
