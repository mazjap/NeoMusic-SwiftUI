import SwiftUI

extension Binding {
    func onChanged(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding {
            self.wrappedValue
        } set: { newVal in
            self.wrappedValue = newVal
            handler(newVal)
        }
    }
    
    init(_ defaultValue: Value) {
        self.init {
            defaultValue
        } set: { _ in }
    }
}

