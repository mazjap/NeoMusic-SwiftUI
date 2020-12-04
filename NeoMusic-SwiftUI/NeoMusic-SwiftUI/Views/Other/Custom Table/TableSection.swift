//
//  TableSection.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/30/20.
//

import SwiftUI

struct TableSection: View {
    @Environment(\.cellSpacing) private var spacing: CGFloat
    @Environment(\.action) private var action: (Int) -> Void
    
    let title: String?
    
    var seperator: AnyView?
    
    var isEmpty: Bool {
        return content.isEmpty
    }
    
    private let content: [AnyView]
    
    init(title: String? = nil, @TableSectionBuilder _ content: () -> [AnyView]) {
        self.init(title: title, children: content())
    }
    
    fileprivate init(title: String?, children: [AnyView], seperator: AnyView? = nil) {
        self.title = title
        self.content = children
        self.seperator = seperator
    }
    
    var body: some View {
        Group {
            ForEach(0..<content.count) { i in
                content[i]
                    .padding(.bottom, spacing)
                    .onTapGesture {
                        action(i)
                    }
                
                if let seperator = seperator {
                    seperator
                        .padding(.vertical, 0)
                        .padding(.horizontal, Constants.spacing)
                }
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
        [TableSection(title: "", children: children.map { $0.asAny() })]
    }
}


extension TableSection {
    func action(_ action: @escaping (Int) -> Void) -> some View {
        self.environment(\.action, action)
    }
    
    func seperator<Content>(_ view: Content?) -> TableSection where Content: View {
        TableSection(title: title, children: content, seperator: view.asAny())
    }
}

private struct SectionAction: EnvironmentKey {
    static let defaultValue: (Int) -> Void = { _ in }
}

private struct SectionSeperator: EnvironmentKey {
    static let defaultValue: AnyView? = nil
}

extension EnvironmentValues {
    var action: (Int) -> Void {
        get { self[SectionAction.self] }
        set { self[SectionAction.self] = newValue }
    }
}
