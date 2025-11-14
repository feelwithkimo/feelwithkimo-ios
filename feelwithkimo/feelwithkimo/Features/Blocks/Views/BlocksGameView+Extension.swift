//
//  BlocksGameView+ext.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 14/11/25.
//

import SwiftUI

extension BlocksGameView {
    
    var shapesView: some View {
        HStack{
            shapesGuideCard
            shapesOutlineView
        }
        .padding(.horizontal, 160.getWidth())
    }
    
    var shapesGuideCard: some View {
        VStack(spacing: 2){
            
            // card title
            HStack {
                Text("Ayo kita buat bentuk ini!")
                    .font(.app(.largeTitle, family: .primary))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 83.getWidth())
            .padding(.vertical, 13.getHeight())
            .background(ColorToken.coreAccent.toColor())
            
            // shapes in card
            VStack{
                BlocksGameScene()
            }
            .padding(.horizontal, 43.getWidth())
            .padding(.vertical, 23.getHeight())
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .background(Color.white)
        }
        .frame(width: 546.getWidth())
        .background(ColorToken.backgroundSecondary.toColor())
        .cornerRadius(30.getHeight())
        .overlay(
            RoundedRectangle(cornerRadius: 30.getHeight())
                .inset(by: -1)
                .stroke(ColorToken.backgroundSecondary.toColor(), lineWidth: 2)
        )
        
    }
    
    var shapesOutlineView: some View {
        VStack{
            HStack {
                Text("Ayo kita buat\nbentuk ini!")
                    .font(.app(.largeTitle, family: .primary))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    .multilineTextAlignment(.center)
            }
            .background(ColorToken.coreAccent.toColor())
            VStack{
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 150, height: 100)
                HStack{
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 150, height: 100)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 150, height: 100)
                }
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 150, height: 100)
            }
            .padding(.horizontal, 43.getWidth())
            .padding(.vertical, 23.getHeight())
            .background(Color.white)
        }
        .padding(.horizontal, 43.getWidth())
        .cornerRadius(30.getHeight())
    }
    
    var bottomBar: some View {
        HStack{
            Spacer()
            BlocksGameScene()
            Spacer()
        }
        .frame(height: 150.getHeight())
        .padding(.horizontal, 60.getWidth())
        .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 60, style: .continuous)
                        .fill(ColorToken.emotionSadnessAlt.toColor())
                        .offset(y: -7.getHeight())

                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                        .fill(ColorToken.emotionSadness.toColor())
                }
                .padding(.bottom, -50.getHeight())
            )
        .shadow(color: ColorToken.emotionSadness.toColor().opacity(0.2),
                radius: 20, x: 0, y: -15.getHeight())
    }
}
