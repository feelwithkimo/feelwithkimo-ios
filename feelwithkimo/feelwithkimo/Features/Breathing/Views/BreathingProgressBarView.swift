//
//  BreathingProgressBarView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import SwiftUI

struct BreathingProgressBar: View {
    let progress: Double
    let color: Color
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(
                        width: geometry.size.width * min(progress, 1.0),
                        height: 20
                    )
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress: \(Int(progress * 100)) persen")
        .accessibilityValue("\(Int(progress * 100)) persen")
    }
}

#Preview {
    VStack {
        BreathingProgressBar(progress: 0.3, color: .red)
        BreathingProgressBar(progress: 0.7, color: .blue)
    }
    .padding()
}
