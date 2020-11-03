//
//  UIApplication+Extension.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/2/20.
//

import SwiftUI

extension UIApplication {
    var keyWindow: UIWindow? {
        windows.filter { $0.isKeyWindow }.first
    }
    
    var currentVC: UIViewController? {
        keyWindow?.rootViewController
    }
    
    func endEditing(_ force: Bool) {
        keyWindow?.endEditing(force)
    }
    
    static func present(_ alert: UIAlertController, animated: Bool) {
        Self.shared.currentVC?.present(alert, animated: animated)
    }
    
    func setHostingController<Content: View>(rootView: Content) {
        keyWindow?.rootViewController = HostingController(rootView: rootView)
    }
    
    func setNeedsStatusBarAppearanceUpdate() {
        currentVC?.setNeedsStatusBarAppearanceUpdate()
    }
}
