//
//  HostingController.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/13/20.
//

import SwiftUI

class HostingController<Content>: UIHostingController<Content> where Content: View {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        SettingsController.shared.colorScheme.textColor.color.perceivedBrightness >= 0.5 ? .lightContent : .darkContent
    }
}

