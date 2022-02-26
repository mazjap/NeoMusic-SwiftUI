//
//  MusicSlider.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Custom slider that displays and changes current playing duration
//

import SwiftUI

struct MusicSlider: View {
    
    // MARK: - State
    
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    @Environment(\.isEnabled) var isEnabled: Bool
    
    @GestureState private var dragOffset: CGFloat = 0
    
    @Binding private var minimum: Double
    @Binding private var maximum: Double
    @Binding private var current: Double
    
    @State private var isSeeking: Bool = false
    @State private var tempSeekingDuration: CGFloat = 0
    @State private var sideToPop: Side = .none
    
    // MARK: - Variables
    
    let action: (Double) -> Void
    
    let lineHeight: CGFloat = 6.5
    let sliderSize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 14
    let colorScheme: JCColorScheme
    
    init(colorScheme: JCColorScheme, min: Binding<Double> = Binding<Double>(get: { return 0 }, set: { _ in }), max: Binding<Double> = Binding<Double>(get: { return 1 }, set: { _ in }), current: Binding<Double> = Binding<Double>(get: { return 0.5 }, set: { _ in }), onChange action: @escaping (Double) -> Void) {
        self.colorScheme = colorScheme
        self._minimum = min
        self._maximum = max
        self._current = current
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        let font: Font = .subheadline
        
        VStack {
            if isEnabled {
                HStack {
                    Text(format(current))
                        .font(font)
                        .foregroundColor(colorScheme.textColor.color)
                        .padding(.leading, sliderSize / 2)
                        .offset(y: sideToPop == .left ? -10 : 0)
                    
                    Spacer()
                    
                    Text(format(maximum))
                        .font(font)
                        .foregroundColor(colorScheme.textColor.color)
                        .padding(.trailing, sliderSize / 2)
                        .offset(y: sideToPop == .right ? -10 : 0)
                }
            }
            
            GeometryReader { geometry in
                let totalDistance = geometry.size.width - sliderSize
                let songCompletion = CGFloat(current / maximum)
                
                let songOffset = songCompletion * totalDistance
                
                let x = dragOffset + (isSeeking ? tempSeekingDuration : songOffset)
                let verifiedDistance = max(min(totalDistance, x), 0)
                let songDuration = Double(verifiedDistance / totalDistance) * maximum
                
                ZStack(alignment: .leading) {
                    LinearGradient(gradient: colorScheme.backgroundGradient.last.offsetGradient, startPoint: .top, endPoint: .bottom)
                        .frame(height: lineHeight)
                        .cornerRadius(lineHeight / 2)
                        .padding(.horizontal, sliderSize / 2)
                    
                    LinearGradient(gradient: colorScheme.sliderGradient.gradient, startPoint: .bottom, endPoint: .top)
                        .frame(width: verifiedDistance, height: lineHeight - 2)
                        .cornerRadius((lineHeight - 2) / 2)
                        .padding(.horizontal, sliderSize / 2)
                    
                    Circle()
                        .fill(LinearGradient(gradient: colorScheme.backgroundGradient.gradient.reversed, startPoint: .bottomTrailing, endPoint: .topLeading))
                        .overlay(
                        Circle()
                            .fill(LinearGradient(gradient: colorScheme.backgroundGradient.last.offsetGradient.reversed, startPoint: .bottomTrailing, endPoint: .topLeading))
                            .frame(width: sliderSize * 0.95, height: sliderSize * 0.95)
                        )
                        .offset(x: verifiedDistance, y: 0)
                        .frame(width: sliderSize, height: sliderSize)
                        .gesture(
                            DragGesture()
                                .updating($dragOffset) { value, state, _ in
                                    state = value.translation.width
                                }
                                .onChanged { _ in
                                    if !isSeeking {
                                        feedbackGenerator.impactOccurred(intensity: 0.35)
                                        
                                        isSeeking = true
                                        
                                        tempSeekingDuration = songOffset
                                    }
                                    
                                    withAnimation {
                                        if verifiedDistance > totalDistance - 45 {
                                            sideToPop = .right
                                        } else if verifiedDistance < 45 {
                                            sideToPop = .left
                                        } else {
                                            sideToPop = .none
                                        }
                                    }
                                }
                                .onEnded { value in
                                    action(songDuration)
                                    feedbackGenerator.impactOccurred(intensity: abs(x - tempSeekingDuration) / totalDistance)
                                    
                                    sideToPop = .none
                                    isSeeking = false
                                    
                                }
                        )
                    
                    if isEnabled {
                    Text(format(songDuration))
                        .foregroundColor(colorScheme.textColor.color)
                        .font(.caption)
                        .offset(x: verifiedDistance, y: -sliderSize / 2 - 10)
                        .opacity(isSeeking ? 1 : 0)
                    }
                }
            }
            
        }
        .frame(height: sliderSize + (isEnabled ? font.size : 0))
    }
    
    // MARK: - Functions
    
    private func format(_ num: Double) -> String {
        let hours = Int(num) / 3600
        let minutes = (Int(num) / 60) % 60
        let seconds = Int(num) % 60
        
        let h = String(hours)
        var m = String(minutes)
        let s = "\(String(seconds).count == 1 ? "0" : "")\(seconds)"
        
        
        if hours != 0 {
            if String(minutes).count == 1 {
                m = "0\(m)"
            }
            return "\(h):\(m):\(s)"
        } else if minutes != 0 {
            return "\(m):\(s)"
        } else {
            return "0:\(s)"
        }
    }
}

// MARK: - Extension: MusicSlider.Side

extension MusicSlider {
    enum Side {
        case left, right, none
    }
}

// MARK: - Preview

struct MusicSlider_Previews: PreviewProvider {
    @State static var zero: Double = 0
    @State static var two: Double = 2
    @State static var five: Double = 5
    
    static var previews: some View {
        ZStack {
            LinearGradient(gradient: JCColorScheme.default.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            
            MusicSlider(colorScheme: Constants.defaultColorScheme, min: $zero, max: $five, current: $two, onChange: {_ in})
                .environment(\.isEnabled, false)
                .environmentObject(FeedbackGenerator(feedbackEnabled: false))
        }
        .previewLayout(.fixed(width: 400, height: 100))
    }
}
