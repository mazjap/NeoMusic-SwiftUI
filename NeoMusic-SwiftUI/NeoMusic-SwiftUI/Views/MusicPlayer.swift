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
    
    let impact: UIImpactFeedbackGenerator
    
    // MARK: Initializers
    
    init(musicController: MusicController, impact: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator()) {
        self.musicController = musicController
        self.impact = impact
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.top)
            
            VStack {
                NavBar(colorScheme: settingsController.colorScheme, isPlaying: musicController.isPlaying, back: {
                    // TODO: - Dismiss view
                    impact.impactOccurred()
                }, list: {
                    // TODO: - Toggle up next
                    impact.impactOccurred()
                })
                
                Spacer()
                
                MusicArtwork(colorScheme: settingsController.colorScheme, image: musicController.currentSong.artwork, impact: impact)
                   
                HStack {
                    Text(musicController.currentSong.title)
                        .lineLimit(1)
                        .font(.title)
                        .foregroundColor(settingsController.colorScheme.textColor.color)
                    if musicController.currentSong.isExplicit {
                        Image(systemName: "e.square.fill")
                            .foregroundColor(settingsController.colorScheme.textColor.color)
                    }
                }
                
                Text(musicController.currentSong.artist)
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundColor(settingsController.colorScheme.textColor.color)
                
                MusicSlider(musicController: musicController, impact: impact, colorScheme: settingsController.colorScheme)
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
    let colorScheme: ColorScheme
    let isPlaying: Bool
    let back: () -> Void
    let list: () -> Void
    
    var body: some View {
        HStack {
            DefaultButton(imageName: "arrow.left", gradient: colorScheme.backgroundGradient.colors, buttonColor: colorScheme.secondaryButtonColor.color, action: back)
            
            Spacer()
            
            Text(isPlaying ? "Now Playing" : "Paused")
                .foregroundColor(colorScheme.textColor.color)
            
            Spacer()
            
            DefaultButton(imageName: "line.horizontal.3", gradient: colorScheme.backgroundGradient.colors, buttonColor: colorScheme.secondaryButtonColor.color, action: list)
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
            
            DefaultButton(imageName: "backward.fill", gradient: colorScheme.backgroundGradient.colors, buttonColor: colorScheme.mainButtonColor.color, mult: 1.1, action: back)
            
            Spacer()
            
            DefaultButton(imageName: isPlaying ? "pause.fill" : "play.fill", gradient: isPlaying ? colorScheme.playGradient.colors : colorScheme.pauseGradient.colors, buttonColor: colorScheme.mainButtonColor.color, mult: 1.25, action: play)
            
            Spacer()
            
            DefaultButton(imageName: "forward.fill", gradient: colorScheme.backgroundGradient.colors, buttonColor: colorScheme.mainButtonColor.color, mult: 1.1, action: forward)
            
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
