//
//  TabItem.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 9/7/20.
//

import SwiftUI

struct TabItem: View {
    
    // MARK: - State
    
    @EnvironmentObject private var feedbackGenerator: FeedbackGenerator
    
    // MARK: - Variables
    
    let title: Text
    let image: Image
    let content: AnyView
    
    // MARK: - Initializers
    
    init<Content>(title: String, imageName: String, @ViewBuilder _ content: () -> Content) where Content: View {
        self.title = Text(title)
        self.image = Image(systemName: imageName)
        self.content = content().asAny()
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {}) {
            content
        }
    }
}

// MARK: - Preview

struct TabItem_Previews: PreviewProvider {
    static var previews: some View {
        TabBar {
            TabItem(title: "Tab", imageName: "circle.fill") {
                VStack {
                    Text("Content goes here:")
                    
                    ZStack {
                        Rectangle()
                            .cornerRadius(20)
                            .foregroundColor(.red)
                            .spacing()
                        
                        Circle()
                            .foregroundColor(.blue)
                            .spacing()
                    }
                }
            }
        }
        .environmentObject(FeedbackGenerator(feedbackEnabled: false))
    }
}
