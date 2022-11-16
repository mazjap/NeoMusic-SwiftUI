import Foundation

class Cache<Key, Value> where Key: Hashable {
    
    // MARK: - Variables
    
    private var dictionary = Dictionary<Key, Value>()
    private let queue: DispatchQueue
    
    // MARK: - Initializers
    
    init() {
        self.queue = DispatchQueue(label: "com.mazjap.NeoMusic-SwiftUI.Cache.Queue\(Constants.cacheNumber)", qos: .utility)
    }
    
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
