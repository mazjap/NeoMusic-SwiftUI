//
//  Table.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/30/20.
//

import SwiftUI

struct Table: View {
    @Environment(\.cellSpacing) private var cellSpacing: CGFloat
    @Environment(\.usesSeperator) private var usesSeperator: Bool
    @Environment(\.showsScrollingIndicator) private var showsScrollingIndicator: Bool
    
    
    @Binding private var indexPath: IndexPath
    
    private let _spacing: CGFloat?
    private let _usesSep: Bool?
    private let _showIndicator: Bool?
    
    private var seperator: AnyView = {
        Color.falseWhite
            .spacing(.horizontal)
            .frame(height: 1)
            .asAny()
    }()
    
    private let sections: [TableSection]
    
    private var space: CGFloat {
        if let space = _spacing {
            return space
        }
        
        return cellSpacing
    }
    
    private var useSeperator: Bool {
        if let usesSep = _usesSep {
            return usesSep
        }
        
        return usesSeperator
    }
    
    private var showsIndicator: Bool {
        if let showIndicator = _showIndicator {
            return showIndicator
        }
        
        return showsScrollingIndicator
    }
    
    init(seperatorView: AnyView? = nil, selectedIndexPath: Binding<IndexPath> = .init(get: { return .zero }, set: { _ in }), @TableBuilder _ sections: () -> [TableSection]) {
        self.init(seperatorView: seperatorView, selectedIndexPath: selectedIndexPath, sections: sections())
    }
    
    private init(seperatorView: AnyView? = nil, selectedIndexPath: Binding<IndexPath> = .init(get: { return .zero }, set: { _ in }), sections: [TableSection], spacing: CGFloat? = nil, usesSeperator: Bool? = nil, showsScrollingIndicator: Bool? = nil) {
        self._indexPath = selectedIndexPath
        self.sections = sections
        
        if let sep = seperatorView {
            self.seperator = sep
        }
        
        self._spacing = spacing
        self._usesSep = usesSeperator
        self._showIndicator = showsScrollingIndicator
    }
    
    var list: List = List {
        Text("")
    }
    
    var body: some View {
        ScrollView(showsIndicators: showsIndicator) {
            LazyVStack {
                ForEach(0..<sections.count) { i in
                    HStack {
                        if !sections[i].isEmpty {
                            Text(sections[i].title ?? "")
                                .spacing(.leading)
                        }

                        Spacer()
                    }
                    
                    sections[i]
                        .seperator(usesSeperator ? seperator : nil)
                        .action { j in
                            self.indexPath = IndexPath(item: j, section: i)
                        }
                }
            }
        }
    }
}

struct Table_Previews: PreviewProvider {
    static var previews: some View {
        Table {
            TableSection(title: "Example") {
                Text("This is a cell")
            }
        }
    }
}

@_functionBuilder
struct TableBuilder {
    static func buildBlock(_ children: TableSection...) -> [TableSection] {
        children
    }
}

extension Table {
    func cellSpacing(_ amount: CGFloat) -> Table {
        Table(seperatorView: seperator, selectedIndexPath: $indexPath, sections: sections, spacing: amount, usesSeperator: _usesSep, showsScrollingIndicator: _showIndicator)
    }
    
    func usesSeperator(_ bool: Bool) -> Table {
        Table(seperatorView: seperator, selectedIndexPath: $indexPath, sections: sections, spacing: _spacing, usesSeperator: bool, showsScrollingIndicator: _showIndicator)
    }
    
    func showsScrollingIndicator(_ bool: Bool) -> Table {
        Table(seperatorView: seperator, selectedIndexPath: $indexPath, sections: sections, spacing: _spacing, usesSeperator: _usesSep, showsScrollingIndicator: bool)
    }
}

private struct TableSpacing: EnvironmentKey {
    static let defaultValue: CGFloat = 10
}

private struct TableUsesSeperator: EnvironmentKey {
    static let defaultValue: Bool = false
}

private struct TableShowsScrollingIndicator: EnvironmentKey {
    static let defaultValue: Bool = true
}

extension EnvironmentValues {
    var cellSpacing: CGFloat {
        get { self[TableSpacing.self] }
        set { self[TableSpacing.self] = newValue }
    }
    
    var usesSeperator: Bool {
        get { self[TableUsesSeperator.self] }
        set { self[TableUsesSeperator.self] = newValue }
    }
    
    var showsScrollingIndicator: Bool {
        get { self[TableShowsScrollingIndicator.self] }
        set { self[TableShowsScrollingIndicator.self] = newValue }
    }
}
