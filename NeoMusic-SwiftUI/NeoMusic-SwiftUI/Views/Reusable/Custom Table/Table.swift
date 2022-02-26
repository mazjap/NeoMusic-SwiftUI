//
//  Table.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/30/20.
//

import SwiftUI

protocol TableDataItem {
    init(index: Int)

    var dataIsFetched: Bool { get }

    func fetchData()
}
//
protocol TableRowItem: View {
    associatedtype Item: TableDataItem

    init(item: Item)

    var item: Item { get }
}
//
//struct MyTable<Row>: View where Row: TableRowItem {
//    @ObservedObject var controller: TableController<Row.Item>
//
//    let showsScrollIndicator: Bool
//
//    init(controller: TableController<Row.Item>, showsScrollIndicator: Bool = false) {
//        self.controller = controller
//        self.showsScrollIndicator = showsScrollIndicator
//    }
//
//    var body: some View {
//        LazyVStack {
//            ForEach(0..<controller.list.count) { index in
//                Row(item: controller.list[index])
//                    .onAppear {
//                        controller.fetchMoreItemsIfNeeded(currentIndex: index)
//                    }
//            }
//        }
//        .id(controller.listID)
//    }
//}
//
//
//class ItemThing: TableDataItem {
//    var dataIsFetched = false
//
//    func fetchData() {
//        self.dataIsFetched = true
//    }
//}
//
//
//struct RowItem: TableRowItem {
//    var item: ItemThing
//
//    var body: some View {
//        Color.red
//    }
//}

struct Table: View {
    @Binding private var indexPath: IndexPath
    
    private let _spacing: CGFloat?
    private let _usesSep: Bool?
    private let _showIndicator: Bool?
    private let _tableCornerRadius: CGFloat?
    
    
    private var seperator: AnyView = {
        Color.falseWhite
            .spacing(.horizontal)
            .frame(height: 1)
            .asAny()
    }()
    
    private let sections: [TableSection]
    
    var usesSeperator: Bool {
        return _usesSep ?? false
    }
    
    var showsIndicator: Bool {
        return _showIndicator ?? true
    }
    
    var tableCornerRadius: CGFloat {
        return _tableCornerRadius ?? 0
    }
    
    init(seperatorView: AnyView? = nil, selectedIndexPath: Binding<IndexPath> = .init(get: { return .zero }, set: { _ in }), @TableBuilder _ sections: () -> [TableSection]) {
        self.init(seperatorView: seperatorView, selectedIndexPath: selectedIndexPath, sections: sections())
    }
    
    private init(seperatorView: AnyView? = nil, selectedIndexPath: Binding<IndexPath> = .init(get: { return .zero }, set: { _ in }), sections: [TableSection], spacing: CGFloat? = nil, usesSeperator: Bool? = nil, showsScrollingIndicator: Bool? = nil, cornerRadius: CGFloat? = nil) {
        self._indexPath = selectedIndexPath
        self.sections = sections
        
        if let sep = seperatorView {
            self.seperator = sep
        }
        
        self._spacing = spacing
        self._usesSep = usesSeperator
        self._showIndicator = showsScrollingIndicator
        self._tableCornerRadius = cornerRadius
    }
    
    var body: some View {
        Text("Hello, World!")
//        ScrollView(showsIndicators: showsIndicator) {
//            VStack {
//                ForEach(0..<sections.count) { i in
//                        HStack {
//                            if !sections[i].isEmpty {
//                                Text(sections[i].title ?? "")
//                                    .spacing(.leading)
//                            }
//
//                            Spacer()
//                        }
//
//                        sections[i]
//                            .seperator(usesSeperator ? seperator : nil)
//                            .section(i)
//                }
//            }
//        }
    }
}

struct Table_Previews: PreviewProvider {
    static var previews: some View {
        Table {
            TableSection(title: "Example", selectedIndex: .init(get: { return .zero }, set: { _ in })) {
                Text("This is a cell")
            }
        }
    }
}

@resultBuilder
struct TableBuilder {
    static func buildBlock(_ children: TableSection...) -> [TableSection] {
        children
    }
    
    static func buildBlock<Row>(_ children: Row...) -> [Row] where Row: TableRowItem {
        children
    }
}

extension View {
    func cellSpacing(_ amount: CGFloat) -> some View {
        self
            .environment(\.cellSpacing, amount)
    }
    
    func usesSeperator(_ bool: Bool) -> some View {
        self
            .environment(\.usesSeperator, bool)
    }
    
    func showsScrollingIndicator(_ bool: Bool) -> some View {
        self
            .environment(\.showsScrollingIndicator, bool)
    }
    
    func tvCornerRadius(_ radius: CGFloat) -> some View {
        self
            .environment(\.cornerRadius, radius)
    }
}

private struct TableSpacing: EnvironmentKey {
    static let defaultValue: CGFloat = 10
}

private struct TableCornerRadius: EnvironmentKey {
    static let defaultValue: CGFloat = 0
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
    
    var cornerRadius: CGFloat {
        get { self[TableCornerRadius.self] }
        set { self[TableCornerRadius.self] = newValue }
    }
}



//func quiakeInverseSqrt(n: Float) -> Float {
//    var i: UInt32
//    var x2: Float
//    var y: Float
//
//    x2 = n * 0.5
//    y = n
//    i = unsafeBitCast(y, to: UInt32.self)
//    i = 0x5f3759df - (i >> 1)
//    y = Float(bitPattern: i)
//    y = y * (1.5 - (x2 * y * y))
//
//    return y
//}


//struct MemoryAddress<T>: CustomStringConvertible {
//    var description: String {
//        let length = 2 * MemoryLayout<UnsafeRawPointer>.size + 2
//        return String(format: "%0\(length)p", intValue)
//    }
//
//    let intValue: Int
//
//    init(_ strct: UnsafePointer<T>) {
//        intValue = Int(bitPattern: strct)
//    }
//}
//
//extension MemoryAddress where T: AnyObject {
//    init(_ clss: T) {
//        intValue = Unmanaged.passUnretained(clss).toOpaque()
//    }
//}
