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
            ColorToken.grayscale30.toColor().opacity(0.7)
            
            VStack {
                Spacer()
                
                HStack(spacing: 10) {
                    Image("Kimo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400.getWidth())
                    
                    VStack {
                        Spacer()
                        
                        Image("Closing")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 594.getWidth())
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
                        .background(ColorToken.grayscale40.toColor().opacity(0.8))
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
                        .background(ColorToken.grayscale40.toColor().opacity(0.8))
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
