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

// Tutorial
extension StoryView {
    func firstTutorialView() -> some View {
        VStack(alignment: .center) {
            Text(NSLocalizedString("TapAnywhere", comment: ""))
                .font(.customFont(size: 28, weight: .bold))
                .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                .padding(.top, 60.getHeight())

            Spacer()
            
            HStack(alignment: .bottom, spacing: 0) {
                Spacer()
                
                TutorialBubble()
                
                KimoImage(image: "TextDialogueRight", width: 59.getWidth())
                    .padding(.bottom, 10.getHeight())
                    .padding(.trailing, 19.getWidth())

                KimoImage(image: "Kimo", width: 150.getWidth())
                    .padding(.trailing, 79)
            }
            
            KimoImage(image: "Point", width: 125.getWidth())
                .offset(y: moveButton ? -10 : 10)
                .animation(
                    Animation.easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true),
                    value: moveButton
                )
                .onAppear {
                    moveButton.toggle()
                }
            
            ZStack {
                Image("Outline")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 877.getWidth(), height: 155.getHeight())
                    .padding(.horizontal, 159.getWidth())
                    .padding(.top, 11.getHeight())
                
                NarrationCard(text: viewModel.currentScene.text)
            }
        }
        .padding(.bottom, 50.getHeight())
    }
    
    func secondTutorialView() -> some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                KimoImage(image: "Kimo", width: 150.getWidth())
                    .padding(.top, 51.getHeight())
                    .padding(.trailing, 9.getWidth())
                
                KimoImage(image: "TextDialogueLeft", width: 59.getWidth())
                    .padding(.top, 71.getHeight())
                
                // Text
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("Kimo_Tutorial_Text_1", comment: ""))
                        .font(.customFont(size: 20, family: .primary, weight: .regular))
                    
                    Text(NSLocalizedString("Kimo_Tutorial_Text_2", comment: ""))
                        .font(.customFont(size: 20, family: .primary, weight: .regular))
                }
                .frame(maxWidth: 564)
                .padding(.vertical, 24)
                .padding(.horizontal, 15)
                .background(ColorToken.corePinkDialogue.toColor())
                .cornerRadius(20)
                .padding(.trailing, 18)
                .padding(.top, 71)
                
                KimoImage(image: "Point_2", width: 125.getWidth())
                    .padding(.top, 45.getHeight())
                    .offset(x: moveButton ? -10 : 10)
                    .animation(
                        Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                        value: moveButton
                    )
                    .onAppear {
                        moveButton.toggle()
                    }
                
                KimoImage(image: "KimoVisual", width: 105.getWidth())
                    .padding(.top, 45.getHeight())
                    .padding(.bottom, 71.getHeight())
            }
            .padding(.bottom, 175.getHeight())
        }
        .padding(.leading, 112.getWidth())
        .padding(.trailing, 33.getWidth())
    }
    
    func thirdTutorialView() -> some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                KimoImage(image: "Kimo", width: 150.getWidth())
                    .padding(.top, 51.getHeight())
                    .padding(.trailing, 9.getWidth())
                
                KimoImage(image: "TextDialogueLeft", width: 59.getWidth())
                    .padding(.top, 71.getHeight())
                
                // Text
                Text(NSLocalizedString("Tutorial_Text_3", comment: ""))
                    .font(.customFont(size: 20, family: .primary, weight: .regular))
                    .frame(maxWidth: 564)
                    .padding(.vertical, 24)
                    .padding(.horizontal, 15)
                    .background(ColorToken.corePinkDialogue.toColor())
                    .cornerRadius(20)
                    .padding(.trailing, 18)
                    .padding(.top, 71)
                
                KimoImage(image: "Point_2", width: 125.getWidth())
                    .padding(.top, 45.getHeight())
                    .offset(x: moveButton ? -10 : 10)
                    .animation(
                        Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                        value: moveButton
                    )
                    .onAppear {
                        moveButton.toggle()
                    }
                
                KimoImage(image: "KimoVisual", width: 105.getWidth())
                    .padding(.bottom, 71.getHeight())
            }
            .padding(.bottom, 175.getHeight())
        }
        .padding(.leading, 112.getWidth())
        .padding(.trailing, 33.getWidth())
    }
}
