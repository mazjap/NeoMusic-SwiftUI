//
//  NeoMusic_SwiftUIApp.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/24/20.
//

import SwiftUI

@main
struct NeoMusic_SwiftUIApp: App {
    
    @StateObject private var musicController = MusicPlayerController()
    @StateObject private var feedbackGenerator = FeedbackGenerator(feedbackEnabled: SettingsController.shared.feedbackEnabled)
    
    @State private var gradient = JCColorScheme.default.backgroundGradient.gradient
    
    var body: some Scene {
        WindowGroup {
            Rectangle()
                .fill(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea()
                .onAppear(perform: {
                    let settingsController = SettingsController.shared
                    withAnimation {
                        gradient = settingsController.colorScheme.backgroundGradient.gradient
                    }
                    
                    UIApplication.shared.setHostingController(controller:
                                                                HostingController(rootView:
                                                                    RootView()
                                                                        .environmentObject(settingsController)
                                                                        .environmentObject(musicController)
                                                                        .environmentObject(feedbackGenerator)
                                                                        .asAny()
                                                                )
                    )
                }
            )
        }
    }
}
