//
//  ScaffoldingView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 25/11/25.
//

import SwiftUI

struct ScaffoldingView: View {
    @ObservedObject var storyViewModel: StoryViewModel
    @ObservedObject var accessibilityManager: AccessibilityManager
    
    var body: some View {
        ZStack {
            ColorToken.additionalColorsBlack.toColor()
                .opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    KimoCloseButton(action: {
                        storyViewModel.goScene(to: -1)
                    })
                    
                    Spacer()
                }
                .padding(.horizontal, 55.getWidth())
                .padding(.top, 44.getHeight())
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            VStack(spacing: 0) {
                Spacer()
                
                HStack(spacing: 0) {
                    KimoImage(image: "KimoScaffolding", width: 0.65 * UIScreen.main.bounds.width)
                        .frame(height: 750.getHeight())
                        .padding(.trailing, 8.getWidth())
                        .offset(y: 30.getHeight())
                    
                    VStack(spacing: 0) {
                        Text(storyViewModel.currentScene.text)
                            .font(.customFont(size: 22, family: .primary, weight: .bold))
                            .fontWeight(.regular)
                            .frame(maxWidth: 394.getWidth())
                            .padding(.horizontal, 30.getWidth())
                            .padding(.vertical, 40.getHeight())
                            .background(ColorToken.corePinkDialogue.toColor())
                            .cornerRadius(30)
                        
                        HStack {
                            KimoImage(image: "KimoDialogueTriangle", width: 157.getWidth())
                            Spacer()
                        }
                        
                        if let question = storyViewModel.currentScene.question {
                            HStack {
                                Spacer()
                                
                                OptionChoiceButton(buttonImage: question.option[1], buttonImageSize: 150, title: "") {
                                    storyViewModel.goScene(to: 1, choice: 0)
                                    accessibilityManager.announce("Memilih: \(question.option[1])")
                                }
                                
                                Spacer()
                                
                                OptionChoiceButton(buttonImage: question.option[0], buttonImageSize: 150, title: "") {
                                    storyViewModel.goScene(to: 1, choice: 0)
                                    accessibilityManager.announce("Memilih: \(question.option[0])")
                                }
                                
                                Spacer()
                            }
                            .padding(.top, 10.getHeight())
                        }
                    }
                    .padding(.trailing, 55.getWidth())
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
    
    private struct OptionChoiceButton: View {
        let buttonImage: String
        let buttonImageSize: Int
        let title: String
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                ZStack(alignment: .center) {
                    KimoImage(image: buttonImage, width: buttonImageSize.getWidth())
                    Text(title)
                        .font(.customFont(size: 28, family: .primary, weight: .bold))
                        .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 380.getWidth())
                }
            }
        }
    }
}
