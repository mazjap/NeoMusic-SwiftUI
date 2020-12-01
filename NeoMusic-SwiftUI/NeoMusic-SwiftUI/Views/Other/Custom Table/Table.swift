//
//  Table.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/30/20.
//

import SwiftUI

struct Table: View {
    @Environment(\.cellSpacing) private var spacing: CGFloat
    let sections: [TableSection]
    
    init(@TableBuilder _ sections: () -> [TableSection]) {
        self.sections = sections()
    }
    
    var body: some View {
        ScrollView {
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
    func spacing(_ amount: CGFloat) -> some View {
        self
            .environment(\.cellSpacing, amount)
    }
}

private struct TableSpacing: EnvironmentKey {
    static let defaultValue: CGFloat = 10
}

extension EnvironmentValues {
    var cellSpacing: CGFloat {
        get { self[TableSpacing.self] }
        set { self[TableSpacing.self] = newValue }
    }
}
