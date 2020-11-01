//
//  SearchBar.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 9/30/20.
//

import SwiftUI

struct SearchBar: View {
    // MARK: - State
    @State private var isEditing = false
    
    @Binding var searchText: String
    
    // MARK: - Variables
    
    let font: Font?
    var colorScheme: JCColorScheme
    
    let onEditingChanged: (Bool) -> Void
    let onCommit: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(colorScheme.backgroundGradient.first)
                .neumorph(color: colorScheme.backgroundGradient.first, size: .button)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(colorScheme.textColor.color)
                    .padding(.leading, 8)
                
                ZStack(alignment: .leading) {
                    if searchText.isEmpty {
                        Text("Search")
                            .font(font ?? .footnote)
                            .foregroundColor(colorScheme.textColor.color)
                    }
                    
                    TextField("", text: $searchText, onEditingChanged: onEditingChanged, onCommit: onCommit)
                        .font(font ?? .callout)
                        .foregroundColor(colorScheme.textColor.color)
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

// MARK: - Preview

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        let text = Binding<String> { () -> String in
            return ""
        } set: { str in
            print(str)
        }
        
        SearchBar(searchText: text, font: nil, colorScheme: .default, onEditingChanged: { _ in }, onCommit: {})
            .previewLayout(PreviewLayout.fixed(width: 300, height: 50))
    }
}
