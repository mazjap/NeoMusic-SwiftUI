//
//  TableSection.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/30/20.
//

import SwiftUI

struct TableSection: View {
    @Environment(\.cellSpacing) private var spacing: CGFloat
    @Environment(\.section) private var section: Int
    
    @Binding private var indexPath: IndexPath
    
    let title: String?
    
    var seperator: AnyView?
    
    var isEmpty: Bool {
        return content.isEmpty
    }
    
    private let content: [AnyView]
    
    init(title: String? = nil, selectedIndex: Binding<IndexPath> = .init(get: {return .zero}, set: { _ in }), @TableSectionBuilder _ content: () -> [AnyView]) {
        self.init(title: title, children: content(), selectedIndex: selectedIndex)
    }
    
    fileprivate init(title: String?, children: [AnyView], seperator: AnyView? = nil, selectedIndex: Binding<IndexPath> = .init(get: {return .zero}, set: { _ in })) {
        self.title = title
        self.content = children
        self.seperator = seperator
        self._indexPath = selectedIndex
    }
    
    var body: some View {
        Group {
            ForEach(0..<content.count) { i in
                content[i]
                    .tag(i)
                    .padding(.bottom, spacing)
                    .onTapGesture {
                        itemChanged(to: i)
                    }
                
                if let seperator = seperator {
                    seperator
                        .padding(.vertical, 0)
                        .padding(.horizontal, Constants.spacing)
                }
            }
        }
    }
    
    func itemChanged(to val: Int) {
        indexPath = IndexPath(item: val, section: section)
    }
}

struct TableSection_Previews: PreviewProvider {
    static var previews: some View {
        TableSection(title: "Example") {
            Text("Cell")
        }
    }
}

@resultBuilder
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
    func section(_ section: Int) -> some View {
        self.environment(\.section, section)
    }
    
    func seperator<Content>(_ view: Content?) -> some View where Content: View {
        TableSection(title: title, children: content, seperator: view.asAny())
    }
}

private struct SectionKey: EnvironmentKey {
    static let defaultValue: Int = 0
}

private struct SectionSeperatorKey: EnvironmentKey {
    static let defaultValue: AnyView? = nil
}

extension EnvironmentValues {
    var section: Int {
        get { self[SectionKey.self] }
        set { self[SectionKey.self] = newValue }
    }
}
