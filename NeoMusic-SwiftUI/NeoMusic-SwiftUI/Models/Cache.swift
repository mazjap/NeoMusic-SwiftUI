//
//  Cache.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/1/20.
//

import Foundation

class Cache<Key, Value> where Key: Hashable {
    
    // MARK: - Variables
    
    private var dictionary = Dictionary<Key, Value>()
    private let queue = DispatchQueue(label: "com.mazjap.NeoMusic-SwiftUI.Cache.Queue")
    
    // MARK: - Functions
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.dictionary[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { dictionary[key] }
    }
    
    func clear() {
        queue.async {
            self.dictionary.removeAll()
        }
    }
}
