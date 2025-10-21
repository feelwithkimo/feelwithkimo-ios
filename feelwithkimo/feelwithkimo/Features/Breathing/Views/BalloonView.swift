//
//  BalloonView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import SwiftUI

struct BalloonView: View {
    let progress: Double
    let color: Color
    let isActive: Bool

    private var balloonSize: CGFloat {
        let minSize: CGFloat = 50
        let maxSize: CGFloat = 150
        let progressRatio = progress / 100.0
        return minSize + (maxSize - minSize) * progressRatio
    }

    private var balloonOpacity: Double {
        isActive ? 1.0 : 0.5
    }

    var body: some View {
        VStack {
            // Balloon
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.8),
                            color.opacity(0.6),
                            color
                        ]),
                        center: .topLeading,
                        startRadius: balloonSize * 0.1,
                        endRadius: balloonSize * 0.5
                    )
                )
                .frame(width: balloonSize, height: balloonSize)
                .overlay(
                    Circle()
                        .stroke(color.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: color.opacity(0.3), radius: 5, x: 2, y: 2)
                .opacity(balloonOpacity)
                .animation(.easeInOut(duration: 0.3), value: balloonSize)
                .animation(.easeInOut(duration: 0.2), value: balloonOpacity)

            // Balloon string
            Rectangle()
                .fill(Color.gray)
                .frame(width: 2, height: 20)
                .opacity(balloonOpacity)

            // Progress text
            Text("\(Int(progress))%")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(color)
                .opacity(balloonOpacity)
        }
    }
}
