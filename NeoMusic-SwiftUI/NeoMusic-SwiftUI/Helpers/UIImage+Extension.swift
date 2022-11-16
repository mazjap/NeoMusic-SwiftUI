import UIKit

extension UIImage {
    static let placeholders: [UIImage] = [
        UIImage(named: "Placeholder1")!,
        UIImage(named: "Placeholder2")!,
        UIImage(named: "Placeholder3")!,
        UIImage(named: "Placeholder4")!,
        UIImage(named: "Placeholder5")!,
        UIImage(named: "Placeholder6")!,
        UIImage(named: "Placeholder7")!
    ].compactMap {
        let height = $0.size.height
        let width = $0.size.width
        
        let size = min(height, width)
        let heightIsLarger = height > width
        
        let frame = CGRect(x: heightIsLarger ? 0 : width / 2 - size / 2, y: heightIsLarger ? height / 2 - size / 2 : 0, width: size, height: size)
        
        if let cg = $0.cgImage?.cropping(to: frame) {
            return UIImage(cgImage: cg)
        }
        
        return nil
    }
    
    static var placeholder: UIImage {
        return placeholders[Int(Date().timeIntervalSince1970) % 1000 / 1000 * placeholders.count]
    }
}
