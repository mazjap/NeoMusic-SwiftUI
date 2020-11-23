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
    
    @State private var startTime: Double = 0
    @State private var currentTime: Double = 0
    @State private var totalTime: Double = 0
    
    @State private var upNextViewOpen: Bool = false
    @State private var rotation: Double = 0
    @Namespace private var nspace
    
    @Binding var isOpen: Bool
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isOpen { // MARK: - isOpen
                OpenPlayer(namespace: nspace, isOpen: $isOpen, rotation: $rotation, start: $startTime, end: $totalTime, current: $currentTime, showUpNext: $upNextViewOpen)
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
    static let upNextViewWidth: CGFloat = 200
}

// MARK: - OpenPlayer

struct OpenPlayer: View {
    
    // MARK: - State
    
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    @EnvironmentObject private var musicController: MusicPlayerController
    @EnvironmentObject private var settingsController: SettingsController
    
    @State private var offset: CGFloat = 0
    @Binding private var showUpNextView: Bool
    @State private var upNextDragOffset: CGFloat = 0
    
    @Binding private var isOpen: Bool
    @Binding private var rotation: Double
    
    @Binding private var startTime: Double
    @Binding private var totalTime: Double
    @Binding private var currentTime: Double
    
    // MARK: - Variables
    
    private let nspace: Namespace.ID
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // MARK: - Initializers
    
    init(namespace: Namespace.ID, isOpen: Binding<Bool>, rotation: Binding<Double>, start: Binding<Double>, end: Binding<Double>, current: Binding<Double>, showUpNext: Binding<Bool>) {
        self.nspace = namespace
        self._isOpen = isOpen
        self._rotation = rotation
        self._startTime = start
        self._totalTime = end
        self._currentTime = current
        self._showUpNextView = showUpNext
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .trailing) {
            LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.top)
                .matchedGeometryEffect(id: MusicPlayer.backgroundKey, in: nspace, isSource: !isOpen)
                .transition(.identity)
            
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
                        withAnimation {
                            showUpNextView.toggle()
                        }
                        
                        feedbackGenerator.impactOccurred()
                    }
                }
                .spacing([.top, .leading, .trailing])
                
                Spacer()
                
                MusicArtwork(colorScheme: settingsController.colorScheme, image: musicController.currentSong.image, rotation: $rotation)
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
                
                Text(musicController.currentSong.artistName)
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundColor(settingsController.colorScheme.textColor.color)
                    .spacing(.horizontal)
                    .matchedGeometryEffect(id: MusicPlayer.songArtistKey, in: nspace, properties: .position, isSource: !isOpen)
                
                VStack {
                    MusicSlider(colorScheme: settingsController.colorScheme, min: $startTime, max: $totalTime, current: $currentTime) { time in
                        musicController.set(time: time)
                    }
                        .padding(.horizontal, 5)
                        .onReceive(timer) { _ in
                            if musicController.currentPlaybackTime == musicController.totalPlaybackTime {
                                currentTime = 0
                                totalTime = 0.01
                            } else {
                                currentTime = musicController.currentPlaybackTime
                                totalTime = musicController.totalPlaybackTime
                            }
                        }
                    
                    HStack {
                        Spacer()
                        
                        DefaultButton(imageName: "backward.fill", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, neoSize: .tinyButton, mult: 1.1) {
                            musicController.skipToPreviousItem()
                            feedbackGenerator.warningFeedback()
                        }
                         .matchedGeometryEffect(id: MusicPlayer.backButtonKey, in: nspace, isSource: !isOpen)
                            
                        Spacer()
                        
                        DefaultButton(imageName: musicController.isPlaying ? "pause.fill" : "play.fill", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, neoSize: .tinyButton, mult: 1.25, isSelected: musicController.isPlaying) {
                            musicController.toggle()
                            feedbackGenerator.warningFeedback()
                        }
                         .matchedGeometryEffect(id: MusicPlayer.pauseButtonKey, in: nspace, isSource: !isOpen)
                        
                        Spacer()
                        
                        DefaultButton(imageName: "forward.fill", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: settingsController.colorScheme.backgroundGradient.last, neoSize: .tinyButton, mult: 1.1) {
                            musicController.skipToNextItem()
                            feedbackGenerator.warningFeedback()
                        }
                         .matchedGeometryEffect(id: MusicPlayer.skipButtonKey, in: nspace, isSource: !isOpen)
                        
                        Spacer()
                    }
                    .transition(.scale)
                }
            }
            
            if showUpNextView {
                UpNextView(colorScheme: settingsController.colorScheme)
                    .frame(width: MusicPlayer.upNextViewWidth)
                    .offset(x: upNextDragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                upNextDragOffset = max(min(value.translation.width, MusicPlayer.upNextViewWidth), 0)
                            }
                            .onEnded { value in
                                if upNextDragOffset > MusicPlayer.upNextViewWidth / 3 {
                                    withAnimation {
                                        showUpNextView.toggle()
                                    }
                                }
                                
                                withAnimation {
                                    upNextDragOffset = 0
                                }
                            }
                    )
                    .matchedGeometryEffect(id: "test", in: nspace)
            } else {
                Rectangle()
                    .foregroundColor(settingsController.colorScheme.backgroundGradient.last)
                    .frame(width: MusicPlayer.upNextViewWidth)
                    .offset(x: MusicPlayer.upNextViewWidth)
                    .matchedGeometryEffect(id: "test", in: nspace)
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
                            feedbackGenerator.impactOccurred()
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
    
    // MARK: - Initializers
    
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
                .matchedGeometryEffect(id: MusicPlayer.backgroundKey, in: nspace, isSource: isOpen)
                .transition(.identity)
            
            HStack {
                MusicArtwork(colorScheme: settingsController.colorScheme, image: musicController.currentSong.image, rotation: $rotation, size: .button)
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
                
                    Text(musicController.currentSong.artistName)
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(settingsController.colorScheme.textColor.color)
                        .matchedGeometryEffect(id: MusicPlayer.songArtistKey, in: nspace, isSource: isOpen)
                }
                
                Spacer()
                
                let background = settingsController.colorScheme.backgroundGradient.first.average(to: settingsController.colorScheme.backgroundGradient.last)
                
                HStack {
                    DefaultButton(imageName: "backward.fill", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: background, neoSize: .tinyButton, mult: 0.44) {
                        musicController.skipToPreviousItem()
                        feedbackGenerator.warningFeedback()
                    }
                     .matchedGeometryEffect(id: MusicPlayer.backButtonKey, in: nspace, isSource: isOpen)
                    
                    DefaultButton(imageName: musicController.isPlaying ? "pause.fill" : "play.fill", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: background, neoSize: .tinyButton, mult: 0.5, isSelected: musicController.isPlaying) {
                        musicController.toggle()
                        feedbackGenerator.warningFeedback()
                    }
                     .matchedGeometryEffect(id: MusicPlayer.pauseButtonKey, in: nspace, isSource: isOpen)
                    
                    DefaultButton(imageName: "forward.fill", imageColor: settingsController.colorScheme.mainButtonColor.color, buttonColor: background, neoSize: .tinyButton, mult: 0.44) {
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
        .offset(y: isOpen ? 0 : offset / 2)
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
                            feedbackGenerator.impactOccurred()
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
    @State static var closed = false
    @State static var open = true
    
    static let sc = SettingsController.shared
    static let fg = FeedbackGenerator(feedbackEnabled: false)
    static let mc = MusicPlayerController()
    
    static var previews: some View {
        VStack {
            MusicPlayer(isOpen: $closed)
                .environmentObject(sc)
                .environmentObject(mc)
                .environmentObject(fg)
            
            MusicPlayer(isOpen: $open)
                .environmentObject(sc)
                .environmentObject(mc)
                .environmentObject(fg)
            
        }
    }
}
