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

struct TabBar<Content>: View where Content: View {
    @EnvironmentObject private var settingsController: SettingsController
    @State private var selectedIndex: Int = 0 {
        didSet {
            impact.impactOccurred()
        }
    }
    
    private let impact: UIImpactFeedbackGenerator
    private let items: [TabItem<Content>]
    
    init(impact: UIImpactFeedbackGenerator = .init(), @TabBuilder<TabItem<Content>> content: () -> [TabItem<Content>]) {
        self.items = content()
        self.impact = impact
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            items[selectedIndex].content()

            Spacer()
            
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
            .background(settingsController.colorScheme.backgroundGradient.color2.color)
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func item(at index: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 1)) {
                self.selectedIndex = index
            }
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
        GeometryReader { proxy in
            if bounds != nil {
                Rectangle()
                    .fill(settingsController.colorScheme.mainButtonColor.color)
                    .frame(width: proxy[bounds!].width, height: 3)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .offset(x: proxy[bounds!].minX, y: 6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
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
public struct TabBuilder<Content> where Content: View {
    public static func buildBlock(_ children: Content...) -> [Content] {
        children
    }
}

// MARK: - Preview

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar {
            TabItem(title: "Play", imageName: "play.fill") {
                Text("Playing")
            }
            
            TabItem(title: "Pause", imageName: "pause.fill") {
                Text("Paused")
            }
        }
        .environmentObject(SettingsController())
    }
}
