//
//  EmotionStoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct BridgingPage<Destination: View>: View {
    var textDialogue: String = ""
    var destination: (() -> Destination)?
    var action: (() -> Void)?
    
    @ViewBuilder
    private func continueLabel() -> some View {
        HStack {
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                .frame(maxWidth: 28, maxHeight: 28)

            Text(NSLocalizedString("Continue", comment: ""))
                .font(.customFont(size: 28, family: .primary, weight: .bold))
                .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
        }
        .frame(maxWidth: 193.getWidth())
        .padding(.horizontal, 23)
        .padding(.vertical, 13)
        .background(ColorToken.emotionSurprise.toColor())
        .cornerRadius(30)
    }
    
    var body: some View {
        ZStack {
            HStack {
                HStack(spacing: 39) {
                    KimoImage(image: "KimoTutorialAsset", width: 512.getWidth())
                    
                    VStack(spacing: 0) {
                        Text(textDialogue)
                            .font(.customFont(size: 20, family: .primary, weight: .regular))
                            .frame(maxWidth: 500.getWidth())
                            .padding(.horizontal, 49.getWidth())
                            .padding(.vertical, 42.getHeight())
                            .background(ColorToken.corePinkDialogue.toColor())
                            .cornerRadius(30)
                        
                        HStack {
                            KimoImage(image: "KimoDialogue", width: 157.getWidth())
                            Spacer()
                        }
                        
                        HStack(spacing: 50) {
                            Spacer()
                            
                            if let destination = destination {
                                NavigationLink {
                                    destination()
                                } label: {
                                    continueLabel()
                                }
                            } else {
                                Button(action: {
                                    action?()
                                }, label: {
                                    continueLabel()
                                })
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                .padding(.top, 53)
                .padding(.horizontal, 72)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
}
