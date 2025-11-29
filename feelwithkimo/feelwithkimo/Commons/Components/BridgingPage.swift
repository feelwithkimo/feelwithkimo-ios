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
    var isOverlayed: Bool = true
    
    @ViewBuilder
    private func continueLabel() -> some View {
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
            if isOverlayed {
                ColorToken.additionalColorsBlack.toColor()
                    .opacity(0.8)
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button(action: {
                        storyViewModel.goScene(to: -1)
                    }, label: {
                        KimoImage(image: "xmark", width: 80.getWidth())
                    })
                    
                    Spacer()
                }
                .padding(.horizontal, 55.getWidth())
                .padding(.top, 44.getHeight())
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            HStack(spacing: 39) {
                VStack(spacing: 0) {
                    Spacer()
                    KimoImage(image: "KimoBridging", width: 693.getWidth())
                }

                VStack(spacing: 0) {
                    // Dialogue bubble
                    Text(textDialogue)
                        .font(.customFont(size: 20, family: .primary, weight: .regular))
                        .frame(maxWidth: 500.getWidth())
                        .padding(.horizontal, 49.getWidth())
                        .padding(.vertical, 42.getHeight())
                        .background(ColorToken.corePinkDialogue.toColor())
                        .cornerRadius(30)

                    // Tail image
                    HStack {
                        KimoImage(image: "KimoDialogue", width: 74.getWidth())
                        Spacer()
                    }

                    // Continue button
                    HStack(spacing: 50) {
                        Spacer()

                        if let destination = destination {
                            NavigationLink {
                                destination()
                            } label: {
                                continueLabel()
                            }
                        } else {
                            Button {
                                action?()
                            } label: {
                                continueLabel()
                            }
                        }
                    }
                    .padding(.top, 20.getHeight())
                }
            }
            .ignoresSafeArea()
            .padding(.top, 53)
            .padding(.horizontal, 41.getWidth())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
}
