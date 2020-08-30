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
    
    @ObservedObject var musicController: MusicController
    @State var currentTime: Double = 0
    @State var totalTime: Double = 0
    @State var isDragging = false
    @State var dragOffset: CGFloat = 0
    
    // MARK: - Variables
    
    let impact: UIImpactFeedbackGenerator
    let colorScheme: ColorScheme
    let timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
    
    // MARK: - Body
    
    var body: some View {
        let lineHeight: CGFloat = 6
        
        VStack {
            HStack {
                Text(format(currentTime))
                    .onReceive(timer) { _ in
                        DispatchQueue.main.async {
                            if musicController.currentPlaybackTime == musicController.totalPlaybackTime {
                                currentTime = 0
                            } else {
                                currentTime = musicController.currentPlaybackTime
                            }
                        }
                    }
                
                Spacer()
                
                Text(format(totalTime))
                    .onReceive(timer) { _ in
                        totalTime = musicController.totalPlaybackTime
                    }
            }
            .foregroundColor(.gray)
            .font(Font.system(.caption))
                
            GeometryReader { geometry in
                let progress: CGFloat = musicController.currentPlaybackTime / musicController.totalPlaybackTime > 0 && musicController.currentPlaybackTime != musicController.totalPlaybackTime ? CGFloat(musicController.currentPlaybackTime) / CGFloat(musicController.totalPlaybackTime) : 0
                
                let completedWidth = progress * geometry.size.width
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: lineHeight / 2)
                        .fill(LinearGradient(gradient: Gradient(colors: [colorScheme.backgroundGradient.color1.color, .black]), startPoint: .bottom, endPoint: .top))
                        .frame(height: lineHeight)
                    
                    RoundedRectangle(cornerRadius: (lineHeight - 2) / 2)
                        .fill(LinearGradient(gradient: Gradient(colors: colorScheme.pauseGradient.colors), startPoint: .bottom, endPoint: .top))
                        .frame(width: Double(completedWidth + dragOffset).isFinite ? completedWidth + dragOffset : 0, height: lineHeight - 2)
                    
                    let sliderSize = geometry.size.width / 12
                    
                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: colorScheme.backgroundGradient.colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                        
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: colorScheme.backgroundGradient.colors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: sliderSize * 0.95, height: sliderSize * 0.95)
                    }
                    .frame(width: sliderSize, height: sliderSize)
                    .offset(x: CGFloat(progress) * (geometry.size.width - geometry.size.width / 24) - geometry.size.width / 48 + dragOffset, y: 0)
                    .gesture(DragGesture()
                        .onChanged { value in
                            let dragProgress = CGFloat(currentTime / totalTime) * geometry.size.width + value.translation.width
                            print(dragProgress)
                            
                            if !isDragging {
                                impact.impactOccurred(intensity: 0.35)
                                isDragging = true
                            }
                            
                            if dragProgress <= geometry.size.width && dragProgress >= 0 {
                                dragOffset = value.translation.width
                            }
                        }
                        .onEnded { value in
                            isDragging = false
                            let val = dragOffset / geometry.size.width
                            let time = musicController.currentPlaybackTime + Double(val) * musicController.totalPlaybackTime
                            
                            impact.impactOccurred(intensity: abs(val))
                            
                            musicController.set(time: time)
                            dragOffset = 0
                        }
                    )
                }
            }
        }
        .frame(height: 40)
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

// MARK: - Preview

struct MusicSlider_Previews: PreviewProvider {
    static var previews: some View {
        MusicSlider(musicController: MusicController(), impact: UIImpactFeedbackGenerator(), colorScheme: Constants.defaultColorScheme)
    }
}
