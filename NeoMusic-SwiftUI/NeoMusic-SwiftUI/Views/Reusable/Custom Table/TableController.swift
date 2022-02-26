//
//  TableController.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/30/20.
//

import SwiftUI

class TableController<Item>: ObservableObject where Item: TableRowItem {
    @Published var list: [Item] = []
    
    private(set) var listID: UUID = UUID()
    
    private let itemBatchSize: Int
    private let prefetchMargin: Int
    
    init(itemBatchCount: Int = 20, prefetchMargin: Int = 3) {
        itemBatchSize = itemBatchCount
        self.prefetchMargin = prefetchMargin
        reset()
    }
    
    func reset() {
        list = []
        listID = UUID()
        fetchMoreItemsIfNeeded(currentIndex: -1)
    }
    
    func fetchMoreItemsIfNeeded(currentIndex: Int) {
        guard currentIndex >= list.count - prefetchMargin else { return }
        let startIndex = list.count
//        for currentIndex in startIndex..<max(startIndex + itemBatchSize, currentIndex) {
//            list.append(Item(index: currentIndex))
//            list[currentIndex].fetchData()
//        }
    }
}
