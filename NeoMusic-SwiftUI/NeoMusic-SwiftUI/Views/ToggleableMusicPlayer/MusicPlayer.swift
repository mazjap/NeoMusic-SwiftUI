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
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    
    @State var rotation: Double = 0
    @Binding var isOpen: Bool
    @Namespace var nspace
    
    // MARK: - Body
    
    var body: some View {
        ZStack { () -> AnyView in
            if isOpen {
                return OpenMusicPlayer(isOpen: $isOpen, rotation: $rotation, nspace: nspace).asAny()
            } else {
                return ClosedMusicPlayer(isOpen: $isOpen, rotation: $rotation, nspace: nspace).asAny()
            }
        }
        .onTapGesture(count: 1) {
            withAnimation(.easeInOut) {
                isOpen.toggle()
            }
        }
    }
    
    static let base = "MusicPlayer."
    
    static let  backgroundKey = base + "Background"
    static let     artworkKey = base + "Artwork"
    static let   songTitleKey = base + "SongTitle"
    static let  songArtistKey = base + "SongArtist"
    static let  backButtonKey = base + "BackButton"
    static let pauseButtonKey = base + "PauseButton"
    static let  skipButtonKey = base + "SkipButton"
}

struct OpenMusicPlayer: View {
    @EnvironmentObject var settingsController: SettingsController
    @EnvironmentObject var musicController: MusicPlayerController
    @EnvironmentObject var feedbackGenerator: FeedbackGenerator
    
    @Binding var isOpen: Bool
    @Binding var rotation: Double
    
    var nspace: Namespace.ID
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.top)
                .matchedGeometryEffect(id: MusicPlayer.backgroundKey, in: nspace, properties: .frame, isSource: !isOpen)
            
            VStack {
                // Navigation Bar
                HStack {
                    DefaultButton(imageName: "arrow.left", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.first) {
                        isOpen = false
                        feedbackGenerator.impactOccurred()
                    }
                    
                    Spacer()
                    
                    Text(musicController.isPlaying ? "Now Playing" : "Paused")
                        .foregroundColor(settingsController.colorScheme.textColor.color)
                    
                    Spacer()
                    
                    DefaultButton(imageName: "line.horizontal.3", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.first) {
                        // TODO: - Toggle up next
                        feedbackGenerator.impactOccurred()
                    }
                }
                
                Spacer()
                
                MusicArtwork(colorScheme: settingsController.colorScheme, image: musicController.currentSong.artwork, rotation: $rotation)
                    .padding(.horizontal)
                    .matchedGeometryEffect(id: MusicPlayer.artworkKey, in: nspace, isSource: !isOpen)
                
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
                .matchedGeometryEffect(id: MusicPlayer.songTitleKey, in: nspace, properties: .frame, isSource: !isOpen)
                
                Text(musicController.currentSong.artist)
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundColor(settingsController.colorScheme.textColor.color)
                    .matchedGeometryEffect(id: MusicPlayer.songArtistKey, in: nspace, properties: .frame, isSource: !isOpen)
                
                MusicSlider(colorScheme: settingsController.colorScheme)
                
                HStack {
                    Spacer()
                    
                    DefaultButton(imageName: "backward.fill", imageColor: settingsController.colorScheme.textColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, neoSize: .tinyButton, mult: 1.1) {
                        musicController.skipToPreviousItem()
                        feedbackGenerator.warningFeedback()
                    }
                    .matchedGeometryEffect(id: MusicPlayer.backButtonKey, in: nspace, properties: .frame, isSource: !isOpen)
                        
                    Spacer()
                    
                    DefaultButton(imageName: musicController.isPlaying ? "pause.fill" : "play.fill", imageColor: settingsController.colorScheme.textColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, neoSize: .tinyButton, mult: 1.25, isSelected: musicController.isPlaying) {
                        musicController.toggle()
                        feedbackGenerator.warningFeedback()
                    }
                    .matchedGeometryEffect(id: MusicPlayer.pauseButtonKey, in: nspace, properties: .frame, isSource: !isOpen)
                    
                    Spacer()
                    
                    DefaultButton(imageName: "forward.fill", imageColor: settingsController.colorScheme.textColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, neoSize: .tinyButton, mult: 1.1) {
                        musicController.skipToNextItem()
                        feedbackGenerator.warningFeedback()
                    }
                    .matchedGeometryEffect(id: MusicPlayer.skipButtonKey, in: nspace, properties: .frame, isSource: !isOpen)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(Constants.spacing)
        }
    }
}
    
struct ClosedMusicPlayer: View {
    @EnvironmentObject var settingsController: SettingsController
    @EnvironmentObject var musicController: MusicPlayerController
    @EnvironmentObject var feedbackGenerator: FeedbackGenerator
    
    @Binding var isOpen: Bool
    @Binding var rotation: Double
    
    var nspace: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
                .matchedGeometryEffect(id: MusicPlayer.backgroundKey, in: nspace, properties: .frame, isSource: isOpen)
            
            HStack {
                MusicArtwork(colorScheme: settingsController.colorScheme, image: musicController.currentSong.artwork, rotation: $rotation, size: .button)
                    .matchedGeometryEffect(id: "MusicPlayer.Artwork", in: nspace)
                    .frame(width: 80, height: 80)
                    .padding(.all, 10)
                    .matchedGeometryEffect(id: MusicPlayer.artworkKey, in: nspace)
                
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
                    .matchedGeometryEffect(id: MusicPlayer.songTitleKey, in: nspace, properties: .frame, isSource: isOpen)
                
                    Text(musicController.currentSong.artist)
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(settingsController.colorScheme.textColor.color)
                        .matchedGeometryEffect(id: MusicPlayer.songArtistKey, in: nspace, properties: .frame, isSource: isOpen)
                }
                
                Spacer()
                
                let background = settingsController.colorScheme.backgroundGradient.first.average(to: settingsController.colorScheme.backgroundGradient.last)
                
                HStack {
                    DefaultButton(imageName: "backward.fill", imageColor: settingsController.colorScheme.textColor.color, buttonColor: background, neoSize: .tinyButton, mult: 0.44) {
                        musicController.skipToPreviousItem()
                        feedbackGenerator.warningFeedback()
                    }
                    .matchedGeometryEffect(id: MusicPlayer.backButtonKey, in: nspace, properties: .frame, isSource: isOpen)
                    
                    DefaultButton(imageName: musicController.isPlaying ? "pause.fill" : "play.fill", imageColor: settingsController.colorScheme.textColor.color, buttonColor: background, neoSize: .tinyButton, mult: 0.5, isSelected: musicController.isPlaying) {
                        musicController.toggle()
                        feedbackGenerator.warningFeedback()
                    }
                    .matchedGeometryEffect(id: MusicPlayer.pauseButtonKey, in: nspace, properties: .frame, isSource: isOpen)
                    
                    DefaultButton(imageName: "forward.fill", imageColor: settingsController.colorScheme.textColor.color, buttonColor: background, neoSize: .tinyButton, mult: 0.44) {
                        musicController.skipToNextItem()
                        feedbackGenerator.warningFeedback()
                    }
                    .matchedGeometryEffect(id: MusicPlayer.skipButtonKey, in: nspace, properties: .frame, isSource: isOpen)
                }
                .padding(.horizontal, 10)
            }
        }
        .frame(height: 100)
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    @State static var isOpen = false
    
    static var previews: some View {
        MusicPlayer(isOpen: $isOpen)
            .environmentObject(SettingsController.shared)
            .environmentObject(MusicPlayerController())
            .environmentObject(FeedbackGenerator())
    }
}
