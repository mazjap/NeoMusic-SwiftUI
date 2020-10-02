//
//  TabItem.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 9/7/20.
//

import SwiftUI

struct TabItem: View {
    var title: Text
    var image: Image
    let impact: UIImpactFeedbackGenerator?
    var content: AnyView
    
    init<Content>(title: String, imageName: String, impact: UIImpactFeedbackGenerator? = nil, @ViewBuilder _ content: () -> Content) where Content: View {
        self.title = Text(title)
        self.image = Image(systemName: imageName)
        self.content = content().asAny()
        self.impact = impact
    }
    
    var body: some View {
        Button(action: {
            impact?.impactOccurred()
        }) {
            content
        }
    }
}

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
                            .padding()
                        
                        Circle()
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
            }
        }
        .environmentObject(SettingsController())
    }
}
