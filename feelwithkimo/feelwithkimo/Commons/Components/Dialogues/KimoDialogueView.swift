//
//  KimoDialogueView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 03/11/25.
//

import SwiftUI

struct KimoDialogueView: View {
    var kimoDialogueIcon: String = "KimoTutorialAsset"
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
    var stageCompleted: String?
    
    var body: some View {
        VStack {
            if let stage = stageCompleted {
                Text(stage)
                    .font(.customFont(size: 34, family: .primary, weight: .bold))
            }
            
            HStack(spacing: 39) {
                Image(kimoDialogueIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 512 * UIScreen.main.bounds.width / 1194)
                
                VStack(spacing: 0) {
                    Text(textDialogue)
                        .font(.customFont(size: 20, family: .primary, weight: .bold))
                        .foregroundStyle(ColorToken.additionalColorsBlack.toColor())
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
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        // Preview with regular horizontal buttons
        KimoDialogueView(
            textDialogue: "Hari ini, Kimo mau bermain dengan teman Kimo, namanya Lala.",
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
        
        // Preview with bubble secondary buttons with SF Symbols (like in image)
//        KimoDialogueView(
//            textDialogue: "Hore, berhasil !",
//            buttonLayout: .horizontal([
//                KimoDialogueButtonConfig(
//                    title: "Coba lagi",
//                    symbol: .arrowClockwise,
//                    style: .bubbleSecondary,
//                    action: { print("Bubble secondary try again tapped") }
//                ),
//                KimoDialogueButtonConfig(
//                    title: "Lanjutkan",
//                    symbol: .chevronRight,
//                    style: .bubbleSecondary,
//                    action: { print("Bubble secondary continue tapped") }
//                )
//            ])
//        )
//        
//        // Preview with bubble primary button
//        KimoDialogueView(
//            textDialogue: "Yuk, kita mulai petualangan bersama Kimo!",
//            buttonLayout: .single(
//                KimoDialogueButtonConfig(
//                    title: "Ayo Mulai!",
//                    style: .bubblePrimary,
//                    action: { print("Bubble primary tapped") }
//                )
//            )
//        )
    }
}
