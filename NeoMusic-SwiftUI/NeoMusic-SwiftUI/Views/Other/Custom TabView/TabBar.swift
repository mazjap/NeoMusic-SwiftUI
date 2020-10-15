//
//  CustomTabBar.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 9/4/20.
//
//  Inspired by:
//  https://www.objc.io/blog/2020/02/25/swiftui-tab-bar/
//

import SwiftUI

struct TabBar: View {
    static var height = UIScreen.main.bounds.height / 12
    
    @GestureState var dragOffset: CGFloat = 0
    
    @EnvironmentObject private var settingsController: SettingsController
    @State private var selectedIndex: Int = 0 {
        didSet {
            impact.impactOccurred()
        }
    }
    
    private let impact: UIImpactFeedbackGenerator
    let items: [TabItem]
    
    init(impact: UIImpactFeedbackGenerator = .init(), @TabBuilder _ items: () -> [TabItem]) {
        self.items = items()
        self.impact = impact
    }
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                items[selectedIndex - 1 < 0 ? items.count - 1 : selectedIndex - 1]
                    .offset(x: -UIScreen.main.bounds.width + dragOffset)
                let offset = dragOffset
                items[selectedIndex].content
                    .offset(x: dragOffset)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation.width
                            }
                            .onEnded { value in
                                if offset > 50 {
                                    changeIndex(to: selectedIndex == 0 ? items.count - 1 : selectedIndex - 1)
                                } else if offset < -50 {
                                    changeIndex(to: selectedIndex == items.count - 1 ? 0 : selectedIndex + 1)
                                }
                            }
                    )
                
                items[selectedIndex + 1 >= items.count ? 0 : selectedIndex + 1]
                    .offset(x: UIScreen.main.bounds.width + dragOffset)
            }
            .animation(.easeInOut)

            Spacer()
            ZStack {
                Rectangle()
                    .foregroundColor(settingsController.colorScheme.backgroundGradient.last)
                    .ignoresSafeArea(edges: .bottom)
                
                HStack {
                    Spacer()
                    ForEach(0..<items.count) { i in
                        item(at: i)
                        Spacer()
                    }
                }
                .overlayPreferenceValue(TabBarPreferenceKey.self) {
                    self.indicator($0)
                }
                .padding()
            }
            .frame(height: Self.height)
        }
    }
    
    private func changeIndex(to index: Int) {
        guard index >= 0, index < items.count else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 1)) {
            self.selectedIndex = index
        }
    }
    
    private func item(at index: Int) -> some View {
        Button(action: {
            changeIndex(to: index)
        }) {
            VStack {
                items[index].image
                
                items[index].title
            }
        }
        .anchorPreference(key: TabBarPreferenceKey.self, value: .bounds) {
            self.selectedIndex == index ? $0 : nil
        }
        .accentColor(index == selectedIndex ? settingsController.colorScheme.mainButtonColor.color : settingsController.colorScheme.secondaryButtonColor.color)
    }
    
    private func indicator(_ bounds: Anchor<CGRect>?) -> some View {
        GeometryReader { geometry in
            if bounds != nil {
                Rectangle()
                    .fill(settingsController.colorScheme.mainButtonColor.color)
                    .frame(width: geometry[bounds!].width, height: 3)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .offset(x: geometry[bounds!].minX, y: 6)
                    .frame(maxHeight: .infinity, alignment: .bottomLeading)
            }
        }
    }
}

struct TabBarPreferenceKey: PreferenceKey {
    typealias Value = Anchor<CGRect>?
    
    static var defaultValue: Value = nil
        
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value ?? nextValue()
    }
    
}

@_functionBuilder
struct TabBuilder {
    static func buildBlock(_ children: TabItem...) -> [TabItem] {
        children
    }
}

// MARK: - Preview

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
                .ignoresSafeArea(edges: .top)
            
            TabBar {
                TabItem(title: "Circle", imageName: "circle.fill") {
                    VStack {
                        Text("Content goes here:")
                        
                        Circle()
                            .foregroundColor(.blue)
                    }
                }
                
                TabItem(title: "Rectangle", imageName: "square.fill") {
                    VStack {
                        Text("Content goes here:")
                        
                        Rectangle()
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .environmentObject(SettingsController())
    }
}
