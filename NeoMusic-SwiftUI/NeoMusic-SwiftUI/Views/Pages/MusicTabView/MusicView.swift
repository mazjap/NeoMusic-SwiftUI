import SwiftUI

struct MusicView: View {
    
    // MARK: - State
    
    @EnvironmentObject private var settingsController: SettingsController
    @EnvironmentObject private var musicController: MusicController
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: settingsController.colorScheme.backgroundGradient.gradient, startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: geometry.size.height + MusicPlayer.musicPlayerHeightOffset - tabBarHeight)
                    .offset(y: -tabBarHeight / 2)
                
                Text("Music View")
                    .foregroundColor(settingsController.colorScheme.textColor.color)
            }
        }
    }
}

// MARK: - Preview

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView()
            .environmentObject(SettingsController.shared)
            .environmentObject(MusicController())
    }
}
