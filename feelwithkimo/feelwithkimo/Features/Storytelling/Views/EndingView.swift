//
//  EndingView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 30/10/25.
//

import SwiftUI

extension StoryView {
    func endSceneOverlay(dismiss: @escaping () -> Void, replay: @escaping () -> Void) -> some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                HStack(spacing: 10) {
                    KimoImage(image: "Kimo", width: 400.getWidth())
                    
                    VStack {
                        Spacer()
                        
                        KimoImage(image: "Closing", width: 594.getWidth())
                    }
                    .padding(.bottom, 36.getHeight())
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: dismiss) {
                        HStack {
                            Image(systemName: "arrow.right.square")
                                .font(.app(.title1, family: .primary))
                            
                            Text("Keluar")
                                .font(.app(.title1, family: .primary))
                        }
                        .padding()
                        .background(ColorToken.corePinkStory.toColor().opacity(0.8))
                        .foregroundStyle(ColorToken.additionalColorsBlack.toColor())
                        .cornerRadius(50)
                    }
                    
                    Button(action: replay) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .font(.app(.title1, family: .primary))
                            Text("Mulai Lagi")
                                .font(.app(.title1, family: .primary))
                        }
                        .padding()
                        .background(ColorToken.corePinkStory.toColor().opacity(0.8))
                        .foregroundStyle(ColorToken.additionalColorsBlack.toColor())
                        .cornerRadius(50)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 94.getWidth())
            .padding(.vertical, 164.getHeight())
        }
    }
}

#Preview {
    StoryView()
}
