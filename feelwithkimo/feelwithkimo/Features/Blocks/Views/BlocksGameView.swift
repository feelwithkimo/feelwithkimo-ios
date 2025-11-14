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
            VStack(alignment: .leading){
                Spacer()
                
                shapesView
                    .padding(.top, 44.getHeight())
                    .padding(.bottom, 44.getHeight())
                    .padding(.leading, 252.getWidth())
                Spacer()
                
                Rectangle()
                    .foregroundStyle(ColorToken.backgroundHome.toColor())
                    .frame(height: 150.getHeight())
                    .frame(width: .infinity)
            }
            VStack(alignment: .leading) {
                Image("LalaBlocks")
                    .padding(.trailing, 1000.getWidth())
            }
            .frame(height: .infinity)
            .frame(width: .infinity)
            VStack{
                Spacer()
                bottomBar(placements: GameLevel.level1.templatePlacements)
            }
        }
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    BlocksGameView()
}
