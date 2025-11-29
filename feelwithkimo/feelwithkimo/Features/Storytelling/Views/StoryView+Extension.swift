//
//  StoryView+Ext.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 06/11/25.
//

import SwiftUI

extension StoryView {
    func storySceneView() -> some View {
        VStack(alignment: .center) {
            Spacer()
            
            HStack(spacing: 0) {
                if viewModel.currentScene.nextScene.count > 1 || viewModel.currentScene.isEnd {
                    Button(action: {
                        viewModel.goScene(to: -1, choice: 0)
                        accessibilityManager.announce("Kembali ke adegan sebelumnya")
                    }, label: {
                        KimoImage(image: "PreviousScene", width: 100.getWidth())
                            .kimoButtonAccessibility(
                                label: "Adegan sebelumnya",
                                hint: "Ketuk dua kali untuk kembali ke adegan sebelumnya",
                                identifier: "story.previousButton"
                            )
                    })
                } else {
                    Spacer()
                        .frame(width: 100.getWidth())
                }
                
                narrationBox()
                    .padding(.horizontal, 20.getWidth())
                
                // Next Scene Button
                if viewModel.currentScene.nextScene.count >= 1 && !viewModel.currentScene.isEnd {
                    Button(action: {
                        guard !viewModel.currentScene.isEnd else {
                            accessibilityManager.announce("Cerita selesai. Kembali ke halaman sebelumnya.")
                            dismiss()
                            return
                        }
                        viewModel.goScene(to: 1, choice: 0)
                        accessibilityManager.announce("Melanjutkan ke adegan berikutnya")
                    }, label: {
                        KimoImage(image: "NextScene", width: 100.getWidth())
                            .kimoButtonAccessibility(
                                label: viewModel.currentScene.isEnd ? "Selesai" : "Adegan berikutnya",
                                hint: viewModel.currentScene.isEnd ? "Ketuk dua kali untuk mengakhiri cerita dan kembali" : "Ketuk dua kali untuk melanjutkan ke adegan berikutnya",
                                identifier: "story.nextButton"
                            )
                    })
                } else if viewModel.currentScene.isEnd {
                    Spacer()
                        .frame(width: 100.getWidth())
                }
            }
            .padding(.bottom, 49.getHeight())
            .padding(.horizontal, 57.getWidth())
        }
    }
    
    func narrationBox() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(ColorToken.backgroundSecondary.toColor())
                .frame(width: 840.getWidth(), height: 120.getHeight())
                .offset(y: 10)
                .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)

            RoundedRectangle(cornerRadius: 24)
                .fill(ColorToken.additionalColorsWhite.toColor())
                .overlay(
                    Text(viewModel.currentScene.text)
                        .font(.customFont(size: 22, family: .primary, weight: .bold))
                        .foregroundColor(ColorToken.additionalColorsBlack.toColor())
                        .padding(.horizontal, 24.getWidth())
                        .padding(.vertical, 16.getHeight())
                        .multilineTextAlignment(.center)
                        .kimoTextAccessibility(label: "Narasi: \(viewModel.currentScene.text)", identifier: "story.narration.text"),
                    alignment: .center
                )
                .frame(
                    width: 840.getWidth(),
                    height: 120.getHeight()
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.black.opacity(0.5), lineWidth: 4)
                        .blur(radius: 6)
                        .offset(x: 0, y: 3)
                        .mask(
                            RoundedRectangle(cornerRadius: 24)
                        )
                )
        }
    }
}
