//
//  MusicPlayer.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/24/20.
//
//  Purpose:
//  Resizable view that plays and controls music.
//

import SwiftUI

struct MusicPlayer: View {
    
    // MARK: - State
    
    @ObservedObject var musicController: MusicController
    @EnvironmentObject var settingsController: SettingsController
    
    // MARK: - Variables
    
    let impact = UIImpactFeedbackGenerator()
    
    // MARK: Initializers
    
    init(musicController: MusicController) {
        self.musicController = musicController
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
            
            VStack {
                NavBar(gradient: settingsController.colorScheme.backgroundGradient.colors, back: {
                    // TODO: - Dismiss view
                    impact.impactOccurred()
                }, list: {
                    // TODO: - Toggle up next
                    impact.impactOccurred()
                })
                
                Spacer()
                
                MusicArtwork(gradient: settingsController.colorScheme.backgroundGradient.colors, image: musicController.currentSong.artwork)
                
                Spacer()
                   
                
                Text(musicController.currentSong.title)
                    .font(.title)
                    .foregroundColor(.white)
                
                Text(musicController.currentSong.artist)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                MusicSlider(musicController: musicController, topGradientColor: settingsController.colorScheme.backgroundGradient.color1.color)
                    .padding(.bottom)
                
                MusicControlButtons(isPlaying: musicController.isPlaying, colorScheme: settingsController.colorScheme, back: {
                    musicController.skipToPreviousItem()
                    impact.impactOccurred()
                }, play: {
                    musicController.toggle()
                    impact.impactOccurred()
                }, forward: {
                    musicController.skipToNextItem()
                    impact.impactOccurred()
                })
            }
            .padding(Constants.spacing)
        }
    }
}

// MARK: - Components

struct NavBar: View { // Navigation
    let gradient: [Color]
    let back: () -> Void
    let list: () -> Void
    
    var body: some View {
        HStack {
            DefaultButton(imageName: "arrow.left", gradientColors: gradient, action: back)
            
            Text("Now Playing")
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
            
            DefaultButton(imageName: "line.horizontal.3", gradientColors: gradient, action: list)
        }
    }
}

struct MusicControlButtons: View { // Control music
    let isPlaying: Bool
    let colorScheme: ColorScheme
    let back: () -> Void
    let play: () -> Void
    let forward: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            DefaultButton(imageName: "backward.fill", gradientColors: colorScheme.backgroundGradient.colors, mult: 1.1, action: back)
            
            Spacer()
            
            DefaultButton(imageName: isPlaying ? "pause.fill" : "play.fill", gradientColors: isPlaying ? colorScheme.playGradient.colors : colorScheme.pauseGradient.colors, mult: 1.25, action: play)
            
            Spacer()
            
            DefaultButton(imageName: "forward.fill", gradientColors: colorScheme.backgroundGradient.colors, mult: 1.1, action: forward)
            
            Spacer()
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayer(musicController: MusicController()).environmentObject(SettingsController())
    }
}
