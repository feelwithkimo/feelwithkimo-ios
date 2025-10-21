//
//  ProgressBarView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 21/10/25.
//

import SwiftUI

struct ProgressBarView: View {
    let totalSteps = 5
    var currentStep: Int = 0

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(0..<totalSteps, id: \.self) { index in
                HStack(spacing: 0) {
                    // Titik (clap icon)
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(index <= currentStep ? 0.15 : 0.05))
                            .frame(width: 36, height: 36)

                        Image(systemName: index <= currentStep ? "hands.clap.fill" : "hands.clap")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(index <= currentStep ? .primary : .gray)

                        Circle()
                            .stroke(index == currentStep ? Color.primary : Color.clear, lineWidth: 4)
                            .frame(width: 44, height: 44)
                    }

                    // Garis penghubung (kecuali titik terakhir)
                    if index < totalSteps - 1 {
                        Rectangle()
                            .fill(index < currentStep ? Color.primary : Color.gray.opacity(0.3))
                            .frame(height: 6)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 60)
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }
}
