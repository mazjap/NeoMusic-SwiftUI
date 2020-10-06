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
    
    @State private var rotation: Double = 0
    @State private var isDragging: Bool = false
    @State private var startRotationAngle: Double = 0
    
    // MARK: - Variables
    
    private let impact: UIImpactFeedbackGenerator?
    private let colorScheme: ColorScheme
    private let image: Image
    
    // MARK: - Initializer
    
    init(colorScheme: ColorScheme, image: Image, impact: UIImpactFeedbackGenerator? = nil) {
        self.impact = impact
        self.colorScheme = colorScheme
        self.image = image
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: colorScheme.backgroundGradient.colors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .neumorph(color: colorScheme.backgroundGradient.color1.color.average(to: colorScheme.backgroundGradient.color2.color), size: .artwork)
                
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.95)
                    .clipShape(Circle())
                    .rotationEffect(.radians(rotation))
                    .gesture(DragGesture()
                        .onChanged { value in
                            let location = value.location
                            let circleCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            let gestureRotation = angle(from: circleCenter, to: location) - startRotationAngle
                            
                            if !isDragging {
                                impact?.impactOccurred()
                                isDragging = true
                                startRotationAngle = angle(from: circleCenter, to: location)
                            }
                            
                            rotation = gestureRotation
                        }
                        .onEnded { value in
                            impact?.impactOccurred()
                            
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
        let deltaY = location.y - center.y
        let deltaX = location.x - center.x
        var angle = atan2(deltaY, deltaX)
        
        while angle > 2 * .pi {
            angle -= 2 * .pi
        }
        
        while angle < 0 {
            angle += 2 * .pi
        }
        
        return Double(angle)
    }
}

// MARK: - Preview

struct Artwork_Previews: PreviewProvider {
    static var previews: some View {
        MusicArtwork(colorScheme: Constants.defaultColorScheme, image: .placeholder)
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
