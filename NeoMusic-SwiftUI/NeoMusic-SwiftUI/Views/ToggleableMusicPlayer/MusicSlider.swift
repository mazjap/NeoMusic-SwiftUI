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
    
    @EnvironmentObject private var musicController: MusicPlayerController
    @State var currentTime: Double = 0
    @State var totalTime: Double = 0
    
    @State var isSeeking: Bool = false
    @GestureState var dragOffset: CGFloat = 0
    @State var position: CGSize = .zero
    @State var sideToPop: Side = .none
    
    // MARK: - Variables
    
    let lineHeight: CGFloat = 5
    let sliderSize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 14
    let impact: UIImpactFeedbackGenerator
    let colorScheme: JCColorScheme
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    init(colorScheme: JCColorScheme, impact: UIImpactFeedbackGenerator = .init()) {
        self.colorScheme = colorScheme
        self.impact = impact
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            HStack {
                Text(format(currentTime))
                    .font(.subheadline)
                    .foregroundColor(colorScheme.textColor.color)
                    .padding(.leading, sliderSize / 2)
                    .offset(y: sideToPop == .left ? -10 : 0)
                
                Spacer()
                
                Text(format(totalTime))
                    .font(.subheadline)
                    .foregroundColor(colorScheme.textColor.color)
                    .padding(.trailing, sliderSize / 2)
                    .offset(y: sideToPop == .right ? -10 : 0)
            }
            .onReceive(timer) { _ in
                if musicController.currentPlaybackTime == musicController.totalPlaybackTime {
                    currentTime = 0
                    totalTime = 0.01
                } else {
                    currentTime = musicController.currentPlaybackTime
                    totalTime = musicController.totalPlaybackTime
                }
            }
            
            GeometryReader { geometry in
                let totalDistance = geometry.size.width - sliderSize
                let songCompletion = CGFloat(musicController.currentPlaybackTime / musicController.totalPlaybackTime)
                
                let songOffset = songCompletion * totalDistance
                
                let x = dragOffset + songOffset
                let verifiedDistance = max(min(totalDistance, x), 0)
                let songDuration = Double(verifiedDistance / totalDistance) * musicController.totalPlaybackTime
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: lineHeight / 2)
                        .fill(LinearGradient(gradient: colorScheme.backgroundGradient.gradient.reversed, startPoint: .top, endPoint: .bottom))
                        .frame(height: lineHeight)
                        .padding(.horizontal, sliderSize / 2)
                    
                    RoundedRectangle(cornerRadius: (lineHeight - 2) / 2)
                        .fill(LinearGradient(gradient: colorScheme.sliderGradient.gradient, startPoint: .top, endPoint: .bottom))
                        .animation(.linear)
                        .frame(width: verifiedDistance, height: lineHeight - 2)
                        .padding(.horizontal, sliderSize / 2)
                    
                    Circle()
                        .fill(LinearGradient(gradient: colorScheme.backgroundGradient.gradient.reversed, startPoint: .bottomTrailing, endPoint: .topLeading))
                        .overlay(
                        Circle()
                            .fill(LinearGradient(gradient: colorScheme.backgroundGradient.gradient, startPoint: .bottomTrailing, endPoint: .topLeading))
                            .frame(width: sliderSize * 0.95, height: sliderSize * 0.95)
                        )
                        .animation(.linear)
                        .offset(x: verifiedDistance, y: 0)
                        .frame(width: sliderSize, height: sliderSize)
                        .gesture(
                            DragGesture()
                                .updating($dragOffset) { value, state, _ in
                                    state = value.translation.width
                                }
                                .onChanged { _ in
                                    if !isSeeking {
                                        impact.impactOccurred(intensity: 0.35)
                                        
                                        withAnimation {
                                            isSeeking = true
                                        }
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
                                    musicController.set(time: songDuration)
                                    
                                    withAnimation {
                                        sideToPop = .none
                                        isSeeking = false
                                    }
                                }
                        )
                    
                    Text(format(songDuration))
                        .foregroundColor(colorScheme.textColor.color)
                        .font(.caption)
                        .offset(x: verifiedDistance, y: -sliderSize / 2 - 10)
                        .animation(.linear)
                        .opacity(isSeeking ? 1 : 0)
                }
            }
            
        }
        .frame(height: 75)
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
    static var previews: some View {
        ZStack {
            LinearGradient(gradient: JCColorScheme.default.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            MusicSlider(colorScheme: Constants.defaultColorScheme)
                .environmentObject(MusicPlayerController())
        }
    }
}
