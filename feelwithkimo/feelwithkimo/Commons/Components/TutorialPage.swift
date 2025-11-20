//
//  TutorialPage.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 19/11/25.
//

import SwiftUI

struct TutorialPage: View {
    var textDialogue: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Text("Ketuk bagian mana pun di layar untuk lanjut.")
                    .font(.customFont(size: 28, weight: .bold))
                    .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                    .padding(.top, 60.getHeight())
                
                Spacer()
                
                HStack(spacing: 39) {
                    VStack {
                        Spacer()
                        
                        KimoImage(image: "KimoTutorial", width: 693.getWidth())
                            .offset(y: 25.getHeight())
                    }
                    
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
                    }
                }
                .padding(.top, 53)
                .padding(.horizontal, 72)
            }
        }
    }
}

#Preview {
    TutorialPage(textDialogue: "Hello")
}
