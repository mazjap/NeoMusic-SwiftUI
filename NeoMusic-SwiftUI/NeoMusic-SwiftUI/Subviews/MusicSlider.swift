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
    @ObservedObject var musicController: MusicController
    @EnvironmentObject var settingsController: SettingsController
    @State var currentTime: Double = 0
    @State var totalTime: Double = 0
    @State var dragAmount: Double = 0
    
    let timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
    
    init(musicController: MusicController) {
        self.musicController = musicController
    }
    
    var body: some View {
        let size = UIScreen.main.bounds.size.width - Constants.spacing * 2
        
        let progress: CGFloat = musicController.currentPlaybackTime / musicController.totalPlaybackTime > 0 && musicController.currentPlaybackTime != musicController.totalPlaybackTime ? CGFloat(musicController.currentPlaybackTime) / CGFloat(musicController.totalPlaybackTime) : 0
        
        let completedWidth = progress * size
        
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
            .frame(width: size)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: lineHeight / 2)
                    .fill(LinearGradient(gradient: Gradient(colors: [settingsController.colorScheme.backgroundGradient.color1.color, .black]), startPoint: .bottom, endPoint: .top))
                    .frame(height: lineHeight)
                
                RoundedRectangle(cornerRadius: (lineHeight - 2) / 2)
                    .fill(LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.pauseGradient.colors), startPoint: .bottom, endPoint: .top))
                    .frame(width: Double(completedWidth).isFinite ? completedWidth : 0, height: lineHeight - 2)
                
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: size / 12, height: size / 12)
                    .offset(x: CGFloat(progress) * (size - size / 24) - size / 48, y: 0)
            }
        }
    }
    
    func format(_ num: Double) -> String {
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

struct MusicSlider_Previews: PreviewProvider {
    static var previews: some View {
        MusicSlider(musicController: MusicController())
            .environmentObject(SettingsController())
    }
}
