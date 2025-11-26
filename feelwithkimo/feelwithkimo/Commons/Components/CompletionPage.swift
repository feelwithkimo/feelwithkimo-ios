//
//  EmotionStoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct CompletionPage: View {
    var textDialogue: String = ""
    
    var body: some View {
        ZStack {
            ColorToken.backgroundCard.toColor().opacity(0.8)
            
            HStack {
                HStack(spacing: 39) {
                    KimoImage(image: "KimoTutorialAsset", width: 512.getWidth())
                    
                    VStack(spacing: 0) {
                        Text(textDialogue)
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
                            HStack {
                                Image(systemName: "arrow.trianglehead.2.clockwise")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                                    .frame(maxWidth: 28, maxHeight: 28)
                                
                                Text(NSLocalizedString("Try_Again", comment: ""))
                                    .font(.customFont(size: 28, family: .primary, weight: .bold))
                                    .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                            }
                            .frame(maxWidth: 193.getWidth())
                            .padding(.horizontal, 23)
                            .padding(.vertical, 13)
                            .background(ColorToken.emotionSurprise.toColor())
                            .cornerRadius(30)
                            
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
                        .padding(.top, 20)
                    }
                }
                .padding(.top, 53)
                .padding(.horizontal, 72)
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CompletionPage(textDialogue: "Wihh ternyata begitu ekspresi marah..")
}
