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
    
    func setHostingController<Content>(with view: Content, animate: Bool = false, from prev: LinearGradient? = nil) where Content: View {
        let hostingController: HostingController<AnyView>
        var displayPrev = true
        if animate, let prev = prev {
            hostingController = HostingController(rootView:
                    ZStack {
                        if displayPrev {
                            prev
                        }
                        
                        view.onAppear(
                            perform: {
                                withAnimation {
                                    displayPrev = false
                                }
                            })
                    }.asAny())
        } else {
            hostingController = HostingController(rootView: view.asAny())
        }
        
        keyWindow?.rootViewController = hostingController
        Self.hostingVC = hostingController
    }
    
    func setNeedsStatusBarAppearanceUpdate() {
        Self.hostingVC?.setNeedsStatusBarAppearanceUpdate()
    }
    
    static private weak var hostingVC: HostingController<AnyView>?
}
