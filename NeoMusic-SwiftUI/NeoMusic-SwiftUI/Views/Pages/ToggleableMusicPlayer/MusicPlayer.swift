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
    
    @EnvironmentObject private var musicController: MusicController
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
                OpenPlayer(
                    namespace: nspace,
                    isOpen: $isOpen,
                    rotation: $rotation,
                    start: $startTime,
                    end: $totalTime,
                    current: $currentTime,
                    showUpNext: $upNextViewOpen
                )
            } else { // MARK: - isClosed
                ClosedPlayer(
                    namespace: nspace,
                    isOpen: $isOpen,
                    rotation: $rotation
                )
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
    static let   upNextViewKey = base + "UpNextView"
    
    
    static let musicPlayerHeightOffset: CGFloat = 100
    static let upNextViewWidth: CGFloat = 200
}

// MARK: - OpenPlayer

struct OpenPlayer: View {
    
    // MARK: - State
    
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    @EnvironmentObject private var musicController: MusicController
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
            background
            
            VStack {
                topNav
                    .spacing([
                        .top,
                        .leading,
                        .trailing
                    ])
                
                Spacer()
                
                image
                
                songTitle
                    .spacing(.horizontal)
                
                songArtist
                
                songSlider
                
                songControls
            }
            
            if showUpNextView {
                UpNextView(colorScheme: settingsController.colorScheme)
                    .matchedGeometryEffect(id: MusicPlayer.upNextViewKey, in: nspace)
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
            } else {
                Rectangle()
                    .matchedGeometryEffect(id: MusicPlayer.upNextViewKey, in: nspace)
                    .foregroundColor(settingsController.colorScheme.backgroundGradient.last)
                    .frame(width: MusicPlayer.upNextViewWidth)
                    .offset(x: MusicPlayer.upNextViewWidth)
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
    
    private var background: some View {
        LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.top)
            .transition(.scaleAndSlide)
            .matchedGeometryEffect(id: MusicPlayer.backgroundKey, in: nspace, isSource: !isOpen)
    }
    
    private var topNav: some View {
        HStack {
            Spacer()
            
            Button(action: {
                withAnimation {
                    isOpen = false
                }
                
                feedbackGenerator.impactOccurred()
            }) {
                Image(systemName: "arrow.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(settingsController.colorScheme.mainButtonColor.color)
                    .frame(width: Constants.buttonSize / 2, height: Constants.buttonSize / 2)
            }
            .transition(.scale)
            .buttonStyle(DefaultButtonStyle(color: settingsController.colorScheme.backgroundGradient.first))
            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
            
            Spacer()
            
            Text(musicController.isPlaying ? "Now Playing" : "Paused")
                .foregroundColor(settingsController.colorScheme.textColor.color)
                .layoutPriority(1)
            
            Spacer()
            
            
            Button(action: {
                withAnimation {
                    showUpNextView.toggle()
                }
                
                feedbackGenerator.impactOccurred()
            }) {
                Image(systemName: "line.horizontal.3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(settingsController.colorScheme.mainButtonColor.color)
                    .frame(width: Constants.buttonSize / 2, height: Constants.buttonSize / 2)
            }
            .transition(.scale)
            .buttonStyle(DefaultButtonStyle(color: settingsController.colorScheme.backgroundGradient.first))
            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
            
            Spacer()
        }
    }
    
    private var image: some View {
        RotatableImage(
            colorScheme: settingsController.colorScheme,
            image: musicController.currentSong.image,
            rotation: $rotation
        )
        .matchedGeometryEffect(id: MusicPlayer.artworkKey, in: nspace, isSource: !isOpen)
        .spacing(.horizontal)
    }
    
    private var songTitle: some View {
        HStack {
            Text(musicController.currentSong.title)
                .lineLimit(1)
                .font(.title)
                .foregroundColor(settingsController.colorScheme.textColor.color)
                .matchedGeometryEffect(id: MusicPlayer.songTitleKey, in: nspace, isSource: !isOpen)
            if musicController.currentSong.isExplicit {
                Image(systemName: "e.square.fill")
                    .matchedGeometryEffect(id: MusicPlayer.songExplicitKey, in: nspace, properties: .position, isSource: !isOpen)
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
        }
    }
    
    private var songArtist: some View {
        Text(musicController.currentSong.artist)
            .lineLimit(1)
            .font(.subheadline)
            .matchedGeometryEffect(id: MusicPlayer.songArtistKey, in: nspace, properties: .position, isSource: !isOpen)
            .foregroundColor(settingsController.colorScheme.textColor.color)
            .spacing(.horizontal)
    }
    
    private var songSlider: some View {
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
        }
    }
    
    private var songControls: some View {
        HStack {
            Spacer()
            
            Button(action: {
                musicController.skipToPreviousItem()
                feedbackGenerator.warningFeedback()
            }) {
                Image(systemName: "backward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .transition(.scale)
                    .foregroundColor(settingsController.colorScheme.mainButtonColor.color)
            }
            .transition(.scaleAndSlide)
            .matchedGeometryEffect(id: MusicPlayer.backButtonKey, in: nspace, isSource: !isOpen)
            .buttonStyle(DefaultButtonStyle(color: settingsController.colorScheme.backgroundGradient.last))
            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                
            Spacer()
            
            Button(action: {
                withAnimation {
                    musicController.toggle()
                }
                
                feedbackGenerator.warningFeedback()
            }) {
                Image(systemName: musicController.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .transition(.scale)
                    .foregroundColor(settingsController.colorScheme.mainButtonColor.color)
            }
            .transition(.scaleAndSlide)
            .matchedGeometryEffect(id: MusicPlayer.pauseButtonKey, in: nspace, isSource: !isOpen)
            .buttonStyle(DefaultButtonStyle(color: settingsController.colorScheme.backgroundGradient.last, padding: Constants.buttonPadding, isSelected: musicController.isPlaying))
            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
            
            Spacer()
            
            Button(action: {
                musicController.skipToNextItem()
                feedbackGenerator.warningFeedback()
            }) {
                Image(systemName: "forward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .transition(.scale)
                    .foregroundColor(settingsController.colorScheme.mainButtonColor.color)
            }
            .transition(.scaleAndSlide)
            .matchedGeometryEffect(id: MusicPlayer.skipButtonKey, in: nspace, isSource: !isOpen)
            .buttonStyle(DefaultButtonStyle(color: settingsController.colorScheme.backgroundGradient.last))
            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
            
            Spacer()
        }
    }
}

// MARK: - ClosedPlayer

struct ClosedPlayer: View {
    
    // MARK: - State
    
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    @EnvironmentObject private var musicController: MusicController
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
    
    private var dragGesture: some Gesture {
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
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            background
            
            HStack {
                image
                
                songInformation
                
                Spacer()
                
                buttonControls
                .spacing(.horizontal)
            }
        }
        .frame(height: MusicPlayer.musicPlayerHeightOffset + (isOpen ? 0 : abs(offset)))
        .offset(y: isOpen ? 0 : offset / 2)
        .gesture(dragGesture)
        
    }
    
    private var background: some View {
        LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
            .transition(.scaleAndSlide)
            .matchedGeometryEffect(id: MusicPlayer.backgroundKey, in: nspace, isSource: isOpen)
            .edgesIgnoringSafeArea(.top)
    }
    
    private var image: some View {
        RotatableImage(colorScheme: settingsController.colorScheme, image: musicController.currentSong.image, rotation: $rotation, size: .button, imagePadding: 1)
            .frame(width: MusicPlayer.musicPlayerHeightOffset - Constants.spacing * 2, height: MusicPlayer.musicPlayerHeightOffset - Constants.spacing * 2)
            .matchedGeometryEffect(id: MusicPlayer.artworkKey, in: nspace, isSource: isOpen)
            .spacing()
    }
    
    private var songInformation: some View {
        VStack(alignment: .leading) {
            HStack {
                let font: Font = .footnote
                
                Text(musicController.currentSong.title)
                    .lineLimit(1)
                    .font(font)
                    .matchedGeometryEffect(id: MusicPlayer.songTitleKey, in: nspace, properties: .position, isSource: isOpen)
                    .foregroundColor(settingsController.colorScheme.textColor.color)
                if musicController.currentSong.isExplicit {
                    Image(systemName: "e.square.fill")
                        .resizable()
                        .frame(width: font.size, height: font.size)
                        .matchedGeometryEffect(id: MusicPlayer.songExplicitKey, in: nspace, properties: .position, isSource: isOpen)
                        .foregroundColor(settingsController.colorScheme.textColor.color)
                }
            }
        
            Text(musicController.currentSong.artist)
                .lineLimit(1)
                .font(.caption)
                .matchedGeometryEffect(id: MusicPlayer.songArtistKey, in: nspace, isSource: isOpen)
                .foregroundColor(settingsController.colorScheme.textColor.color)
        }
    }
    
    private var buttonControls: some View {
        HStack {
            let background = settingsController.colorScheme.backgroundGradient.first.average(to: settingsController.colorScheme.backgroundGradient.last)
            
            Button(action: {
                musicController.skipToPreviousItem()
                feedbackGenerator.warningFeedback()
            }) {
                Image(systemName: "backward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .transition(.scale)
                    .foregroundColor(settingsController.colorScheme.mainButtonColor.color)
            }
            .transition(.scaleAndSlide)
            .matchedGeometryEffect(id: MusicPlayer.backButtonKey, in: nspace, isSource: isOpen)
            .buttonStyle(DefaultButtonStyle(color: background, padding: Constants.buttonPadding / 2.8, neoSize: .tinyButton))
            .frame(width: Constants.buttonSize / 3, height: Constants.buttonSize / 3)
            
            Button(action: {
                withAnimation {
                    musicController.toggle()
                }
                
                feedbackGenerator.warningFeedback()
            }) {
                Image(systemName: musicController.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .transition(.scale)
                    .foregroundColor(settingsController.colorScheme.mainButtonColor.color)
            }
            .transition(.scaleAndSlide)
            .matchedGeometryEffect(id: MusicPlayer.pauseButtonKey, in: nspace, isSource: isOpen)
            .buttonStyle(DefaultButtonStyle(color: background, padding: Constants.buttonPadding / 2.8, isSelected: musicController.isPlaying, neoSize: .tinyButton))
            .frame(width: Constants.buttonSize / 2.8, height: Constants.buttonSize / 2.8)
            
            Button(action: {
                musicController.skipToNextItem()
                feedbackGenerator.warningFeedback()
            }) {
                Image(systemName: "forward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .transition(.scale)
                    .foregroundColor(settingsController.colorScheme.mainButtonColor.color)
            }
            .transition(.scaleAndSlide)
            .matchedGeometryEffect(id: MusicPlayer.skipButtonKey, in: nspace, isSource: isOpen)
            .buttonStyle(DefaultButtonStyle(color: background, padding: Constants.buttonPadding / 2.8, neoSize: .tinyButton))
            .frame(width: Constants.buttonSize / 3, height: Constants.buttonSize / 3)
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    @State static var closed = false
    @State static var open = true
    
    static let sc = SettingsController.shared
    static let fg = FeedbackGenerator(feedbackEnabled: false)
    static let mc = MusicController()
    
    static var previews: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                JCColorScheme.default.backgroundGradient.last
                    .frame(height: TabBar.height)
                
                MusicPlayer(isOpen: $open)
                    .frame(height: geometry.size.height - TabBar.height)
                    .offset(y: open ? -TabBar.height / 2 : geometry.size.height / 2 - TabBar.height - MusicPlayer.musicPlayerHeightOffset / 2)
            }
        }
        .environmentObject(sc)
        .environmentObject(mc)
        .environmentObject(fg)
    }
}
