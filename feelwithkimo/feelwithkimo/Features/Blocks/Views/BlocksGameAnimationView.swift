//
//  BlocksGameViewAnimationView.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 19/11/25.
//

import SwiftUI

struct CurvedMotion: AnimatableModifier {
    var progress: CGFloat
    var start: CGPoint
    var end: CGPoint
    var control: CGPoint
    
    var rotationStart: Double
    var rotationEnd: Double
    
    let holdFraction: CGFloat = 0.23
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {

        let effectiveProgress: CGFloat

        if progress >= (1 - holdFraction) {
            effectiveProgress = 1
        } else {
            effectiveProgress = progress / (1 - holdFraction)
        }
        let trajectory = effectiveProgress

        let distX = pow(1 - trajectory, 2) * start.x
              + 2 * (1 - trajectory) * trajectory * control.x
              + pow(trajectory, 2) * end.x

        let distY = pow(1 - trajectory, 2) * start.y
              + 2 * (1 - trajectory) * trajectory * control.y
              + pow(trajectory, 2) * end.y

        let rotation = rotationStart + (rotationEnd - rotationStart) * trajectory

        return content
            .rotationEffect(.degrees(rotation))
            .position(x: distX, y: distY)
    }
}

struct BlocksGameAnimationView: View {
    @State private var animate = false
    @State private var visible = false

    let start = CGPoint(x: 440, y: 323)
    let end   = CGPoint(x: 842, y: 418)
    let control = CGPoint(x: 650, y: 250)

    let fadeInDuration = 0.3
    let moveDuration   = 1.3
    let holdDuration   = 0.3
    let fadeOutDuration = 0.3

    var body: some View {
        ZStack {
            Color.clear

            Image("Point")
                .opacity(visible ? 1 : 0)
                .modifier(
                    CurvedMotion(
                        progress: animate ? 1 : 0,
                        start: start,
                        end: end,
                        control: control,
                        rotationStart: -10,
                        rotationEnd: 10
                    )
                )
        }
        .onAppear {
            visible = false
            animate = false

            withAnimation(.easeIn(duration: fadeInDuration)) {
                visible = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + fadeInDuration) {
                withAnimation(.easeOut(duration: moveDuration)) {
                    animate = true
                }
            }

            let totalDelay = fadeInDuration + moveDuration + holdDuration
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
                withAnimation(.easeOut(duration: fadeOutDuration)) {
                    visible = false
                }
            }
        }
    }
}

#Preview() {
    BlocksGameAnimationView()
}
