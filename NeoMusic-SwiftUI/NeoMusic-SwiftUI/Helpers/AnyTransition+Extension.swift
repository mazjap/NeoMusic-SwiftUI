//
//  AnyTransition+Extension.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 12/28/20.
//

import SwiftUI

extension AnyTransition {
    static var scaleAndSlide = Self.slide.combined(with: .scale)
}
