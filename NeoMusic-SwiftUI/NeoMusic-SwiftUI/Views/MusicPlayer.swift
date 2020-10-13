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
    
    @EnvironmentObject private var musicController: MusicPlayerController
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var feedback: FeedbackGenerator
    
    @Binding var isOpen: Bool
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.top)
            
            VStack {
                navBar
                
                Spacer()
                
                MusicArtwork(colorScheme: settingsController.colorScheme, image: musicController.currentSong.artwork)
                   
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
                
                MusicSlider(colorScheme: settingsController.colorScheme)
                
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
                feedback.impactOccurred()
            }
            
            Spacer()
            
            Text(musicController.isPlaying ? "Now Playing" : "Paused")
                .foregroundColor(settingsController.colorScheme.textColor.color)
            
            Spacer()
            
            DefaultButton(imageName: "line.horizontal.3", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.first) {
                // TODO: - Toggle up next
                feedback.impactOccurred()
            }
        }
    }
    
    var musicControlButtons: some View {
        HStack {
            Spacer()
            
            DefaultButton(imageName: "backward.fill", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, mult: 1.1) {
                musicController.skipToPreviousItem()
                feedback.warningFeedback()
            }
            
            Spacer()
            
            DefaultButton(imageName: musicController.isPlaying ? "pause.fill" : "play.fill", imageColor: (musicController.isPlaying ? settingsController.colorScheme.mainButtonColor : settingsController.colorScheme.secondaryButtonColor).color, buttonColor: settingsController.colorScheme.backgroundGradient.last, mult: 1.25, isSelected: musicController.isPlaying) {
                musicController.toggle()
                feedback.warningFeedback()
            }
            
            Spacer()
            
            DefaultButton(imageName: "forward.fill", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, mult: 1.1) {
                musicController.skipToNextItem()
                feedback.warningFeedback()
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayer(isOpen: Binding<Bool>(get: { return true }, set: { _ in }))
            .environmentObject(SettingsController())
            .environmentObject(MusicPlayerController())
    }
}
