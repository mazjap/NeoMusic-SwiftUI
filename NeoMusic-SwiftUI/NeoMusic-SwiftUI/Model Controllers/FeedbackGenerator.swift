//
//  FeedbackGenerator.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/12/20.
//

import SwiftUI

class FeedbackGenerator: ObservableObject {
    
    // MARK: - Variables
    
    private var feedbackEnabled: Bool {
        didSet {
            if feedbackEnabled {
                nfg.notificationOccurred(.success)
            }
        }
    }
    
    private let nfg: UINotificationFeedbackGenerator
    private let ifg: UIImpactFeedbackGenerator
    
    // MARK: - Initializers
    
    init(feedbackEnabled: Bool = true) {
        self.nfg = .init()
        self.ifg = .init()
        self.feedbackEnabled = false
        
        self.feedbackEnabled = feedbackEnabled
    }
    
    // MARK: - Functions
    
    func changeFeedbackEnabledStatus(to status: Bool) {
        self.feedbackEnabled = status
    }
    
    func impactOccurred(intensity: CGFloat = 1) {
        guard feedbackEnabled else { return }
        
        ifg.impactOccurred(intensity: intensity)
    }
    
    func successFeedback() {
        guard feedbackEnabled else { return }
        
        nfg.notificationOccurred(.success)
    }
    
    func errorFeedback() {
        guard feedbackEnabled else { return }
        
        nfg.notificationOccurred(.error)
    }
    
    func warningFeedback() {
        guard feedbackEnabled else { return }
        
        nfg.notificationOccurred(.warning)
    }
    
    func perform(_ type: FeedbackType) {
        switch type {
        case .s:
            successFeedback()
        case .e:
            errorFeedback()
        case .w:
            warningFeedback()
        case .i(let impact):
            impactOccurred(intensity: impact)
        }
    }
}

// MARK: - FeedbackGenerator Extension: FeedbackType

extension FeedbackGenerator {
    enum FeedbackType {
        case s, e, w
        case i(CGFloat)
        
        init?<Type>(_ val: Type) where Type: StringProtocol {
            switch String(val) {
            case "s":
                self = .s
            case "e":
                self = .e
            case "w":
                self = .w
            default:
                return nil
            }
        }
    }
}
