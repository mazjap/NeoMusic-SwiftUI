//
//  SegmentedControl.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/17/20.
//

import SwiftUI

struct SegmentedControl: View {
    
    // MARK: - State
    
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    
    @Environment(\.options) var options: [String]
    
    @Binding var selectedIndex: Int
    
    @Namespace private var nspace
    
    // MARK: - Variable
    
    private var textColor: Color
    private var gradient: Gradient
    
    init(index: Binding<Int>, textColor: Color, background: Color) {
        self._selectedIndex = index
        self.textColor = textColor
        self.gradient = background.offsetGradient
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
            HStack {
                Spacer()
                ForEach(0..<options.count) { i in
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: gradient, startPoint: .bottom, endPoint: .top))
                            .opacity(selectedIndex == i ? 1 : 0)
                            .matchedGeometryEffect(id: Self.selectedID, in: nspace, isSource: i == selectedIndex)
                        
                        Button(options[i]) {
                            changeIndex(to: i)
                        }
                    }
                    .frame(height: Self.height - 10)
                    .foregroundColor(textColor)
                    
                    Spacer()
                }
            }
        }
        .frame(height: Self.height)
    }
    
    private func changeIndex(to index: Int) {
        guard index >= 0, index < options.count else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 1)) {
            self.selectedIndex = index
        }
        
        feedbackGenerator.impactOccurred()
    }
    
    // MARK: - Static Variables
    
    static let height: CGFloat = 50
    static private let selectedID = "SegmentedControl.selectedRectangle"
}



struct SegmentedControl_Previews: PreviewProvider {
    @State static var index: Int = 0
    @State static var index2: Int = 0
    
    static var previews: some View {
        VStack {
            SegmentedControl(index: $index, textColor: .white, background: SettingsController.shared.colorScheme.backgroundGradient.first)
                .options(["T", "e", "s", "t"])
            
            SegmentedControl(index: $index2, textColor: .white, background: SettingsController.shared.colorScheme.backgroundGradient.first)
            
            
        }
        .spacing()
        .environmentObject(FeedbackGenerator())
    }
}

struct SegmentedPreferenceKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
        
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
    
}

extension SegmentedControl {
    func options(_ list: [String]) -> some View {
        self
            .environment(\.options, list)
    }
}

private struct SegmentedOptions: EnvironmentKey {
    static let defaultValue: [String] = ["Option 1", "Option 2"]
}

extension EnvironmentValues {
    var options: [String] {
        get { self[SegmentedOptions.self] }
        set { self[SegmentedOptions.self] = newValue }
    }
}
