//
//  String+Extension.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 10/2/20.
//

import Foundation

extension String {
    var hexToInt: Int? {
        return Int(self, radix: 16)
    }
}
