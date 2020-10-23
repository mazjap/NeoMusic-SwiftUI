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
    
    @Binding private var rotation: Double
    @State private var isDragging: Bool = false
    @State private var startRotationAngle: Double = 0
    
    // MARK: - Variables
    private let colorScheme: JCColorScheme
    private let image: Image
    private let size: Neumorph.Size
    
    // MARK: - Initializer
    
    init(colorScheme: JCColorScheme, image: Image, rotation: Binding<Double>, size: Neumorph.Size = .artwork) {
        self._rotation = rotation
        self.colorScheme = colorScheme
        self.image = image
        self.size = size
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: colorScheme.backgroundGradient.colors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .neumorph(color: colorScheme.backgroundGradient.first.average(to: colorScheme.backgroundGradient.last), size: size)
                
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 0.975, height: geometry.size.height * 0.975)
                    .clipShape(Circle())
                    .rotationEffect(.radians(rotation))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let location = value.location
                                let circleCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                let gestureRotation = angle(from: circleCenter, to: location) - startRotationAngle
                                
                                if !isDragging {
                                    feedback.impactOccurred()
                                    isDragging = true
                                    startRotationAngle = angle(from: circleCenter, to: location)
                                }
                                
                                rotation = gestureRotation
                            }
                            .onEnded { value in
                                feedback.impactOccurred()
                                
                                let circleCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                
                                let gestureRotation = angle(from: circleCenter, to: value.location) - startRotationAngle
                                
                                isDragging = false
                                rotation = gestureRotation
                            }
                    )
            }
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
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
