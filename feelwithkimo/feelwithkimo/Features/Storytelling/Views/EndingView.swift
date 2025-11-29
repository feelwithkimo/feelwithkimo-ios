//
//  EndingView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 30/10/25.
//

import SwiftUI

extension StoryView {
    func endSceneOverlay(dismiss: @escaping () -> Void, replay: @escaping () -> Void, textDialogue: String) -> some View {
        ZStack {
            ColorToken.additionalColorsBlack.toColor().opacity(0.8).ignoresSafeArea()

            HStack(spacing: 39) {
                KimoImage(image: "KimoTutorialAsset", width: 400.getWidth())

                VStack(spacing: 0) {
                    Text(textDialogue)
                        .frame(maxWidth: 500.getWidth(), alignment: .leading)
                        .padding(.horizontal, 49.getWidth()).padding(.vertical, 42.getHeight())
                        .background(ColorToken.corePinkDialogue.toColor()).cornerRadius(30)

                    HStack {
                        KimoImage(image: "KimoDialogue", width: 74.getWidth())
                        Spacer()
                    }

                    HStack(spacing: 50) {
                        actionButton(title: NSLocalizedString("Try_Again", comment: ""), system: .arrowClockwise, action: replay)
                        actionButton(title: NSLocalizedString("Exit", comment: ""), system: .chevronRight, action: dismiss)
                    }.padding(.top, 20)
                }
            }
            .padding(.vertical, 53).padding(.horizontal, 72)
            .padding(.horizontal, 94.getWidth()).padding(.vertical, 164.getHeight())
        }
        .ignoresSafeArea().navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private func actionButton(title: String, system: SFSymbolName, action: @escaping () -> Void) -> some View {
        KimoDialogueButton(
            config: KimoDialogueButtonConfig(
                title: title,
                symbol: system,
                style: .bubblePrimary,
                action: { action() }
            )
        )
    }
}
