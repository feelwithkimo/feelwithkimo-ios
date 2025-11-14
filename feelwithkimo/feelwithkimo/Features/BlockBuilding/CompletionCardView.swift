//
//  CompletionCardView.swift
//  feelwithkimo
//
//  Created on 14/11/25.
//

import SwiftUI

struct CompletionCardView: View {
    var title: String = "Tahap 1 Selesai!!!"
    var elephantImage: String = "KimoSenang"
    var primaryButtonLabel: String = "Coba lagi"
    var secondaryButtonLabel: String = "Lanjutkan"
    
    var body: some View {
        ZStack {
            // White background card
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .frame(width: 688.getWidth(), height: 620.getHeight())
            
            // Dashed green border
            RoundedRectangle(cornerRadius: 30)
                .strokeBorder(
                    ColorToken.coreAccent.toColor(),
                    style: StrokeStyle(
                        lineWidth: 8,
                        dash: [20, 15]
                    )
                )
                .frame(width: 688.getWidth(), height: 620.getHeight())
                .padding(16)
            
            VStack(spacing: 0) {
                // Title bubble
                ZStack {
                    Capsule()
                        .fill(ColorToken.coreAccent.toColor())
                        .frame(width: 420.getWidth(), height: 80.getHeight())
                    
                    Text(title)
                        .font(.app(.largeTitle, family: .primary))
                        .foregroundStyle(Color.white)
                }
                .offset(y: -40.getHeight())
                
                Spacer()
                    .frame(height: 20.getHeight())
                
                // Elephant image
                Image(elephantImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280.getWidth(), height: 280.getHeight())
                
                Spacer()
                    .frame(height: 40.getHeight())
                
                // Buttons
                HStack(spacing: 24.getWidth()) {
                    // Primary button (Coba lagi)
                    Button(action: {
                        // Action will be added later
                    }) {
                        KimoBubbleButtonSecondary(buttonLabel: primaryButtonLabel)
                    }
                    
                    // Secondary button (Lanjutkan)
                    Button(action: {
                        // Action will be added later
                    }) {
                        KimoBubbleButtonSecondary(buttonLabel: secondaryButtonLabel)
                    }
                }
                .padding(.bottom, 32.getHeight())
            }
        }
        .frame(width: 688.getWidth(), height: 620.getHeight())
    }
}

#Preview {
    CompletionCardView()
}
