//
//  CompletionCardView.swift
//  feelwithkimo
//
//  Created on 14/11/25.
//

import SwiftUI

struct KimoBubbleButton: View {
    var buttonLabel: String
    var icon: String? = nil
    var iconPosition: IconPosition = .leading
    
    enum IconPosition {
        case leading, trailing
    }
    
    var body: some View {
        ZStack {
            Image("KimoBubbleButtonSecondary")
                .resizable()
                .scaledToFit()
                .frame(width: 253.getWidth(), height: 74.getHeight())
                .padding(0)
            
            HStack(spacing: 8) {
                if iconPosition == .leading, let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(ColorToken.textPrimary.toColor())
                }
                
                Text(buttonLabel)
                    .font(.app(.title1, family: .primary))
                    .foregroundStyle(ColorToken.textPrimary.toColor())
                
                if iconPosition == .trailing, let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(ColorToken.textPrimary.toColor())
                }
            }
            .padding(.bottom, 8.getHeight())
        }
        .frame(maxWidth: 253.getWidth(), maxHeight: 74.getHeight())
        .clipShape(RoundedRectangle(cornerRadius: 100))
        .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
        .shadow(color: ColorToken.backgroundSecondary.toColor().opacity(0.3), radius: 12, x: 0, y: 2)
    }
}

struct CompletionCardView: View {
    var title: String = "Tahap 1 Selesai!!!"
    var elephantImage: String = "KimoSenang"
    var primaryButtonLabel: String = "Coba lagi"
    var secondaryButtonLabel: String = "Lanjutkan"
    
    var body: some View {
        ZStack {
            // White background card with borders
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .frame(width: 700.getWidth(), height: 640.getHeight())
                .overlay(
                    // Solid green border
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(ColorToken.coreAccent.toColor(), lineWidth: 14)
                )
                .overlay(
                    // Dashed green border inside
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(
                            ColorToken.coreAccent.toColor(),
                            style: StrokeStyle(
                                lineWidth: 8,
                                dash: [20, 15]
                            )
                        )
                        .padding(22)
                )
            
            VStack(spacing: 0) {
                // Title bubble - positioned to overflow at top
                ZStack {
                    // Shadow layer
                    RoundedRectangle(cornerRadius: 40)
                        .fill(ColorToken.coreAccent.toColor().opacity(0.3))
                        .frame(width: 480.getWidth(), height: 90.getHeight())
                        .offset(y: 4)
                    
                    // Main title background
                    RoundedRectangle(cornerRadius: 40)
                        .fill(ColorToken.coreAccent.toColor())
                        .frame(width: 480.getWidth(), height: 90.getHeight())
                    
                    Text(title)
                        .font(.app(size: 40, family: .primary, weight: .bold))
                        .foregroundStyle(Color.white)
                }
                .offset(y: -45.getHeight()) // Half outside the card
                
                Spacer()
                    .frame(height: 40.getHeight())
                
                // Elephant image
                Image(elephantImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320.getWidth(), height: 320.getHeight())
                
                Spacer()
                    .frame(height: 50.getHeight())
                
                // Buttons
                HStack(spacing: 32.getWidth()) {
                    // Primary button (Coba lagi) with recycle icon
                    Button(action: {
                        // Action will be added later
                    }) {
                        KimoBubbleButton(
                            buttonLabel: primaryButtonLabel,
                            icon: "arrow.clockwise",
                            iconPosition: .leading
                        )
                    }
                    
                    // Secondary button (Lanjutkan) with chevron icon
                    Button(action: {
                        // Action will be added later
                    }) {
                        KimoBubbleButton(
                            buttonLabel: secondaryButtonLabel,
                            icon: "chevron.right",
                            iconPosition: .trailing
                        )
                    }
                }
                .padding(.bottom, 48.getHeight())
            }
        }
        .frame(width: 700.getWidth(), height: 640.getHeight())
    }
}

#Preview {
    CompletionCardView()
}
