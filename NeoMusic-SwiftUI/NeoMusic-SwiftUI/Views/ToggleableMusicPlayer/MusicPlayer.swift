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

// MARK: - MusicPlayer

struct MusicPlayer: View {
    
    // MARK: - State
    
    @EnvironmentObject private var musicController: MusicPlayerController
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    
    @State private var rotation: Double = 0
    @Namespace private var nspace
    
    @Binding var isOpen: Bool
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isOpen { // MARK: - isOpen
                OpenPlayer(namespace: nspace, isOpen: $isOpen, rotation: $rotation)
            } else { // MARK: - isClosed
                ClosedPlayer(namespace: nspace, isOpen: $isOpen, rotation: $rotation)
            }
        }
    }
    
    // MARK: - Static Variables
    
    static let base = "MusicPlayer."
    
    static let   backgroundKey = base + "Background"
    static let      artworkKey = base + "Artwork"
    static let    songTitleKey = base + "SongTitle"
    static let songExplicitKey = base + "IsSongExplicit"
    static let   songArtistKey = base + "SongArtist"
    static let   backButtonKey = base + "BackButton"
    static let  pauseButtonKey = base + "PauseButton"
    static let   skipButtonKey = base + "SkipButton"
    
    
    static let musicPlayerHeightOffset: CGFloat = 100
}

// MARK: - OpenPlayer

struct OpenPlayer: View {
    
    // MARK: - State
    
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    @EnvironmentObject private var musicController: MusicPlayerController
    @EnvironmentObject private var settingsController: SettingsController
    
    @State private var offset: CGFloat = 0
    
    @Binding private var isOpen: Bool
    @Binding private var rotation: Double
    
    // MARK: - Variables
    
    private let nspace: Namespace.ID
    
    // MARK: - Initializer
    
    init(namespace: Namespace.ID, isOpen: Binding<Bool>, rotation: Binding<Double>) {
        nspace = namespace
        _isOpen = isOpen
        _rotation = rotation
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.top)
                .matchedGeometryEffect(id: MusicPlayer.backgroundKey, in: nspace)
                .transition(.scale)
            
            VStack {
                // Navigation Bar
                HStack {
                    DefaultButton(imageName: "arrow.left", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.first) {
                        withAnimation {
                            isOpen = false
                        }
                        feedbackGenerator.impactOccurred()
                    }
                    
                    Spacer()
                    
                    Text(musicController.isPlaying ? "Now Playing" : "Paused")
                        .foregroundColor(settingsController.colorScheme.textColor.color)
                    
                    Spacer()
                    
                    DefaultButton(imageName: "line.horizontal.3", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.first) {
                        // TODO: - Toggle up next view
                        feedbackGenerator.impactOccurred()
                    }
                }
                .spacing([.top, .leading, .trailing])
                
                Spacer()
                
                MusicArtwork(colorScheme: settingsController.colorScheme, image: musicController.currentSong.artwork, rotation: $rotation)
                    .spacing([.bottom, .leading, .trailing])
                    .matchedGeometryEffect(id: MusicPlayer.artworkKey, in: nspace, isSource: !isOpen)
                
                HStack {
                    Text(musicController.currentSong.title)
                        .lineLimit(1)
                        .font(.title)
                        .foregroundColor(settingsController.colorScheme.textColor.color)
                        .matchedGeometryEffect(id: MusicPlayer.songTitleKey, in: nspace, isSource: !isOpen)
                    if musicController.currentSong.isExplicit {
                        Image(systemName: "e.square.fill")
                            .foregroundColor(settingsController.colorScheme.textColor.color)
                            .matchedGeometryEffect(id: MusicPlayer.songExplicitKey, in: nspace, properties: .position, isSource: !isOpen)
                    }
                }
                .spacing(.horizontal)
                
                Text(musicController.currentSong.artist)
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundColor(settingsController.colorScheme.textColor.color)
                    .spacing(.horizontal)
                    .matchedGeometryEffect(id: MusicPlayer.songArtistKey, in: nspace, properties: .position, isSource: !isOpen)
                
                VStack {
                    MusicSlider(colorScheme: settingsController.colorScheme)
                        .padding(.horizontal, 5)
                    
                    HStack {
                        Spacer()
                        
                        DefaultButton(imageName: "backward.fill", imageColor: settingsController.colorScheme.textColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, neoSize: .tinyButton, mult: 1.1) {
                            musicController.skipToPreviousItem()
                            feedbackGenerator.warningFeedback()
                        }
                         .matchedGeometryEffect(id: MusicPlayer.backButtonKey, in: nspace, isSource: !isOpen)
                            
                        Spacer()
                        
                        DefaultButton(imageName: musicController.isPlaying ? "pause.fill" : "play.fill", imageColor: settingsController.colorScheme.textColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, neoSize: .tinyButton, mult: 1.25, isSelected: musicController.isPlaying) {
                            musicController.toggle()
                            feedbackGenerator.warningFeedback()
                        }
                         .matchedGeometryEffect(id: MusicPlayer.pauseButtonKey, in: nspace, isSource: !isOpen)
                        
                        Spacer()
                        
                        DefaultButton(imageName: "forward.fill", imageColor: settingsController.colorScheme.textColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, neoSize: .tinyButton, mult: 1.1) {
                            musicController.skipToNextItem()
                            feedbackGenerator.warningFeedback()
                        }
                         .matchedGeometryEffect(id: MusicPlayer.skipButtonKey, in: nspace, isSource: !isOpen)
                        
                        Spacer()
                    }
                    .transition(.scale)
                }
            }
        }
        .offset(y: isOpen ? offset : 0)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !isOpen {
                        return
                    }
                    
                    if isOpen && value.translation.height >= 0 {
                        offset = value.translation.height
                    }
                    
                    if offset > 50 {
                        withAnimation {
                            isOpen.toggle()
                        }
                    }
                }
                .onEnded { value in
                    withAnimation {
                        offset = 0
                    }
                }
        )
    }
}

// MARK: - ClosedPlayer

struct ClosedPlayer: View {
    
    // MARK: - State
    
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    @EnvironmentObject private var musicController: MusicPlayerController
    @EnvironmentObject private var settingsController: SettingsController
    
    @State private var offset: CGFloat = 0
    
    @Binding private var isOpen: Bool
    @Binding private var rotation: Double
    
    // MARK: - Variables
    
    private let nspace: Namespace.ID
    
    // MARK: - Initializer
    
    init(namespace: Namespace.ID, isOpen: Binding<Bool>, rotation: Binding<Double>) {
        nspace = namespace
        _isOpen = isOpen
        _rotation = rotation
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.top)
                .matchedGeometryEffect(id: MusicPlayer.backgroundKey, in: nspace)
                .transition(.scale)
            
            HStack {
                MusicArtwork(colorScheme: settingsController.colorScheme, image: musicController.currentSong.artwork, rotation: $rotation, size: .button)
                    .frame(width: MusicPlayer.musicPlayerHeightOffset - Constants.spacing * 2, height: MusicPlayer.musicPlayerHeightOffset - Constants.spacing * 2)
                    .spacing()
                    .matchedGeometryEffect(id: MusicPlayer.artworkKey, in: nspace, isSource: isOpen)
                
                VStack(alignment: .leading) {
                    HStack {
                        let font: Font = .footnote
                        
                        Text(musicController.currentSong.title)
                            .lineLimit(1)
                            .font(font)
                            .foregroundColor(settingsController.colorScheme.textColor.color)
                            .matchedGeometryEffect(id: MusicPlayer.songTitleKey, in: nspace, properties: .position, isSource: isOpen)
                        if musicController.currentSong.isExplicit {
                            Image(systemName: "e.square.fill")
                                .resizable()
                                .frame(width: font.size, height: font.size)
                                .foregroundColor(settingsController.colorScheme.textColor.color)
                                .matchedGeometryEffect(id: MusicPlayer.songExplicitKey, in: nspace, properties: .position, isSource: isOpen)
                        }
                    }
                
                    Text(musicController.currentSong.artist)
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(settingsController.colorScheme.textColor.color)
                        .matchedGeometryEffect(id: MusicPlayer.songArtistKey, in: nspace, isSource: isOpen)
                }
                
                Spacer()
                
                let background = settingsController.colorScheme.backgroundGradient.first.average(to: settingsController.colorScheme.backgroundGradient.last)
                
                HStack {
                    DefaultButton(imageName: "backward.fill", imageColor: settingsController.colorScheme.textColor.color, buttonColor: background, neoSize: .tinyButton, mult: 0.44) {
                        musicController.skipToPreviousItem()
                        feedbackGenerator.warningFeedback()
                    }
                     .matchedGeometryEffect(id: MusicPlayer.backButtonKey, in: nspace, isSource: isOpen)
                    
                    DefaultButton(imageName: musicController.isPlaying ? "pause.fill" : "play.fill", imageColor: settingsController.colorScheme.textColor.color, buttonColor: background, neoSize: .tinyButton, mult: 0.5, isSelected: musicController.isPlaying) {
                        musicController.toggle()
                        feedbackGenerator.warningFeedback()
                    }
                     .matchedGeometryEffect(id: MusicPlayer.pauseButtonKey, in: nspace, isSource: isOpen)
                    
                    DefaultButton(imageName: "forward.fill", imageColor: settingsController.colorScheme.textColor.color, buttonColor: background, neoSize: .tinyButton, mult: 0.44) {
                        musicController.skipToNextItem()
                        feedbackGenerator.warningFeedback()
                    }
                     .matchedGeometryEffect(id: MusicPlayer.skipButtonKey, in: nspace, isSource: isOpen)
                }
                .transition(.scale)
                .spacing(.horizontal)
            }
        }
        .frame(height: MusicPlayer.musicPlayerHeightOffset + (isOpen ? 0 : abs(offset)))
        .offset(y: isOpen ? 0 : offset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if isOpen {
                        return
                    }
                    
                    if value.translation.height <= 0 {
                        offset = value.translation.height
                    }
                    
                    if offset < -50 {
                        withAnimation {
                            isOpen.toggle()
                        }
                    }
                }
                .onEnded { value in
                    withAnimation {
                        offset = 0
                    }
                }
        )
        
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
