//
//  MessageController.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/5/20.
//

import Foundation

class MessageController: ObservableObject {
    private var queue = Queue<Message>()
    
    @Published var message: Message? {
        didSet {
            guard message != nil else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                guard let self = self else { return }
                self.queue.pop()
            }
        }
    }
    
    private init() {
        queue.delegate = self
    }
    
    func display(text: String) {
        let msg = Message(value: text, type: .message)
        queue.push(msg)
        
        if message == nil {
            message = queue.read()
        }
    }
    
    func display(error: Error) {
        let msg = Message(value: error.localizedDescription, type: .error)
        queue.push(msg)
        
        if message == nil {
            message = queue.read()
        }
    }
    
    static let shared = MessageController()
}

extension MessageController: QueueDelegate {
    func queueDidPop() {
        DispatchQueue.main.async {
            self.message = self.queue.read()
        }
    }
}
