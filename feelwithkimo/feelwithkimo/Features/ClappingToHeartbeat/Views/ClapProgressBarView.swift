//
//  ClapProgressBarView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 06/11/25.
//
import SwiftUI

struct ClapProgressBarView: View {
    var value: Double
    
    var barHeight: CGFloat = 25.getHeight()
    var trackColor: Color = ColorToken.additionalColorsWhite.toColor()
    var progressColor: Color = ColorToken.corePrimary.toColor()
    
    @State private var animateTilt: Bool = false
    @State private var previousValue: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(trackColor)
                
                Capsule()
                    .fill(progressColor)
                    .frame(width: geometry.size.width * value)
                
                Image(systemName: "hands.clap.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(10)
                    .frame(width: barHeight * 1.8, height: barHeight * 1.8)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(ColorToken.corePrimary.toColor(), lineWidth: 4)
                    )
                    .foregroundColor(ColorToken.corePrimary.toColor())
                    .scaleEffect(animateTilt ? 1.5 : 1.0)
                    .rotationEffect(.degrees(animateTilt ? -15 : 0))
                    .position(
                        x: min(geometry.size.width * value, geometry.size.width - barHeight),
                        y: geometry.size.height / 2
                    )
                    .animation(.easeInOut(duration: 0.3), value: animateTilt)
                    .onChange(of: value) { _, newValue in
                        if newValue > previousValue {
                            animateTilt = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                animateTilt = false
                            }
                        }
                        previousValue = newValue
                    }
            }
            .frame(height: barHeight)
        }
        .frame(height: barHeight)
        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
        .animation(.easeOut(duration: 0.4), value: value)
    }
}
