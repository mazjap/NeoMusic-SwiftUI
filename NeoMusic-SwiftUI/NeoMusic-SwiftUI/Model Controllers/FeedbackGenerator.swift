//
//  FeedbackGenerator.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/12/20.
//

import SwiftUI

class FeedbackGenerator: ObservableObject {
    var feedbackEnabled: Bool
    
    let nfg: UINotificationFeedbackGenerator
    let ifg: UIImpactFeedbackGenerator
    
    init(feedbackEnabled: Bool) {
        self.feedbackEnabled = feedbackEnabled
        self.nfg = .init()
        self.ifg = .init()
        
        nfg.notificationOccurred(.success)
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
