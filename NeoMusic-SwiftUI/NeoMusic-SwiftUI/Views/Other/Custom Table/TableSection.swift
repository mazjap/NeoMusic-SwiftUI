//
//  TableSection.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/30/20.
//

import SwiftUI

struct TableSection: View {
    
    @Environment(\.cellSpacing) private var spacing: CGFloat
    let title: String?
    var isEmpty: Bool {
        return content.isEmpty
    }
    private let content: [AnyView]
    
    init(title: String? = nil, @TableSectionBuilder _ content: () -> [AnyView]) {
        self.init(title: title, children: content())
    }
    
    fileprivate init(title: String?, children: [AnyView]) {
        self.title = title
        self.content = children
    }
    
    var body: some View {
        Group {
            ForEach(0..<content.count) { i in
                content[i]
                    .padding(.bottom, spacing)
            }
        }
    }
}

struct TableSection_Previews: PreviewProvider {
    static var previews: some View {
        TableSection(title: "Example") {
            Text("Cell")
        }
    }
}

@_functionBuilder
struct TableSectionBuilder {
    static func buildBlock<Content>(_ children: Content...) -> [AnyView] where Content: View {
        children.map { $0.asAny() }
    }
}

extension TableBuilder {
    static func buildBlock<Content>(_ children: Content...) -> [TableSection] where Content: View {
        [TableSection(title: nil, children: children.map { $0.asAny() })]
    }
}
