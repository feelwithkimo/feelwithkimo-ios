//
//  ConfettiView.swift
//  feelwithkimo
//
//  Created on 14/11/25.
//

import SwiftUI

struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    @State private var isAnimating = false
    let confettiCount: Int
    let colors: [Color]
    
    init(confettiCount: Int = 150, colors: [Color] = [
        ColorToken.emotionJoy.toColor(),
        ColorToken.emotionSurprise.toColor(),
        ColorToken.coreAccent.toColor(),
        ColorToken.emotionDisgusted.toColor(),
        ColorToken.coreSecondary.toColor(),
        ColorToken.corePrimary.toColor(),
        ColorToken.statusSuccess.toColor(),
        ColorToken.emotionSadness.toColor(),
        .yellow,
        .pink
    ]) {
        self.confettiCount = confettiCount
        self.colors = colors
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confettiPieces) { piece in
                    ConfettiShape(shape: piece.shape)
                        .fill(
                            LinearGradient(
                                colors: [piece.color, piece.color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: piece.size, height: piece.size)
                        .rotationEffect(piece.rotation)
                        .rotation3DEffect(
                            piece.rotation3D,
                            axis: (x: 1, y: 1, z: 0)
                        )
                        .scaleEffect(piece.scale)
                        .position(piece.position)
                        .opacity(piece.opacity)
                        .blur(radius: piece.blur)
                        .shadow(color: piece.color.opacity(0.5), radius: 4, x: 0, y: 2)
                }
            }
            .onAppear {
                startConfetti(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }
    
    private func startConfetti(in size: CGSize) {
        // Create confetti pieces with varied starting positions
        confettiPieces = (0..<confettiCount).map { _ in
            let startX = CGFloat.random(in: 0...size.width)
            let startY = CGFloat.random(in: -200...(-20))
            
            return ConfettiPiece(
                shape: ConfettiShapeType.allCases.randomElement() ?? .circle,
                color: colors.randomElement() ?? .blue,
                size: CGFloat.random(in: 10...24),
                position: CGPoint(x: startX, y: startY),
                rotation: .degrees(Double.random(in: 0...360)),
                rotation3D: .degrees(Double.random(in: 0...360)),
                scale: CGFloat.random(in: 0.8...1.2),
                opacity: 1.0,
                blur: 0
            )
        }
        
        animateConfetti(in: size)
    }
    
    // swiftlint:disable identifier_name
    private func animateConfetti(in size: CGSize) {
        for i in confettiPieces.indices {
            let delay = Double.random(in: 0...1.5)
            let duration = Double.random(in: 5.0...8.0)
            let endY = size.height + CGFloat.random(in: 50...150)
            let horizontalDrift = CGFloat.random(in: -200...200)
            let spinAmount = Double.random(in: 1080...2160)
            let wobbleAmount = Double.random(in: 360...720)
            
            // Main falling animation with multiple properties
            withAnimation(
                .timingCurve(0.2, 0.8, 0.3, 1.0, duration: duration)
                .delay(delay)
            ) {
                confettiPieces[i].position.y = endY
                confettiPieces[i].position.x += horizontalDrift
            }
            
            // Rotation animation with different timing
            withAnimation(
                .linear(duration: duration * 0.7)
                .repeatCount(1, autoreverses: false)
                .delay(delay)
            ) {
                confettiPieces[i].rotation = .degrees(spinAmount)
            }
            
            // 3D rotation for depth effect
            withAnimation(
                .linear(duration: duration * 0.5)
                .repeatCount(1, autoreverses: false)
                .delay(delay)
            ) {
                confettiPieces[i].rotation3D = .degrees(wobbleAmount)
            }
            
            // Scale pulsing effect
            withAnimation(
                .easeInOut(duration: duration * 0.3)
                .repeatCount(3, autoreverses: true)
                .delay(delay)
            ) {
                confettiPieces[i].scale = CGFloat.random(in: 0.6...1.3)
            }
            
            // Fade out at the end
            withAnimation(
                .easeIn(duration: duration * 0.3)
                .delay(delay + duration * 0.7)
            ) {
                confettiPieces[i].opacity = 0.0
                confettiPieces[i].blur = 2
            }
        }
    }
    // swiftlint:enable identifier_name
    
    private func addContinuousConfetti(in size: CGSize) {
        // Add extra bursts at intervals
        for burstIndex in 1...6 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(burstIndex) * 1.2) {
                let burstCount = Int.random(in: 20...30)
                let newPieces = (0..<burstCount).map { _ in
                    ConfettiPiece(
                        shape: ConfettiShapeType.allCases.randomElement() ?? .circle,
                        color: colors.randomElement() ?? .blue,
                        size: CGFloat.random(in: 10...20),
                        position: CGPoint(
                            x: CGFloat.random(in: size.width * 0.3...size.width * 0.7),
                            y: -20
                        ),
                        rotation: .degrees(Double.random(in: 0...360)),
                        rotation3D: .degrees(Double.random(in: 0...360)),
                        scale: CGFloat.random(in: 0.8...1.2),
                        opacity: 1.0,
                        blur: 0
                    )
                }
                
                confettiPieces.append(contentsOf: newPieces)
                animateBurstConfetti(pieces: Array(confettiPieces.suffix(burstCount)), in: size)
            }
        }
    }
    
    private func animateBurstConfetti(pieces: [ConfettiPiece], in size: CGSize) {
        for piece in pieces {
            if let index = confettiPieces.firstIndex(where: { $0.id == piece.id }) {
                let duration = Double.random(in: 4.0...6.5)
                let endY = size.height + 100
                let horizontalDrift = CGFloat.random(in: -150...150)
                
                withAnimation(.easeIn(duration: duration)) {
                    confettiPieces[index].position.y = endY
                    confettiPieces[index].position.x += horizontalDrift
                }
                
                withAnimation(.linear(duration: duration * 0.6).repeatCount(1)) {
                    confettiPieces[index].rotation = .degrees(Double.random(in: 360...720))
                }
                
                withAnimation(.easeIn(duration: duration * 0.3).delay(duration * 0.7)) {
                    confettiPieces[index].opacity = 0.0
                }
            }
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var shape: ConfettiShapeType
    var color: Color
    var size: CGFloat
    var position: CGPoint
    var rotation: Angle
    var rotation3D: Angle
    var scale: CGFloat
    var opacity: Double
    var blur: CGFloat
}

enum ConfettiShapeType: CaseIterable {
    case circle
    case square
    case triangle
    case star
    case diamond
    case heart
}

// swiftlint:disable identifier_name
struct ConfettiShape: Shape {
    let shape: ConfettiShapeType
    
    func path(in rect: CGRect) -> Path {
        switch shape {
        case .circle:
            return Path(ellipseIn: rect)
        case .square:
            return Path(rect)
        case .triangle:
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
            return path
        case .star:
            return starPath(in: rect)
        case .diamond:
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.closeSubpath()
            return path
        case .heart:
            return heartPath(in: rect)
        }
    }
    
    private func starPath(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        let points = 5
        
        for i in 0..<points * 2 {
            let angle = (Double(i) * .pi / Double(points)) - .pi / 2
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let x = center.x + CGFloat(cos(angle)) * radius
            let y = center.y + CGFloat(sin(angle)) * radius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
    
    private func heartPath(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width / 2, y: height))
        
        path.addCurve(
            to: CGPoint(x: 0, y: height * 0.3),
            control1: CGPoint(x: width / 2, y: height * 0.7),
            control2: CGPoint(x: 0, y: height * 0.6)
        )
        
        path.addArc(
            center: CGPoint(x: width * 0.25, y: height * 0.25),
            radius: width * 0.25,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        path.addArc(
            center: CGPoint(x: width * 0.75, y: height * 0.25),
            radius: width * 0.25,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        path.addCurve(
            to: CGPoint(x: width / 2, y: height),
            control1: CGPoint(x: width, y: height * 0.6),
            control2: CGPoint(x: width / 2, y: height * 0.7)
        )
        
        return path
    }
}
// swiftlint:enable identifier_name

#Preview {
    ZStack {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
        ConfettiView()
    }
}
