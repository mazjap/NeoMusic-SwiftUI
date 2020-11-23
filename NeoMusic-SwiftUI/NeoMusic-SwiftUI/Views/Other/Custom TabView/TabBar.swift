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
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    
    @GestureState private var dragOffset: CGFloat = 0
    
    @State private var selectedIndex: Int
    
    // MARK: - Variables
    
    private let items: [TabItem]
    
    // MARK: - Initializers
    
    init(startIndex: Int = 0, @TabBuilder _ items: () -> [TabItem]) {
        self.items = items()
        
        self._selectedIndex = .init(initialValue: (startIndex < self.items.count && startIndex >= 0 ? startIndex : 0))
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                items[selectedIndex - 1 < 0 ? items.count - 1 : selectedIndex - 1]
                    .offset(x: -UIScreen.main.bounds.width + dragOffset)
                
                items[selectedIndex].content
                    .offset(x: dragOffset)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                if value.startLocation.x > UIScreen.main.bounds.width - 50 || value.startLocation.x < 50 {
                                    state = value.translation.width
                                }
                            }
                            .onEnded { value in
                                guard value.startLocation.x > UIScreen.main.bounds.width - 50 ||
                                        value.startLocation.x < 50 else { return }
                                
                                if value.translation.width > 50 {
                                    changeIndex(to: selectedIndex == 0 ? items.count - 1 : selectedIndex - 1)
                                } else if value.translation.width < -50 {
                                    changeIndex(to: selectedIndex == items.count - 1 ? 0 : selectedIndex + 1)
                                }
                            }
                    )
                
                items[selectedIndex + 1 >= items.count ? 0 : selectedIndex + 1]
                    .offset(x: UIScreen.main.bounds.width + dragOffset)
            }

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
                .spacing()
            }
            .frame(height: Self.height)
        }
    }
    
    // MARK: - Private Functions
    
    private func changeIndex(to index: Int) {
        guard index >= 0, index < items.count else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 1)) {
            self.selectedIndex = index
        }
        
        feedbackGenerator.impactOccurred()
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
    
    // MARK: - Static Variables
    
    static var height = UIScreen.main.bounds.height / 12
}

// MARK: - TabBar: PreferenceKey

struct TabBarPreferenceKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
        
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
    
}

// MARK: - TabBar: TabBuilder

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
        .environmentObject(SettingsController.shared)
        .environmentObject(FeedbackGenerator.init(feedbackEnabled: false))
    }
}
