//
//  UITableViewRepresentable.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/13/21.
//

import SwiftUI

struct UITableViewRepresentable<Data, Row>: UIViewRepresentable where Row: View {
    @Binding private var data: [Data]
    @State private var shouldEndRefreshing = false
    
    private let content: (Data) -> Row
    private let refreshAction: ((() -> Void) -> Void)?
    private let style: UITableView.Style
    private let allowsMultipleSelection: Bool
    private let allowsMultipleSelectionDuringEditing: Bool
    private let separatorStyle: UITableViewCell.SeparatorStyle
    
    init(
        data: Binding<[Data]>,
        @ViewBuilder content: @escaping (Data) -> Row,
        refreshAction: ((() -> Void) -> Void)?,
        style: UITableView.Style,
        allowsMultipleSelection: Bool,
        allowsMultipleSelectionDuringEditing: Bool,
        separatorStyle: UITableViewCell.SeparatorStyle
    ) {
        self._data = data
        self.content = content
        self.refreshAction = refreshAction
        self.style = style
        self.allowsMultipleSelection = allowsMultipleSelection
        self.allowsMultipleSelectionDuringEditing = allowsMultipleSelectionDuringEditing
        self.separatorStyle = separatorStyle
    }
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView(frame: .zero, style: style)
        
        tableView.separatorStyle = separatorStyle
        tableView.allowsMultipleSelection = allowsMultipleSelection
        tableView.allowsMultipleSelectionDuringEditing = allowsMultipleSelectionDuringEditing
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        
        tableView.register(UIHostingCell<Row>.self, forCellReuseIdentifier: Coordinator.cellReuseIdentifier)
        
        updateUIView(tableView, context: context)
        
        return tableView
    }
    
    func updateUIView(_ tableView: UITableView, context: Context) {
        context.coordinator.data = data
        
        if let refreshAction = refreshAction {
            tableView.refreshControl = UIRefreshControl(frame: .zero, primaryAction: UIAction { [weak tableView] _ in
                refreshAction({
                    if let refreshControl = tableView?.refreshControl {
                        shouldEndRefreshing = false
                        refreshControl.endRefreshing()
                    } else {
                        shouldEndRefreshing = true
                    }
                })
            })
        }
        
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(data: data, content: content, refreshAction: refreshAction)
    }
    
    class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource {
        fileprivate var data: [Data]
        private let content: (Data) -> Row
        private let refreshAction: ((() -> Void) -> Void)?
        
        init(data: [Data], content: @escaping (Data) -> Row, refreshAction: ((() -> Void) -> Void)?) {
            self.data = data
            self.content = content
            self.refreshAction = refreshAction
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            data.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath) as? UIHostingCell<Row> else { return UITableViewCell() }
            
            let cellData = data[indexPath.row]
            let cellView = content(cellData)
            
            cell.setup(with: cellView)
            
            return cell
        }
        
        static var cellReuseIdentifier: String { "SwiftUI_cell_reuse_identifier" }
    }
}
