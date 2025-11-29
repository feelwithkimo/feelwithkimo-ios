//
//  EmotionStoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct BridgingPage<Destination: View>: View {
    var textDialogue: String = ""
    @ObservedObject var storyViewModel: StoryViewModel
    var destination: (() -> Destination)?
    var action: (() -> Void)?
    
    @ViewBuilder
    private func continueLabel(action: (() -> Void)?) -> some View {
        ZStack {
            Image("KimoBubbleButton")
                .resizable()
                .scaledToFit()
                .frame(width: 253.getWidth())
                .padding(0)
            
            HStack(spacing: 20) {
                Image(systemName: "chevron.right")
                        .font(.customFont(size: 28, family: .primary, weight: .bold))
                
                Text(NSLocalizedString("Continue", comment: ""))
                    .font(.customFont(size: 28, family: .primary, weight: .bold))
            }
            .foregroundStyle(ColorToken.textPrimary.toColor())
            .padding(.bottom, 8.getHeight())
        }
        .frame(maxWidth: 253.getWidth())
        .cornerRadius(100)
    }
    
    var body: some View {
        ZStack {
            ColorToken.additionalColorsBlack.toColor()
                .opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    if let destination = destination {
                        NavigationLink {
                            destination()
                        } label: {
                            KimoImage(image: "xmark", width: 80.getWidth())
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 55.getWidth())
                .padding(.top, 44.getHeight())
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            HStack {
                HStack(spacing: 39) {
                    KimoImage(image: "KimoTutorialAsset", width: 512.getWidth())
                    
                    VStack(spacing: 0) {
                        Text(textDialogue)
                            .font(.customFont(size: 22, family: .primary, weight: .regular))
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
}
