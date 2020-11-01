//
//  NeoMusic_SwiftUIApp.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/24/20.
//

import SwiftUI

@main
struct NeoMusic_SwiftUIApp: App {
    typealias SomeView = RootView
    
    @StateObject var musicController = MusicPlayerController()
    @StateObject var feedbackGenerator = FeedbackGenerator(feedbackEnabled: SettingsController.shared.feedbackEnabled)
    
    var body: some Scene {
        WindowGroup {
            Text("Loading...")
                .onAppear(perform: {
                            UIApplication.shared.setHostingController(rootView:
                                SomeView()
                                    .environmentObject(SettingsController.shared)
                                    .environmentObject(musicController)
                                    .environmentObject(feedbackGenerator)
                            )
                    }
                )
        }
    }
}
