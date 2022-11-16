import SwiftUI

class HostingController<Content>: UIHostingController<Content> where Content: View {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        SettingsController.shared.colorScheme.textColor.color.perceivedBrightness >= 0.6 ? .lightContent : .darkContent
    }
}
