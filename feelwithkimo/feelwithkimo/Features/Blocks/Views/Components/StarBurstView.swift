//
//  StarParticle.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 16/11/25.
//

import SwiftUI

struct StarParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
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
            ForEach(particles) { p in
                Image(systemName: "sparkle")
                    .resizable()
                    .frame(width: size * p.scale, height: size * p.scale)
                    .foregroundColor(ColorToken.emotionJoy.toColor())
                    .opacity(p.opacity)
                    .rotationEffect(.degrees(p.rotation))
                    .position(x: p.x, y: p.y)
            }
        }
        .onAppear { animate() }
    }
    
    func animate() {
        particles = (0..<count).map { _ in
            StarParticle(
                x: center.x,
                y: center.y,
                scale: 0.2,
                opacity: 1,
                rotation: Double.random(in: 0...360)
            )
        }

        withAnimation(.easeOut(duration: 0.8)) {
            for i in particles.indices {
                particles[i].x += CGFloat.random(in: -120...120)
                particles[i].y += CGFloat.random(in: -120...120)
                particles[i].scale = CGFloat.random(in: 0.3...0.7)
                particles[i].opacity = 0
                particles[i].rotation += Double.random(in: -90...90)
            }
        }
    }
}
