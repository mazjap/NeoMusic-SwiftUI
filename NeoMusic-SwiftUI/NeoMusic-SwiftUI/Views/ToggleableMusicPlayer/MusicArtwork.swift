//
//  MusicArtwork.swift
//  NeoMusic-SwiftUI
//
//  Created by Jordan Christensen on 8/25/20.
//
//  Purpose:
//  Circle containing song artwork image, rotatable
//

import SwiftUI

struct MusicArtwork: View {
    
    // MARK: - State
    
    @EnvironmentObject private var feedback: FeedbackGenerator
    
    @Binding private var previousRotation: Double
    
    @State private var rotation: Double = 0
    @State private var isDragging: Bool = false
    @State private var startRotationAngle: Double = 0
    
    // MARK: - Variables
    private let colorScheme: JCColorScheme
    private let image: Image
    private let size: NeumorphSize
    
    // MARK: - Initializers
    
    init(colorScheme: JCColorScheme, image: Image, rotation: Binding<Double>, size: NeumorphSize = .artwork) {
        self._previousRotation = rotation
        self.colorScheme = colorScheme
        self.image = image
        self.size = size
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: colorScheme.backgroundGradient.colors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                .clipShape(Circle())
                .neumorph(color: colorScheme.backgroundGradient.first.average(to: colorScheme.backgroundGradient.last), size: size)
                .overlay(
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geometry.size.width * 0.975, height: geometry.size.height * 0.975)
                .clipShape(Circle())
                .contentShape(Circle())
                .rotationEffect(.radians(isDragging ? rotation : previousRotation))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let circleCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            
                            let location = value.location
                            
                            if !isDragging {
                                isDragging = true
                                feedback.impactOccurred()
                                startRotationAngle = angle(from: circleCenter, to: location)
                            }
                            
                            rotation = angle(from: circleCenter, to: location) - startRotationAngle + previousRotation
                        }
                        .onEnded { value in
                            feedback.impactOccurred()
                            
                            previousRotation = rotation
                            rotation = 0
                            
                            isDragging = false
                        }
                )
            )
        }
    }
    
    // MARK: - Functions
    
    private func angle(from center: CGPoint, to location: CGPoint) -> Double {
        return Double(atan2(location.y - center.y, location.x - center.x))
    }
    
    private func reducedRadian<T: BinaryFloatingPoint>(_ val: T) -> Double {
        var radians = val
        
        let mult = radians / 2 * .pi
        
        if mult > 1 {
            radians -= mult * 2 * .pi
        }
        
        while radians < 0 {
            radians += 2 * .pi
        }
        
        return Double(radians)
    }
}

// MARK: - Preview

struct Artwork_Previews: PreviewProvider {
    @State static var rotation: Double = 0
    
    static var previews: some View {
        MusicArtwork(colorScheme: .default, image: .placeholder, rotation: $rotation)
            .spacing()
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
