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
        ZStack(alignment: .bottom) {
            // Background
            LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.top)
            
            let back = {
                musicController.skipToPreviousItem()
                feedback.warningFeedback()
            }
            
            let pause = {
                musicController.toggle()
                feedback.warningFeedback()
            }
            
            let forward = {
                musicController.skipToNextItem()
                feedback.warningFeedback()
            }
            
            if isOpen {
                VStack {
                    navBar
                    
                    Spacer()
                    
                    MusicArtwork(colorScheme: settingsController.colorScheme, image: musicController.currentSong.artwork)
                        .padding(.horizontal)
                    
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
                    
                    MusicControlButtons(isPlaying: musicController.isPlaying, isOpen: isOpen, background: settingsController.colorScheme.backgroundGradient.last, text: settingsController.colorScheme.textColor.color, back: back, pause: pause, forward: forward)
                    
                    Spacer()
                }
                .padding(Constants.spacing)
            } else {
                HStack {
                    MusicArtwork(colorScheme: settingsController.colorScheme, image: musicController.currentSong.artwork, size: .button)
                        .frame(width: 80, height: 80)
                        .padding(.all, 10)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(musicController.currentSong.title)
                                .lineLimit(1)
                                .font(.footnote)
                                .foregroundColor(settingsController.colorScheme.textColor.color)
                            if musicController.currentSong.isExplicit {
                                Image(systemName: "e.square.fill")
                                    .foregroundColor(settingsController.colorScheme.textColor.color)
                            }
                        }
                    
                        Text(musicController.currentSong.artist)
                            .lineLimit(1)
                            .font(.caption)
                            .foregroundColor(settingsController.colorScheme.textColor.color)
                    }
                    
                    Spacer()
                    
                    let background = settingsController.colorScheme.backgroundGradient.first.average(to: settingsController.colorScheme.backgroundGradient.last)
                    
                    MusicControlButtons(isPlaying: musicController.isPlaying, isOpen: isOpen, background: background, text: settingsController.colorScheme.textColor.color, back: back, pause: pause, forward: forward)
                        .padding(.horizontal, 10)
                }
            }
        }
        .modifier(IsSmall(isOpen: isOpen))
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
}

struct MusicControlButtons: View {
    var backAction: () -> Void
    var pauseAction: () -> Void
    var forwardAction: () -> Void
    
    var isPlaying: Bool
    var isOpen: Bool
    var backgroundColor: Color
    var textColor: Color
    var mult: CGFloat
    
    init(isPlaying: Bool, isOpen: Bool, background: Color, text: Color, back: @escaping () -> Void, pause: @escaping () -> Void, forward: @escaping () -> Void) {
        self.backAction = back
        self.pauseAction = pause
        self.forwardAction = forward
        
        self.isPlaying = isPlaying
        self.isOpen = isOpen
        self.backgroundColor = background
        self.textColor = text
        self.mult = isOpen ? 1 : 0.4
        
    }
    
    var body: some View {
        HStack {
            if isOpen {
                Spacer()
            }
            
            DefaultButton(imageName: "backward.fill", imageColor: textColor, buttonColor: backgroundColor, neoSize: .tinyButton, mult: 1.1 * mult, action: backAction)
            if isOpen {
                Spacer()
            }
            
            DefaultButton(imageName: isPlaying ? "pause.fill" : "play.fill", imageColor: textColor, buttonColor: backgroundColor, neoSize: .tinyButton, mult: 1.25 * mult, isSelected: isPlaying, action: pauseAction)
            
            if isOpen {
                Spacer()
            }
            
            DefaultButton(imageName: "forward.fill", imageColor: textColor, buttonColor: backgroundColor, neoSize: .tinyButton, mult: 1.1 * mult, action: forwardAction)
            
            if isOpen {
                Spacer()
            }
        }
    }
}

private struct IsSmall: ViewModifier {
    let isOpen: Bool
    
    func body(content: Content) -> some View {
        if isOpen {
            return content.asAny()
        } else {
            return
                content
                .frame(height: 100)
                .asAny()
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlayer(isOpen: Binding<Bool>(get: { return false }, set: { _ in }))
            .environmentObject(SettingsController())
            .environmentObject(MusicPlayerController())
    }
}
