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

struct Queue<Type>: CustomStringConvertible {
    
    // MARK: - Variables
    
    var description: String {
        "\(arr)"
    }
    
    // Computed var of type Array<Type> for convinience
    var arr: [Type] {
        var tmp = [Type]()
        var node = head
        
        while let val = node?.value {
            tmp.append(val)
            node = node?.next
        }
        
        return tmp
    }
    
    private var head: Node<Type>?
    
    // MARK: - Initializer
    
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
    
    // MARK: - Functions
    
    func read() -> Type? {
        return head?.value
    }
    
    func readLast() -> Type? {
        var node = head
        
        while node?.next != nil {
            node = node?.next
        }
        
        return node?.value
    }
    
    // MARK: - Mutating Functions
    
    mutating func pushToFront(_ val: Type) {
        self.pushToFront([val])
    }
    
    mutating func pushToFront(_ vals: [Type]) {
        guard !vals.isEmpty else { return }
        
        let oldHead = head
        let newHead = Node(vals[0])
        var node: Node<Type>? = newHead
        
        for i in 1..<vals.count {
            node?.next = Node(vals[i])
            node = node?.next
        }
        
        node?.next = oldHead
        head = newHead
    }
    
    mutating func push(_ val: Type) {
        push([val])
    }
    
    mutating func push(_ vals: [Type]) {
        guard !vals.isEmpty else { return }
        
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
    }
    
    @discardableResult
    mutating func pop() -> Type? {
        let value = head?.value
        head = head?.next
        return value
    }
    
    @discardableResult
    mutating func pop(_ count: Int) -> [Type] {
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
        return tmp
    }
}

// MARK: - Queue Extension: LinkedList

extension Queue {
    class Node<Type> {
        var next: Node<Type>?
        var value: Type
        
        init(_ val: Type) {
            self.value = val
        }
    }
}
