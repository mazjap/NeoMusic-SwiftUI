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
    
    @State var rotation: Double = 0
    @State var isDragging: Bool = false
    @State var startRotationAngle: Double = 0
    
    // MARK: - Variables
    
    let impact: UIImpactFeedbackGenerator
    let colorScheme: ColorScheme
    let image: Image
    
    // MARK: - Initializer
    
    init(impact: UIImpactFeedbackGenerator, colorScheme: ColorScheme, image: Image) {
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
                    .shadow(color: Color.black.opacity(1), radius: 20, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.3), radius: 10, x: -5, y: -5)
                
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
                                impact.impactOccurred()
                                isDragging = true
                                startRotationAngle = angle(from: circleCenter, to: location)
                            }
                            
                            rotation -= gestureRotation
                        }
                        .onEnded { value in
                            impact.impactOccurred()
                            
                            let circleCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            
                            let gestureRotation = angle(from: circleCenter, to: value.location) - startRotationAngle
                            
                            isDragging = false
                            rotation -= gestureRotation
                        }
                )
            }
        }
    }
    
    // MARK: - Functions
    
    private func angle(from center: CGPoint, to location: CGPoint) -> Double {
        let deltaY = location.y - center.y
        let deltaX = location.x - center.x
        let angle = atan2(deltaY, deltaX)
        
        return Double(angle < 0 ? abs(angle) : 360 - angle)
    }
}

// MARK: - Preview

struct Artwork_Previews: PreviewProvider {
    static var previews: some View {
        MusicArtwork(impact: UIImpactFeedbackGenerator(), colorScheme: Constants.defaultColorScheme, image: .placeholder)
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
