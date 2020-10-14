//
//  HostingController.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/13/20.
//

import SwiftUI

class HostingController<Content>: UIHostingController<Content> where Content: View {
    let prefersLightMode: Bool
    
    init(textColor: Color, rootView: Content) {
        self.prefersLightMode = textColor.perceivedBrightness >= 0.5
        
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        self.prefersLightMode = true
        
        super.init(coder: aDecoder)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if prefersLightMode {
            return .lightContent
        }
        
        return .darkContent
    }
}
