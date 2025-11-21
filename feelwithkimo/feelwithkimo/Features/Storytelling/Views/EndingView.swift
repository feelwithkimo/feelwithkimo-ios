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
            ColorToken.additionalColorsBlack.toColor().opacity(0.8)
                .ignoresSafeArea()

            ZStack {
                HStack(spacing: 39) {
                    KimoImage(image: "KimoTutorialAsset", width: 400.getWidth())

                    // Dialogue bubble
                    VStack(spacing: 0) {
                        Text(textDialogue)
                            .frame(maxWidth: 500.getWidth(), alignment: .leading)
                            .padding(.horizontal, 49.getWidth())
                            .padding(.vertical, 42.getHeight())
                            .background(ColorToken.corePinkDialogue.toColor())
                            .cornerRadius(30)

                        HStack {
                            KimoImage(image: "KimoDialogue", width: 157.getWidth())
                            Spacer()
                        }

                        HStack(spacing: 50) {
                            Button(action: replay) {
                                HStack {
                                    Image(systemName: "arrow.trianglehead.2.clockwise")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 22, maxHeight: 22)
                                        .foregroundStyle(ColorToken.additionalColorsWhite.toColor())

                                    Text("Coba Lagi")
                                        .font(.customFont(size: 22, family: .primary, weight: .bold))
                                        .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                                }
                                .frame(maxWidth: 193.getWidth())
                                .padding(.horizontal, 23)
                                .padding(.vertical, 13)
                                .background(ColorToken.emotionSurprise.toColor())
                                .cornerRadius(30)
                            }

                            Button(action: dismiss) {
                                HStack {
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 22, maxHeight: 22)
                                        .foregroundStyle(ColorToken.additionalColorsWhite.toColor())

                                    Text("Keluar")
                                        .font(.customFont(size: 22, family: .primary, weight: .bold))
                                        .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                                }
                                .frame(maxWidth: 193.getWidth())
                                .padding(.horizontal, 23)
                                .padding(.vertical, 13)
                                .background(ColorToken.emotionSurprise.toColor())
                                .cornerRadius(30)
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                .padding(.vertical, 53)
                .padding(.horizontal, 72)
            }
            .padding(.horizontal, 94.getWidth())
            .padding(.vertical, 164.getHeight())
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}
