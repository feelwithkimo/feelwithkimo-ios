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
                                hint: viewModel.currentScene.isEnd ? "Ketuk dua kali untuk mengakhiri cerita dan kembali" :
                                    "Ketuk dua kali untuk melanjutkan ke adegan berikutnya",
                                identifier: "story.nextButton"
                            )
                    })
                } else if viewModel.currentScene.isEnd {
                    Spacer()
                        .frame(width: 100.getWidth())
                }
            }
            .padding(.bottom, 50.getHeight())
            .padding(.horizontal, 57.getWidth())
        }
    }
    
    func narrationBox() -> some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(ColorToken.additionalColorsWhite.toColor())
            .overlay(
                Text(viewModel.currentScene.text)
                    .font(.app(.headline, family: .primary))
                    .foregroundColor(ColorToken.additionalColorsBlack.toColor())
                    .padding(.horizontal, 45.getWidth())
                    .padding(.vertical, 32.getHeight())
                    .multilineTextAlignment(.center)
                    .kimoTextAccessibility(
                        label: "Narasi: \(viewModel.currentScene.text)",
                        identifier: "story.narration.text"
                    ),
                alignment: .center
            )
            .frame(
                width: 840.getWidth(),
                height: 120.getHeight()
            )
    }
    
    private struct OptionChoiceButton: View {
        let title: String
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                ZStack(alignment: .center) {
                    KimoImage(image: "OptionButton", width: 442.getWidth())
                    Text(title)
                        .font(.app(.title1, family: .primary))
                        .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 380.getWidth()) // keep text within bounds
                }
            }
        }
    }
    
    func questionView() -> some View {
        VStack(spacing: 0) {
            Spacer()
            
            HStack(spacing: 0) {
                KimoImage(image: "KimoStoryBranching", width: 504.getWidth())
                    .padding(.trailing, 29.getWidth())
                
                VStack(spacing: 0) {
                    Text("Wah, Lala marah sekali! Menurutmu di sini, apa yang sebaiknya Lala lakukan?")
                        .font(.app(.title2, family: .primary))
                        .fontWeight(.regular)
                        .frame(maxWidth: 394.getWidth())
                        .padding(.horizontal, 30.getWidth())
                        .padding(.vertical, 40.getHeight())
                        .background(ColorToken.corePinkDialogue.toColor())
                        .cornerRadius(30)
                    
                    HStack {
                        KimoImage(image: "KimoDialogue", width: 157.getWidth())
                        Spacer()
                    }
                }
            }
            
            HStack(spacing: 0) {
                Button(action: {
                    viewModel.goScene(to: -1)
                }, label: {
                    KimoImage(image: "PreviousScene", width: 100.getWidth())
                        .padding(.trailing, 37.getWidth())
                })

                if let question = viewModel.currentScene.question {
                    OptionChoiceButton(title: question.option[0]) {
                        viewModel.goScene(to: 1, choice: 0)
                        accessibilityManager.announce("Memilih: \(question.option[0])")
                    }
                    .padding(.trailing, 50.getWidth())

                    OptionChoiceButton(title: question.option[1]) {
                        viewModel.goScene(to: 1, choice: 1)
                        accessibilityManager.announce("Memilih: \(question.option[1])")
                    }
                }
            }
        }
        .padding(.bottom, 50.getHeight())
        .padding(.horizontal, 57.getWidth())
    }
}

// Tutorial
extension StoryView {
    func firstTutorialView() -> some View {
        VStack(alignment: .center) {
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
            NarrationCard(text: viewModel.currentScene.text, onTap: viewModel.nextTutorial)
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
                    Text("Klik ikon Kimo, ya!")
                        .font(.app(.title3, family: .primary))
                    
                    Text("Kimo akan memberikan petunjuk saat si kecil butuh bantuan")
                        .font(.app(.title3, family: .primary))
                        .fontWeight(.regular)
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
                
                KimoImage(image: "KimoVisual", width: 130.getWidth())
                    .padding(.top, 45.getHeight())
                    .padding(.bottom, 71.getHeight())
                    .onTapGesture {
                        viewModel.nextTutorial()
                    }
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
                Text("dan juga komentar seru untuk menemani si kecil sepanjang cerita!...")
                    .font(.app(.title3, family: .primary))
                    .fontWeight(.regular)
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
                    .onTapGesture {
                        viewModel.nextTutorial()
                    }
            }
            .padding(.bottom, 175.getHeight())
        }
        .padding(.leading, 112.getWidth())
        .padding(.trailing, 33.getWidth())
    }
}
