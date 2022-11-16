import SwiftUI

class UIHostingCell<Content>: UITableViewCell where Content: View {
    private var host: UIHostingController<Content>?
    
    func setup(with view: Content) {
        if let host = host {
            host.rootView = view
        } else {
            let controller = UIHostingController(rootView: view)
            host = controller
            
            guard let content = controller.view else { return }
            content.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(content)
            
            content.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            content.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            content.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        }
        
        setNeedsLayout()
    }
}
