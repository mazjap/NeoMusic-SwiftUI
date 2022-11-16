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
    
    func setNeedsStatusBarAppearanceUpdate() {
        Self.hostingVC?.setNeedsStatusBarAppearanceUpdate()
    }
    
    static private weak var hostingVC: HostingController<AnyView>?
}
