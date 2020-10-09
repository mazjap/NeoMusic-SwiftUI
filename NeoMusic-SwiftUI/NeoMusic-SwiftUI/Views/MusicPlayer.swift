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
    
    @ObservedObject var musicController: MusicPlayerController
    @EnvironmentObject var settingsController: SettingsController
    
    // MARK: - Variables
    
    let impact: UIImpactFeedbackGenerator
    
    // MARK: Initializers
    
    init(musicController: MusicPlayerController, impact: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator()) {
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
                navBar
                
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
                
                musicControlButtons
            }
            .padding(Constants.spacing)
        }
    }
    
    // MARK: - Components
    
    var navBar: some View {
        HStack {
            DefaultButton(imageName: "arrow.left", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.first) {
                // TODO: - Dismiss view
                impact.impactOccurred()
            }
            
            Spacer()
            
            Text(musicController.isPlaying ? "Now Playing" : "Paused")
                .foregroundColor(settingsController.colorScheme.textColor.color)
            
            Spacer()
            
            DefaultButton(imageName: "line.horizontal.3", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.first) {
                // TODO: - Toggle up next
                impact.impactOccurred()
            }
        }
    }
    
    var musicControlButtons: some View {
        HStack {
            Spacer()
            
            DefaultButton(imageName: "backward.fill", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, mult: 1.1) {
                musicController.skipToPreviousItem()
                impact.impactOccurred()
            }
            
            Spacer()
            
            DefaultButton(imageName: musicController.isPlaying ? "pause.fill" : "play.fill", imageColor: (musicController.isPlaying ? settingsController.colorScheme.mainButtonColor : settingsController.colorScheme.secondaryButtonColor).color, buttonColor: settingsController.colorScheme.backgroundGradient.last, mult: 1.25, isSelected: musicController.isPlaying) {
                musicController.toggle()
                impact.impactOccurred()
            }
            
            Spacer()
            
            DefaultButton(imageName: "forward.fill", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, mult: 1.1) {
                musicController.skipToNextItem()
                impact.impactOccurred()
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayer(musicController: MusicPlayerController()).environmentObject(SettingsController())
    }
}
