import SwiftUI

// MARK: - MusicPlayer

struct MusicPlayer: View {
    
    // MARK: - State
    
    @EnvironmentObject private var musicController: MusicController
    
    @Namespace private var nspace
    
    @State private var startTime: Double = 0
    @State private var currentTime: Double = 0
    @State private var totalTime: Double = 0
    
    @State private var upNextViewOpen: Bool = false
    @State private var rotation: Angle = .zero
    
    @Binding var isOpen: Bool
    
    // MARK: - Properties
    
    private let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    
    // MARK: - Body
    
    var body: some View {
        Group {
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
                    totalTime: $totalTime,
                    currentTime: $currentTime,
                    isOpen: $isOpen,
                    rotation: $rotation
                )
            }
        }
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
    
    // MARK: - Static Variables
    
    fileprivate static let base = "MusicPlayer."
    
    fileprivate static let backgroundKey   = base + "Background"
    fileprivate static let artworkKey      = base + "Artwork"
    fileprivate static let songTitleKey    = base + "Title"
    fileprivate static let songExplicitKey = base + "IsExplicit"
    fileprivate static let songArtistKey   = base + "Artist"
    fileprivate static let songSlider      = base + "Slider"
    fileprivate static let backButtonKey   = base + "Back"
    fileprivate static let pauseButtonKey  = base + "Pause"
    fileprivate static let skipButtonKey   = base + "Skip"
    
    fileprivate static let upNextViewWidth: CGFloat = 200
    static let musicPlayerHeightOffset: CGFloat = 100
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
    
    // MARK: - Properties
    
    private let nspace: Namespace.ID
    
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
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                background
                
                VStack {
                    topNav.padding([.top, .leading, .trailing], 16)
                    
                    Spacer()
                    
                    image
                    
                    title
                    
                    artist
                    
                    slider
                    
                    controls
                }
                .padding(.bottom, 20)
                
//                if showUpNextView {
//                    UpNextView(colorScheme: settingsController.colorScheme)
//                        .matchedGeometryEffect(id: MusicPlayer.upNextViewKey, in: nspace)
//                        .frame(width: MusicPlayer.upNextViewWidth)
//                        .offset(x: upNextDragOffset)
//                        .gesture(
//                            DragGesture()
//                                .onChanged { value in
//                                    upNextDragOffset = max(min(value.translation.width, MusicPlayer.upNextViewWidth), 0)
//                                }
//                                .onEnded { value in
//                                    if upNextDragOffset > MusicPlayer.upNextViewWidth / 3 {
//                                        withAnimation {
//                                            showUpNextView.toggle()
//                                        }
//                                    }
//
//                                    withAnimation {
//                                        upNextDragOffset = 0
//                                    }
//                                }
//                        )
//                } else {
//                    Rectangle()
//                        .matchedGeometryEffect(id: MusicPlayer.upNextViewKey, in: nspace)
//                        .foregroundColor(settingsController.colorScheme.backgroundGradient.last)
//                        .frame(width: MusicPlayer.upNextViewWidth)
//                        .offset(x: MusicPlayer.upNextViewWidth)
//                }
            }
            .offset(y: isOpen ? offset : 0)
            .frame(height: geometry.size.height - offset, alignment: .bottom)
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
    
    private var background: some View {
        LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
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
        .frame(minWidth: MusicPlayer.musicPlayerHeightOffset - Constants.spacing * 2, minHeight: MusicPlayer.musicPlayerHeightOffset - Constants.spacing * 2)
        .matchedGeometryEffect(id: MusicPlayer.artworkKey, in: nspace, isSource: !isOpen)
        .padding(.horizontal)
    }
    
    private var title: some View {
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
    
    private var artist: some View {
        Text(musicController.currentSong.artist)
            .lineLimit(1)
            .font(.subheadline)
            .matchedGeometryEffect(id: MusicPlayer.songArtistKey, in: nspace, properties: .position, isSource: !isOpen)
            .foregroundColor(settingsController.colorScheme.textColor.color)
            .spacing(.horizontal)
    }
    
    private var slider: some View {
        VStack {
            MusicSlider(colorScheme: settingsController.colorScheme, min: $startTime, max: $totalTime, current: $currentTime) { time in
                musicController.set(time: time)
            }
            .matchedGeometryEffect(id: MusicPlayer.songSlider, in: nspace, isSource: !isOpen)
            .padding(.horizontal, 5)
        }
    }
    
    private var controls: some View {
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
            .frame(width: Constants.buttonSize / (isOpen ? 1 : 3), height: Constants.buttonSize / (isOpen ? 1 : 3))
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
            .frame(width: Constants.buttonSize / (isOpen ? 1 : 3), height: Constants.buttonSize / (isOpen ? 1 : 3))
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
    
    @Binding private var totalTime: Double
    @Binding private var currentTime: Double
    
    @Binding private var isOpen: Bool
    @Binding private var rotation: Angle
    
    // MARK: - Variables
    
    private let nspace: Namespace.ID
    
    // MARK: - Initializers
    
    init(namespace: Namespace.ID, totalTime: Binding<Double>, currentTime: Binding<Double>, isOpen: Binding<Bool>, rotation: Binding<Angle>) {
        nspace = namespace
        _totalTime = totalTime
        _currentTime = currentTime
        _isOpen = isOpen
        _rotation = rotation
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                background
                
                VStack(alignment: .leading, spacing: 0) {
                    progress.frame(width: max(0, currentTime / totalTime * geometry.size.width), height: 2)
                    
                    Spacer().frame(minHeight: 0)
                    
                    HStack {
                        image
                        
                        information
                        
                        Spacer()
                        
                        controls
                            .spacing(.horizontal)
                    }
                    .layoutPriority(1)
                    
                    Spacer().frame(minHeight: 0)
                }
            }
        }
        .frame(height: MusicPlayer.musicPlayerHeightOffset + (isOpen ? 0 : abs(offset)))
        .gesture(DragGesture(coordinateSpace: .global)
            .onChanged { value in
                guard !isOpen else { return }
                
                if value.translation.height <= 0 {
                    offset = value.translation.height / 2
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
        LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
            .transition(.scaleAndSlide)
            .matchedGeometryEffect(id: MusicPlayer.backgroundKey, in: nspace, isSource: isOpen)
            .edgesIgnoringSafeArea(.top)
    }
    
    private var progress: some View {
        LinearGradient(gradient: settingsController.colorScheme.sliderGradient.gradient, startPoint: .top, endPoint: .bottom)
            .matchedGeometryEffect(id: MusicPlayer.songSlider, in: nspace, properties: .position, isSource: isOpen)
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
    
    private var information: some View {
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
    
    private var controls: some View {
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
