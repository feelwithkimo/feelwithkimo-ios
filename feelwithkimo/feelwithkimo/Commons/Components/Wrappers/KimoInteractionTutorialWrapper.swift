//
//  KimoInteractionTutorialWrapper.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 25/11/25.
//

import SwiftUI

struct KimoInteractionTutorialWrapper<Content: View>: View {
    let title: String
    let quotePrefix: String
    let quoteBody: String
    let action: (() -> Void)?
    @ViewBuilder let content: Content
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            VStack {
                HStack {
                    KimoCloseButton(
                        isLarge: false,
                        action: action
                    )
                    
                    Spacer()
                    
                    KimoMuteButton(isLarge: false, audioManager: AudioManager.shared)
                }
                .padding(.horizontal, 55.getWidth())
                .padding(.top, 44.getHeight())
                
                Spacer()
            }

            VStack(spacing: 40) {
                Spacer()
                VStack(spacing: 40.getHeight()) {
                    VStack(spacing: 25.getHeight()) {
                        Text(title)
                            .font(.customFont(size: 34, family: .primary, weight: .bold))
                            .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                        
                        content
                    }
                    
                    (Text(quotePrefix)
                        .font(.customFont(size: 17, family: .primary, weight: .bold))
                     +
                     Text(quoteBody)
                        .font(.customFont(size: 17, family: .primary, weight: .regular)))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    .lineLimit(3)
                    .frame(width: 604.getWidth())
                    .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 38)
                .padding(.vertical, 30)
                .background(Color.white)
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(ColorToken.corePinkDialogue.toColor(), lineWidth: 5)
                )
                .shadow(color: ColorToken.backgroundSecondary.toColor().opacity(0.25), radius: 18.3, x: 4, y: 4)
                Spacer()
            }
            .padding(.vertical, 60)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    KimoInteractionTutorialWrapper(
        title: "Cara latihan pernafasan",
        quotePrefix: "Menurut Dokter Weil, ",
        quoteBody: "Latihan pernapasan ini membantu menenangkan sistem saraf secara alami. " +
                    "Semakin rutin dilakukan, semakin mudah anak mengatur rasa cemas dan menenangkan tubuhnya.",
        action: {},
        content: {
            VStack {
                ForEach(0..<4) {_ in
                    Text("Test")
                }
            }
        }
    )
}
