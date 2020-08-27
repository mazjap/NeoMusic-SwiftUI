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
    @State var currentTime: Double = 0
    
    let timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
    
    let total: Double
    let topGradColor: Color
    
    init(musicController: MusicController, topGradientColor: Color) {
        self.musicController = musicController
        self.total = musicController.totalPlaybackTime
        self.topGradColor = topGradientColor
        
        
    }
    
    var body: some View {
        let progress = musicController.currentPlaybackTime / musicController.totalPlaybackTime
        
        VStack {
            HStack {
                Text(format(currentTime))
                    .onReceive(timer) { _ in
                        DispatchQueue.main.async {
                            currentTime = musicController.currentPlaybackTime
                        }
                    }
                
                Spacer()
                
                Text(format(total))
            }
            .foregroundColor(.gray)
            .font(Font.system(.caption))
            
            RoundedRectangle(cornerRadius: 3)
                .fill(LinearGradient(gradient: Gradient(colors: [topGradColor, .black]), startPoint: .bottom, endPoint: .top))
                .frame(height: 6)
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
        MusicSlider(musicController: MusicController(), topGradientColor: Color(red: 0.8, green: 0.8, blue: 0.8))
    }
}
