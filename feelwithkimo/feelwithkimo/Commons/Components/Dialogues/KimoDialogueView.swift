//
//  KimoDialogueView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 03/11/25.
//

import SwiftUI

struct KimoDialogueView: View {
    var kimoDialogueIcon: String = "KimoDialogueIcon"
    var textDialogue: String = "Hari ini, Kimo mau bermain dengan teman Kimo, namanya Lala."
    var textDialogueTriangle: String = "KimoDialogueTriangle"
    var buttonLayout: KimoDialogueButtonLayout = .horizontal([
            KimoDialogueButtonConfig(
                title: "Coba lagi",
                symbol: .arrowClockwise,
                backgroundColor: ColorToken.coreSecondary.toColor(),
                foregroundColor: ColorToken.textPrimary.toColor(),
                action: { print("Try again tapped") }
            ),
            KimoDialogueButtonConfig(
                title: "Lanjutkan",
                action: { print("Continue tapped") }
            )
        ])
    
    var body: some View {
        HStack(spacing: 39) {
            Image(kimoDialogueIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 512 * UIScreen.main.bounds.width / 1194)
            
            VStack(spacing: 0) {
                Text(textDialogue)
                    .font(.app(.title3, family: .primary))
                    .fontWeight(.regular)
                    .foregroundStyle(.black)
                    .frame(maxWidth: 500 * UIScreen.main.bounds.width / 1194)
                    .padding(.horizontal, 49 * UIScreen.main.bounds.width / 1194)
                    .padding(.vertical, 42.5 * UIScreen.main.bounds.height / 834)
                    .background(ColorToken.corePinkDialogue.toColor())
                    .cornerRadius(30)
                
                HStack {
                    Image(textDialogueTriangle)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 157 * UIScreen.main.bounds.width / 1194)
                    
                    Spacer()
                }
                
                KimoDialogueButtonsView(layout: buttonLayout)
            }
        }
        .padding(.top, 53)
        .padding(.horizontal, 72)
        .ignoresSafeArea()
    }
}

#Preview {
    KimoDialogueView(
        buttonLayout: .horizontal([
            KimoDialogueButtonConfig(
                title: "Coba lagi",
                symbol: .arrowClockwise,
                backgroundColor: ColorToken.coreSecondary.toColor(),
                foregroundColor: ColorToken.textPrimary.toColor(),
                action: { print("Try again tapped") }
            ),
            KimoDialogueButtonConfig(
                title: "Lanjutkan",
                symbol: .chevronRight,
                backgroundColor: ColorToken.backgroundCard.toColor(),
                foregroundColor: ColorToken.textPrimary.toColor(),
                action: { print("Continue tapped") }
            )
        ])
    )
}
