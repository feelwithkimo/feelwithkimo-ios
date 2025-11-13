//
//  BlocksGameView.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 13/11/25.
//

import SwiftUI

struct BlocksGameView: View {
    var body: some View {
        ZStack{
            ColorToken.backgroundHome.toColor()
            VStack{
                Spacer()
                shapesView
                Spacer()
                Rectangle()
                    .fill(ColorToken.backgroundHome.toColor())
                    .frame(width: .infinity, height: 175.getHeight())
            }
            VStack{
                Spacer()
                bottomBar
            }
        }
        .ignoresSafeArea(edges: .all)
    }
    
    private var shapesView: some View {
        HStack{
            shapesGuideCard
            shapesOutlineView
        }
        .padding(.vertical, 44.getHeight())
        .padding(.horizontal, 160.getWidth())
    }
    
    private var shapesGuideCard: some View {
        VStack(spacing: 0){
            
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
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .background(Color.white)
        }
        .frame(width: 546.getWidth())
        .background(Color.white)
        .cornerRadius(30.getHeight())
    }
    
    private var shapesOutlineView: some View {
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
    
    private var bottomBar: some View {
        HStack{
            Spacer()
            Circle()
                .padding(.horizontal, 30.getWidth())
            Circle()
                .padding(.horizontal, 30.getWidth())
            Circle()
                .padding(.horizontal, 30.getWidth())
            Circle()
                .padding(.horizontal, 30.getWidth())
            Spacer()
        }
        .frame(height: 150.getHeight())
        .padding(.vertical, 25.getHeight())
        .contentMargins(.horizontal, 60.getWidth())
        .background(
            RoundedRectangle(cornerRadius: 50.getHeight(), style: .continuous)
                .fill(ColorToken.emotionSadness.toColor())
                .padding(.bottom, -50.getHeight())
        )
    }
}

#Preview {
    BlocksGameView()
}
