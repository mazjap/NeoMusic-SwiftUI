//
//  TableView.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/13/21.
//

import SwiftUI

struct TableView<Data, Row>: View where Row: View {
    @Binding private var data: [Data]
    private let content: (Data) -> Row
    
    private var refreshAction: ((() -> Void) -> Void)?
    private var style: UITableView.Style = .plain
    private var allowsMultipleSelection: Bool = true
    private var allowsMultipleSelectionDuringEditing: Bool = true
    private var separatorStyle: UITableViewCell.SeparatorStyle = .none
    
    init(data: Binding<[Data]>, @ViewBuilder row: @escaping (Data) -> Row) {
        self._data = data
        self.content = row
    }
    
    var body: some View {
        UITableViewRepresentable(
            data: $data,
            content: content,
            refreshAction: refreshAction,
            style: style,
            allowsMultipleSelection: allowsMultipleSelection,
            allowsMultipleSelectionDuringEditing: allowsMultipleSelectionDuringEditing,
            separatorStyle: separatorStyle
        )
    }
    
    func style(_ newValue: UITableView.Style) -> Self {
        var copy = self
        copy.style = newValue
        
        return copy
    }
    
    func allowsMultipleSelection(_ newValue: Bool) -> Self {
        var copy = self
        copy.allowsMultipleSelection = newValue
        
        return copy
    }
    
    func allowsMultipleSelectionDuringEditing(_ newValue: Bool) -> Self {
        var copy = self
        copy.allowsMultipleSelectionDuringEditing = newValue
        
        return copy
    }
    
    func separatorStyle(_ newValue: UITableViewCell.SeparatorStyle = .none) -> Self {
        var copy = self
        copy.separatorStyle = newValue
        
        return copy
    }
    
    func refreshable(_ newValue: ((() -> Void) -> Void)? = nil) -> Self {
        var copy = self
        copy.refreshAction = newValue
        
        return copy
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView(data: .init([])) {
            EmptyView()
        }
    }
}
