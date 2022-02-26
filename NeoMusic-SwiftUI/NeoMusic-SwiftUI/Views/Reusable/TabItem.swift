//
//  TabItem.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 9/7/20.
//

import SwiftUI

struct TabItem<Content>: View where Content: View {
    var title: Text
    var image: Image
    var content: () -> Content
    
    init(title: String, imageName: String, content: @escaping () -> Content) {
        self.title = Text(title)
        self.image = Image(systemName: imageName)
        self.content = content
    }
    
    var body: some View {
        content()
    }
}

struct TabItem_Previews: PreviewProvider {
    static var previews: some View {
        TabItem(title: "Music", imageName: "play.fill") {
            Text("Hello")
        }
    }
}
