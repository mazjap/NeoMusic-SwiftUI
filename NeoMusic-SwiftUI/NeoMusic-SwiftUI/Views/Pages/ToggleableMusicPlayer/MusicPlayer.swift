import SwiftUI

// MARK: - MusicPlayer

struct MusicPlayer: View {
    
    // MARK: - State
    @Namespace private var nspace
    
    @State private var startTime: Double = 0
    @State private var currentTime: Double = 0
    @State private var totalTime: Double = 0
    
    @State private var upNextViewOpen: Bool = false
    @State private var rotation: Angle = .zero
    
    @Binding var isOpen: Bool
    
    // MARK: - Body
    
    var body: some View {
        if isOpen {
            OpenPlayer(
                namespace: nspace,
                isOpen: $isOpen,
                rotation: $rotation,
                start: $startTime,
                end: $totalTime,
                current: $currentTime,
                showUpNext: $upNextViewOpen
            )
        } else {
            ClosedPlayer(
                namespace: nspace,
                isOpen: $isOpen,
                rotation: $rotation
            )
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
    @EnvironmentObject private var musicController: MusicController
    @EnvironmentObject private var settingsController: SettingsController
    
    @State private var offset: CGFloat = 0
    @Binding private var showUpNextView: Bool
    @State private var upNextDragOffset: CGFloat = 0
    
    @Binding private var isOpen: Bool
    @Binding private var rotation: Angle
    
    @Binding private var startTime: Double
    @Binding private var totalTime: Double
    @Binding private var currentTime: Double
    
    // MARK: - Variables
    
    private let nspace: Namespace.ID
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // MARK: - Initializers
    
    init(namespace: Namespace.ID, isOpen: Binding<Bool>, rotation: Binding<Angle>, start: Binding<Double>, end: Binding<Double>, current: Binding<Double>, showUpNext: Binding<Bool>) {
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
                topNav.padding([.top, .leading, .trailing], 16)
                
                Spacer()
                
                image
                
                songTitle
                    .spacing(.horizontal)
                
                songArtist
                
                songSlider
                
                songControls
            }
            .padding(.bottom, 20)
            
//            if showUpNextView {
//                UpNextView(colorScheme: settingsController.colorScheme)
//                    .matchedGeometryEffect(id: MusicPlayer.upNextViewKey, in: nspace)
//                    .frame(width: MusicPlayer.upNextViewWidth)
//                    .offset(x: upNextDragOffset)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                upNextDragOffset = max(min(value.translation.width, MusicPlayer.upNextViewWidth), 0)
//                            }
//                            .onEnded { value in
//                                if upNextDragOffset > MusicPlayer.upNextViewWidth / 3 {
//                                    withAnimation {
//                                        showUpNextView.toggle()
//                                    }
//                                }
//
//                                withAnimation {
//                                    upNextDragOffset = 0
//                                }
//                            }
//                    )
//            } else {
//                Rectangle()
//                    .matchedGeometryEffect(id: MusicPlayer.upNextViewKey, in: nspace)
//                    .foregroundColor(settingsController.colorScheme.backgroundGradient.last)
//                    .frame(width: MusicPlayer.upNextViewWidth)
//                    .offset(x: MusicPlayer.upNextViewWidth)
//            }
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
                    .frame(maxWidth: Constants.buttonSize, maxHeight: Constants.buttonSize)
            }
            .transition(.scale)
            .buttonStyle(DefaultButtonStyle(color: settingsController.colorScheme.backgroundGradient.first))
            .frame(maxWidth: Constants.buttonSize, maxHeight: Constants.buttonSize)
            
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
                    .frame(maxWidth: Constants.buttonSize, maxHeight: Constants.buttonSize)
            }
            .transition(.scale)
            .buttonStyle(DefaultButtonStyle(color: settingsController.colorScheme.backgroundGradient.first))
            .frame(maxWidth: Constants.buttonSize, maxHeight: Constants.buttonSize)
        }
    }
    
    private var image: some View {
        RotatingRecord(
            musicController.currentSong.image,
            lastRotation: $rotation
        )
        .padding(5)
        .neumorph(color: settingsController.colorScheme.backgroundGradient.first.average(to: settingsController.colorScheme.backgroundGradient.last), size: .artwork, cornerRadius: .infinity, isConcave: false)
        .matchedGeometryEffect(id: MusicPlayer.artworkKey, in: nspace, isSource: !isOpen)
        .padding(.horizontal)
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
            .buttonStyle(DefaultButtonStyle(color: settingsController.colorScheme.backgroundGradient.last))
            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
            .matchedGeometryEffect(id: MusicPlayer.backButtonKey, in: nspace, isSource: !isOpen)
                
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
            .buttonStyle(DefaultButtonStyle(color: settingsController.colorScheme.backgroundGradient.last, padding: Constants.buttonPadding, isSelected: musicController.isPlaying))
            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
            .matchedGeometryEffect(id: MusicPlayer.pauseButtonKey, in: nspace, isSource: !isOpen)
            
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
            .buttonStyle(DefaultButtonStyle(color: settingsController.colorScheme.backgroundGradient.last))
            .frame(width: Constants.buttonSize, height: Constants.buttonSize)
            .matchedGeometryEffect(id: MusicPlayer.skipButtonKey, in: nspace, isSource: !isOpen)
            
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
    @State private var spinDuration: Double = 0
    
    @Binding private var isOpen: Bool
    @Binding private var rotation: Angle
    
    // MARK: - Variables
    
    private let nspace: Namespace.ID
    
    // MARK: - Initializers
    
    init(namespace: Namespace.ID, isOpen: Binding<Bool>, rotation: Binding<Angle>) {
        nspace = namespace
        _isOpen = isOpen
        _rotation = rotation
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
        .gesture(DragGesture(coordinateSpace: .global)
            .onChanged { value in
                guard !isOpen else { return }
                
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
    
    private var background: some View {
        LinearGradient(gradient: Gradient(colors: settingsController.colorScheme.backgroundGradient.colors), startPoint: .top, endPoint: .bottom)
            .transition(.scaleAndSlide)
            .matchedGeometryEffect(id: MusicPlayer.backgroundKey, in: nspace, isSource: isOpen)
            .edgesIgnoringSafeArea(.top)
    }
    
    private var image: some View {
        RotatingRecord(musicController.currentSong.image, spinDuration: spinDuration, lastRotation: $rotation)
            .neumorph(color: settingsController.colorScheme.backgroundGradient.first.average(to: settingsController.colorScheme.backgroundGradient.last), size: .button, cornerRadius: .infinity, isConcave: false)
            .frame(width: MusicPlayer.musicPlayerHeightOffset - Constants.spacing * 2, height: MusicPlayer.musicPlayerHeightOffset - Constants.spacing * 2)
            .matchedGeometryEffect(id: MusicPlayer.artworkKey, in: nspace, isSource: isOpen)
            .padding()
            .onChange(of: musicController.isPlaying) { isNowPlaying in
                updateSpin(isPlaying: isNowPlaying)
            }
            .onAppear {
                updateSpin()
            }
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
            .buttonStyle(DefaultButtonStyle(color: background, padding: Constants.buttonPadding / 2.8, neoSize: .tinyButton))
            .frame(width: Constants.buttonSize / 3, height: Constants.buttonSize / 3)
            .matchedGeometryEffect(id: MusicPlayer.backButtonKey, in: nspace, isSource: isOpen)
            
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
            .buttonStyle(DefaultButtonStyle(color: background, padding: Constants.buttonPadding / 2.8, isSelected: musicController.isPlaying, neoSize: .tinyButton))
            .frame(width: Constants.buttonSize / 2.8, height: Constants.buttonSize / 2.8)
            .matchedGeometryEffect(id: MusicPlayer.pauseButtonKey, in: nspace, isSource: isOpen)
            
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
            .buttonStyle(DefaultButtonStyle(color: background, padding: Constants.buttonPadding / 2.8, neoSize: .tinyButton))
            .frame(width: Constants.buttonSize / 3, height: Constants.buttonSize / 3)
            .matchedGeometryEffect(id: MusicPlayer.skipButtonKey, in: nspace, isSource: isOpen)
        }
    }
    
    private func updateSpin(isPlaying: Bool? = nil) {
        let isNowPlaying = isPlaying ?? musicController.isPlaying
        
        spinDuration = isNowPlaying ? 3 : 0
    }
}

// MARK: - Preview

struct MusicPlayerPreview: View {
    @State private var isOpen = false
    
    var body: some View {
        MusicPlayer(isOpen: $isOpen)
    }
}

struct MusicPlayer_Previews: PreviewProvider {
    static let sc = SettingsController.shared
    static let fg = FeedbackGenerator(feedbackEnabled: false)
    static let mc = MusicController()
    
    static var previews: some View {
        ZStack(alignment: .bottom) {
            MusicPlayerPreview()
        }
        .environmentObject(sc)
        .environmentObject(mc)
        .environmentObject(fg)
    }
}
