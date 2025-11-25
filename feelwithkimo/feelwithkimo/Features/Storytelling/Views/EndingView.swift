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
                        KimoImage(image: "KimoDialogue", width: 157.getWidth())
                        Spacer()
                    }

                    HStack(spacing: 50) {
                        actionButton(title: NSLocalizedString("Try_Again", comment: ""), system: "arrow.trianglehead.2.clockwise", action: replay)
                        actionButton(title: NSLocalizedString("Exit", comment: ""), system: "chevron.right", action: dismiss)
                    }.padding(.top, 20)
                }
            }
            .padding(.vertical, 53).padding(.horizontal, 72)
            .padding(.horizontal, 94.getWidth()).padding(.vertical, 164.getHeight())
        }
        .ignoresSafeArea().navigationBarBackButtonHidden(true)
    }

    @ViewBuilder private func actionButton(title: String, system: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: system)
                    .resizable().scaledToFit().frame(maxWidth: 22, maxHeight: 22)
                    .foregroundStyle(ColorToken.additionalColorsWhite.toColor())

                Text(title)
                    .font(.customFont(size: 22, family: .primary, weight: .bold))
                    .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
            }
            .frame(maxWidth: 193.getWidth()).padding(.horizontal, 23).padding(.vertical, 13)
            .background(ColorToken.emotionSurprise.toColor()).cornerRadius(30)
        }
    }
}
