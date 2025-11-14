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
                .frame(width: 700.getWidth(), height: 620.getHeight())
                .overlay(
                    // Solid green border - thicker
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(ColorToken.coreAccent.toColor(), lineWidth: 14)
                )
                .overlay(
                    // Dashed green border inside - longer dashes
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(
                            ColorToken.coreAccent.toColor(),
                            style: StrokeStyle(
                                lineWidth: 7,
                                dash: [24, 16]
                            )
                        )
                        .padding(20)
                )
            
            // Title and Buttons Layer
            VStack(spacing: 0) {
                // Title bubble - positioned to overflow at top
                ZStack {
                    // Shadow layer (flatter, more elongated)
                    RoundedRectangle(cornerRadius: 50)
                        .fill(ColorToken.coreAccent.toColor().opacity(0.3))
                        .frame(width: 520.getWidth(), height: 68.getHeight())
                        .offset(y: 5)
                    
                    // Main title background (flatter elongated rounded rectangle)
                    RoundedRectangle(cornerRadius: 50)
                        .fill(ColorToken.coreAccent.toColor())
                        .frame(width: 520.getWidth(), height: 68.getHeight())
                    
                    Text(title)
                        .font(.app(size: 40, family: .primary, weight: .bold))
                        .foregroundStyle(Color.white)
                }
                .offset(y: -34.getHeight()) // Half outside the card
                
                Spacer()
                
                // Buttons using KimoDialogueButton with shadows
                HStack(spacing: 24.getWidth()) {
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
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .shadow(color: ColorToken.backgroundSecondary.toColor().opacity(0.2), radius: 12, x: 0, y: 2)
                    
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
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .shadow(color: ColorToken.backgroundSecondary.toColor().opacity(0.2), radius: 12, x: 0, y: 2)
                }
                .padding(.bottom, 50.getHeight())
            }/
            
            // Elephant image - separate layer on top
            Image(elephantImage)
                .resizable()
                .scaledToFit()
                .frame(width: 460.getWidth(), height: 460.getHeight())
                .offset(y: -50.getHeight()) // Adjust vertical position as needed
        }
        .frame(width: 700.getWidth(), height: 620.getHeight())
    }
}

#Preview {
    CompletionCardView()
        .background(ColorToken.backgroundMain.toColor())
}
