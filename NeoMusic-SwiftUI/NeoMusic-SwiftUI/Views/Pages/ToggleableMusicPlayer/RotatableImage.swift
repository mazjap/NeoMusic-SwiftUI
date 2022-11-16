import SwiftUI

struct RotatingRecord: View {
    @EnvironmentObject private var feedback: FeedbackGenerator
    
    @State private var rotation: Angle = .zero
    @State private var autorotation: Angle = .zero
    @State private var isPerformingRotationGesture = false
    
    @Binding private var lastRotation: Angle
    
    private let image: Image
    private let spinDuration: Double
    private let coordSpaceName = "spinningRecord"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.minSize, height: geometry.minSize)
            }
            .contentShape(Circle())
            .gesture(DragGesture(coordinateSpace: .named(coordSpaceName))
                .onChanged { value in
                    if !isPerformingRotationGesture {
                        isPerformingRotationGesture = true
                        feedback.impactOccurred()
                    }
                    
                    handleRotation(value.startLocation, geometry.frame(in: .named(coordSpaceName)).center, value.location)
                }
                .onEnded { value in
                    let oldRot = rotation
                    rotation = .zero

                    lastRotation += oldRot
                    autorotation = .degrees(360)
                    isPerformingRotationGesture = false
                    feedback.impactOccurred()
                }
            )
            .task {
                autorotation = .degrees(360)
            }
        }
        .clipShape(Circle())
        .rotationEffect(lastRotation + rotation + autorotation)
        .animation(
            .linear(
                duration: !isPerformingRotationGesture ? spinDuration : 0
            )
            .repeatForever(autoreverses: false),
            value: autorotation
        )
        .coordinateSpace(name: coordSpaceName)
    }
    
    private func handleRotation(_ start: CGPoint, _ center: CGPoint, _ end: CGPoint) {
        rotation = Angle.radians(
             atan2(
                center.y - end.y,
                center.x - end.x
            ) - atan2(
                center.y - start.y,
                center.x - start.x
            )
        )
    }
}

extension RotatingRecord {
    init(_ image: Image, spinDuration: Double = 0, lastRotation: Binding<Angle>) {
        self.image = image
        self.spinDuration = spinDuration
        
        self._lastRotation = lastRotation
    }
}

struct RotatingRecord_Previews: PreviewProvider {
    static var previews: some View {
        RotatingRecord(.placeholder, spinDuration: 3, lastRotation: .constant(.zero))
    }
}


//import SwiftUI
//
//struct RotatableImage: View {
//
//    // MARK: - State
//
//    @EnvironmentObject private var feedback: FeedbackGenerator
//
//    @Binding private var previousRotation: Double
//
//    @State private var rotation: Double = 0
//    @State private var isDragging: Bool = false
//    @State private var startRotationAngle: Double = 0
//
//    // MARK: - Variables
//    private let colorScheme: JCColorScheme
//    private let image: Image
//    private let size: Neumorph.Size
//    private let imagePadding: CGFloat
//
//    // MARK: - Initializers
//
//    init(colorScheme: JCColorScheme, image: Image, rotation: Binding<Double>, size: Neumorph.Size = .artwork, imagePadding: CGFloat = 3) {
//        self._previousRotation = rotation
//        self.colorScheme = colorScheme
//        self.image = image
//        self.size = size
//        self.imagePadding = imagePadding
//    }
//
//    // MARK: - Body
//
//    var body: some View {
//        GeometryReader { geometry in
//            LinearGradient(
//                gradient: Gradient(
//                    colors: colorScheme.backgroundGradient.colors.reversed()
//                ),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .clipShape(Circle())
//            .neumorph(color: colorScheme.backgroundGradient.first.average(to: colorScheme.backgroundGradient.last), size: size, cornerRadius: .infinity, isConcave: false)
////                .neumorph(Circle(), color: colorScheme.backgroundGradient.first.average(to: colorScheme.backgroundGradient.last), spread: 10, radius: 10)
////                .neumorph(color: , size: size, cornerRadius: .infinity, isConcave: false)
//                .overlay(
//            image
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .clipShape(Circle())
//                .contentShape(Circle())
//                .rotationEffect(.radians(isDragging ? rotation : previousRotation))
//                .padding(imagePadding)
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            let circleCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
//
//                            let location = value.location
//
//                            if !isDragging {
//                                isDragging = true
//                                feedback.impactOccurred()
//                                startRotationAngle = angle(from: circleCenter, to: location)
//                            }
//
//                            rotation = angle(from: circleCenter, to: location) - startRotationAngle + previousRotation
//                        }
//                        .onEnded { value in
//                            feedback.impactOccurred()
//
//                            previousRotation = rotation
//                            rotation = 0
//
//                            isDragging = false
//                        }
//                )
//            )
//        }
//    }
//
//    // MARK: - Functions
//
//    private func angle(from center: CGPoint, to location: CGPoint) -> Double {
//        return Double(atan2(location.y - center.y, location.x - center.x))
//    }
//
//    private func reducedRadian<T: BinaryFloatingPoint>(_ val: T) -> Double {
//        var radians = val
//
//        let mult = radians / 2 * .pi
//
//        if mult > 1 {
//            radians -= mult * 2 * .pi
//        }
//
//        while radians < 0 {
//            radians += 2 * .pi
//        }
//
//        return Double(radians)
//    }
//}
//
//// MARK: - Preview
//
//struct Artwork_Previews: PreviewProvider {
//    @State static var rotation: Double = 0
//
//    static var previews: some View {
//        ZStack {
//            Color.falseWhite
//
//            RotatableImage(colorScheme: .default, image: .placeholder, rotation: $rotation)
//                .spacing()
//                .previewLayout(.fixed(width: 400, height: 400))
//        }
//        .ignoresSafeArea()
//    }
//}
