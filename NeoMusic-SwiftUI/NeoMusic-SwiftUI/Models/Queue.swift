//
//  Queue.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/2/20.
//
//  Purpose:
//  An advanced Queue that uses a LinkedList to store data
//

import Foundation

// MARK: - QueueDelegate

protocol QueueDelegate: AnyObject {
    func queueWillChange()
    func queueDidPush()
    func queueDidPushToFront()
    func queueDidPop()
    func queueWasRead()
    func queueDidClear()
}

// MARK: - QueueDelegate Extension
// Default implementations so that no implementation is required when conforming to QueueDelegate
extension QueueDelegate {
    func queueWillChange() {}
    func queueDidPush() {}
    func queueDidPushToFront() {}
    func queueDidPop() {}
    func queueWasRead() {}
    func queueDidClear() {}
}

// MARK: - Queue

struct Queue<Type>: CustomStringConvertible {
    static func + (lhs: Queue<Type>, rhs: Queue<Type>) -> Queue<Type> {
        return Queue(lhs.arr + rhs.arr)
    }
    
    
    // MARK: - Variables
    
    var description: String {
        "\(arr)"
    }
    
    // Weak to avoid strong reference cycle
    weak var delegate: QueueDelegate?
    
    // Computed variable of type Array<Type> for convenience
    var arr: [Type] {
        var tmp = [Type]()
        var node = head
        
        while let val = node?.value {
            tmp.append(val)
            node = node?.next
        }
        
        return tmp
    }
    
    var count: Int {
        if var node = head {
            var temp = 1
            while let next = node.next {
                node = next
                temp += 1
            }
            
            return temp
        } else {
            return 0
        }
    }
    
    private var head: Node<Type>?
    
    // MARK: - Initializers
    
    init(_ vals: [Type]? = nil) {
        if let vals = vals, !vals.isEmpty {
            var node = Node(vals[0])
            self.head = node
            
            for i in 1..<vals.count {
                let newNode = Node(vals[i])
                node.next = newNode
                node = newNode
            }
        } else {
            self.head = nil
        }
    }
    
    subscript(_ index: Int) -> Type {
        var count = 0
        var node = head
        
        while count < index {
            node = node?.next
            count += 1
        }
        
        guard let end = node else { fatalError("Error, index out of bounds") }
        
        return end.value
    }
    
    // MARK: - Functions
    
    func read() -> Type? {
        delegate?.queueWasRead()
        
        return head?.value
    }
    
    func readLast() -> Type? {
        var node = head
        
        while node?.next != nil {
            node = node?.next
        }
        
        delegate?.queueWasRead()
        
        return node?.value
    }
    
    // MARK: - Mutating Functions
    
    mutating func pushToFront(_ val: Type) {
        self.pushToFront([val])
    }
    
    mutating func pushToFront(_ vals: [Type]) {
        guard !vals.isEmpty else { return }
        
        delegate?.queueWillChange()
        
        let oldHead = head
        let newHead = Node(vals[0])
        var node: Node<Type>? = newHead
        
        for i in 1..<vals.count {
            node?.next = Node(vals[i])
            node = node?.next
        }
        
        node?.next = oldHead
        head = newHead
        
        delegate?.queueDidPushToFront()
    }
    
    mutating func push(_ val: Type) {
        push([val])
    }
    
    mutating func push(_ vals: [Type]) {
        guard !vals.isEmpty else { return }
        
        delegate?.queueWillChange()
        
        var didUseFirst = false
        
        if head == nil {
            head = Node(vals[0])
            didUseFirst = true
        }
        
        var node = head
        
        while node?.next != nil {
            node = node?.next
        }
        
        for i in (didUseFirst ? 1 : 0)..<vals.count {
            node?.next = Node(vals[i])
            node = node?.next
        }
        
        delegate?.queueDidPush()
    }
    
    @discardableResult
    mutating func pop() -> Type? {
        delegate?.queueWillChange()
        
        let value = head?.value
        head = head?.next
        
        delegate?.queueDidPop()
        
        return value
    }
    
    @discardableResult
    mutating func pop(_ count: Int) -> [Type] {
        delegate?.queueWillChange()
        
        var node = head
        var tmp = [Type]()
        
        for _ in 0..<count {
            if let n = node {
                tmp.append(n.value)
                node = n.next
            } else {
                break
            }
        }
        
        head = node
        
        delegate?.queueDidPop()
        
        return tmp
    }
    
    mutating func clear() {
        delegate?.queueWillChange()
        
        head = nil
        
        delegate?.queueDidClear()
    }
}

// MARK: - Queue Extension: Singly LinkedList

extension Queue {
    class Node<Type> {
        var next: Node<Type>?
        var value: Type
        
        init(_ val: Type) {
            self.value = val
        }
    }
}
