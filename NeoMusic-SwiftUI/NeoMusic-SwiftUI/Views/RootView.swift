import SwiftUI

struct RootView: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var feedback: FeedbackGenerator
    @EnvironmentObject private var musicController: MusicController
    
    @StateObject private var messageController = MessageController.shared
    @State private var musicPlayerIsOpen: Bool = true
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            TabBar(tabItem: AppTab.self) { item in
                ZStack {
                    LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.top)
                    
                    ZStack(alignment: .bottom) {
                        switch item {
                        case .search:
                            SearchView()
                        case .music:
                            MusicView()
                        case .profile:
                            ProfileView()
                        }
                        
                        MusicPlayer(isOpen: $musicPlayerIsOpen)
                    }
                }
            }
            .accentColor(settingsController.colorScheme.textColor.color)
        }
    }
}

// MARK: - Preview

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(SettingsController.shared)
            .environmentObject(MusicController())
            .environmentObject(FeedbackGenerator(feedbackEnabled: false))
    }
}
