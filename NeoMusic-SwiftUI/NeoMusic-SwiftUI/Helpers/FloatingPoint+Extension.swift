//
//  FloatingPoint+Extension.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/28/20.
//
//  Purpose:
//  Convert to and from radians and degrees easily
// 

import Foundation

extension FloatingPoint {
    var toRadians: Self { return self * .pi / 180 }
    var toDegrees: Self { return self * 180 / .pi }
}
