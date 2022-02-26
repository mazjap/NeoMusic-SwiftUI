//
//  Binding+Extension.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 11/24/20.
//

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

