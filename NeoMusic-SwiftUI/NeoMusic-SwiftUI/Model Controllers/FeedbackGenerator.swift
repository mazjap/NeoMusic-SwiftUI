//
//  FeedbackGenerator.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/12/20.
//

import SwiftUI
import CoreHaptics

class FeedbackGenerator: ObservableObject {
    
    // MARK: - Variables
    
    private var engine: CHHapticEngine?
    
    lazy var toggleHaptic: CHHapticPatternPlayer? = {
        
        
        return try? engine?.makePlayer(with: CHHapticPattern(events: [], parameterCurves: []))
    }()
    
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
        
        if let e = try? CHHapticEngine() {
            engine = e
        }
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
}
