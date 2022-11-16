import SwiftUI

@main
struct NeoMusic_SwiftUIApp: App {
    @StateObject private var settingsController = SettingsController.shared
    @StateObject private var musicController = MusicController()
    @StateObject private var feedbackGenerator = FeedbackGenerator(feedbackEnabled: SettingsController.shared.feedbackEnabled)
    @State private var isLoading = true
    @State private var gradient = JCColorScheme.default.backgroundGradient.gradient
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .onAppear {
                        withAnimation {
                            gradient = settingsController.colorScheme.backgroundGradient.gradient
                            
                            isLoading = false
                        }
                    }
            } else {
                RootView()
                    .environmentObject(settingsController)
                    .environmentObject(musicController)
                    .environmentObject(feedbackGenerator)
                    .environment(\.managedObjectContext, CoreDataStack.shared.userContext)
            }
        }
    }
}
