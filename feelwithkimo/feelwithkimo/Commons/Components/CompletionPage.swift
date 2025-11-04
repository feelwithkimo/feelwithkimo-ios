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
                    Image("KimoEmotionStory")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 512 * UIScreen.main.bounds.width / 1194)
                    
                    VStack(spacing: 0) {
                        Text(textDialogue)
                            .frame(maxWidth: 500 * UIScreen.main.bounds.width / 1194)
                            .padding(.horizontal, 49 * UIScreen.main.bounds.width / 1194)
                            .padding(.vertical, 42.5 * UIScreen.main.bounds.height / 834)
                            .background(ColorToken.corePinkDialogue.toColor())
                            .cornerRadius(30)
                        
                        HStack {
                            Image("KimoDialogue")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 157 * UIScreen.main.bounds.width / 1194)
                            
                            Spacer()
                        }
                        
                        HStack(spacing: 50) {
                            HStack {
                                Image(systemName: "arrow.trianglehead.2.clockwise")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                                    .frame(maxWidth: 28, maxHeight: 28)
                                
                                Text("Coba Lagi")
                                    .font(.app(.title1, family: .primary))
                                    .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                            }
                            .frame(maxWidth: 193 * UIScreen.main.bounds.width / 1194)
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

                                Text("Lanjutkan")
                                    .font(.app(.title1, family: .primary))
                                    .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                            }
                            .frame(maxWidth: 193 * UIScreen.main.bounds.width / 1194)
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
