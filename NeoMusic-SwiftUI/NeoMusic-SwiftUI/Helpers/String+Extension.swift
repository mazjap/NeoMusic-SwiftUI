import Foundation

extension String {
    var hexToInt: Int? {
        return Int(self, radix: 16)
    }
}
