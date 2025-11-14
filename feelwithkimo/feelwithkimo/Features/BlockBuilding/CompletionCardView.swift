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
    var onPrimaryAction: (() -> Void)?
    var onSecondaryAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            // White background card with borders
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .frame(width: 620.getWidth(), height: 560.getHeight())
                .overlay(
                    // Solid green border
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(ColorToken.coreAccent.toColor(), lineWidth: 10)
                )
                .overlay(
                    // Dashed green border inside
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(
                            ColorToken.coreAccent.toColor(),
                            style: StrokeStyle(
                                lineWidth: 6,
                                dash: [16, 12]
                            )
                        )
                        .padding(16)
                )
            
            VStack(spacing: 0) {
                // Title bubble - positioned to overflow at top
                ZStack {
                    // Shadow layer (more elongated)
                    RoundedRectangle(cornerRadius: 100)
                        .fill(ColorToken.coreAccent.toColor().opacity(0.3))
                        .frame(width: 440.getWidth(), height: 76.getHeight())
                        .offset(y: 4)
                    
                    // Main title background (elongated rounded rectangle)
                    RoundedRectangle(cornerRadius: 100)
                        .fill(ColorToken.coreAccent.toColor())
                        .frame(width: 440.getWidth(), height: 76.getHeight())
                    
                    Text(title)
                        .font(.app(size: 36, family: .primary, weight: .bold))
                        .foregroundStyle(Color.white)
                }
                .offset(y: -38.getHeight()) // Half outside the card
                
                Spacer()
                    .frame(height: 30.getHeight())
                
                // Elephant image
                Image(elephantImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280.getWidth(), height: 280.getHeight())
                
                Spacer()
                    .frame(height: 36.getHeight())
                
                // Buttons using KimoDialogueButton
                HStack(spacing: 20.getWidth()) {
                    // Primary button (Coba lagi) with recycle icon
                    KimoDialogueButton(
                        config: KimoDialogueButtonConfig(
                            title: primaryButtonLabel,
                            symbol: .arrowClockwise,
                            style: .bubbleSecondary,
                            action: {
                                onPrimaryAction?()
                            }
                        )
                    )
                    
                    // Secondary button (Lanjutkan) with chevron icon
                    KimoDialogueButton(
                        config: KimoDialogueButtonConfig(
                            title: secondaryButtonLabel,
                            symbol: .chevronRight,
                            style: .bubbleSecondary,
                            action: {
                                onSecondaryAction?()
                            }
                        )
                    )
                }
                .padding(.bottom, 46.getHeight())
            }
        }
        .frame(width: 620.getWidth(), height: 560.getHeight())
    }
}

#Preview {
    CompletionCardView()
        .background(ColorToken.backgroundMain.toColor())
}
