///
///  StarParticle.swift
///  feelwithkimo
///
///  Created by Adeline Charlotte Augustinne on 16/11/25.
///

import SwiftUI

struct StarParticle: Identifiable {
    let id = UUID()
    var positionX: CGFloat
    var positionY: CGFloat
    var scale: CGFloat
    var opacity: Double
    var rotation: Double
}

struct StarBurstView: View {
    @State var particles: [StarParticle] = []
    let center: CGPoint
    let size: CGFloat = 100
    let count: Int = 12
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Image(systemName: "sparkle")
                    .resizable()
                    .frame(width: size * particle.scale, height: size * particle.scale)
                    .foregroundColor(ColorToken.emotionJoy.toColor())
                    .opacity(particle.opacity)
                    .rotationEffect(.degrees(particle.rotation))
                    .position(x: particle.positionX, y: particle.positionY)
            }
        }
        .onAppear { animate() }
    }
    
    func animate() {
        particles = (0..<count).map { _ in
            StarParticle(
                positionX: center.x,
                positionY: center.y,
                scale: 0.2,
                opacity: 1,
                rotation: Double.random(in: 0...360)
            )
        }

        withAnimation(.easeOut(duration: 0.8)) {
            for idx in particles.indices {
                particles[idx].positionX += CGFloat.random(in: -120...120)
                particles[idx].positionY += CGFloat.random(in: -120...120)
                particles[idx].scale = CGFloat.random(in: 0.3...0.7)
                particles[idx].opacity = 0
                particles[idx].rotation += Double.random(in: -90...90)
            }
        }
    }
}
