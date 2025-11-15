//
//  BlocksGameView.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 13/11/25.
//

import SwiftUI

struct BlocksGameView: View {
    @StateObject var viewModel = BlocksGameViewModel(level: .level1)
    
    let gameCoordinateSpaceName = "blocksGame"
    
    @State var currentDragBlock: BlockModel?
    @State var dragTranslation: CGSize = .zero
    @State var dragStartLocationInGame: CGPoint?
    
    var body: some View {
        ZStack {
            ColorToken.backgroundHome.toColor()
            VStack(alignment: .leading) {
                Spacer()
                
                shapesView

                Spacer()
                
                Rectangle()
                    .foregroundStyle(ColorToken.backgroundHome.toColor())
                    .frame(height: 150.getHeight())
                    .frame(maxWidth: .infinity)
            }
            // TODO: resolve lala padding positino
            VStack(alignment: .leading) {
                Image("LalaBlocks")
                    .padding(.trailing, 1000.getWidth())
            }
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity)
            
            ZStack {
                ForEach(Array(viewModel.level.templatePlacements.enumerated()), id: \.offset) { index, template in
                    if let placed = viewModel.placedMap[index] {
                        // show placed block at the template frame when it's available
                        if let frame = viewModel.templateFrames[index] {
                            shape(for: placed.type)
                                .fill(placed.color)
                                .overlay(shape(for: placed.type).stroke(ColorToken.additionalColorsBlack.toColor(), lineWidth: 2))
                                .frame(width: frame.width, height: frame.height)
                                .position(x: frame.midX, y: frame.midY)
                                .animation(.spring(), value: viewModel.placedMap)
                        }
                    }
                }
            }
            
            VStack{
                Spacer()
                bottomBar(
                        placements: viewModel.bottomBlocks.map { block in
                            let size = viewModel.blockSizes[block.id] ?? CGSize(width: 120, height: 120)
                            return BlockPlacement(block: block, position: .zero, size: size)
                        }
                    )
            }
        }
        .coordinateSpace(name: gameCoordinateSpaceName)
        .ignoresSafeArea(edges: .all)
        .onPreferenceChange(FramePreferenceKey.self) { pref in
            var indexToFrame: [Int: CGRect] = [:]
            for (i, placement) in GameLevel.level1.templatePlacements.enumerated() {
                if let frame = pref[placement.block.id] {
                    indexToFrame[i] = frame
                }
            }
            if indexToFrame != viewModel.templateFrames {
                viewModel.templateFrames = indexToFrame
            }
        }
        .onPreferenceChange(BottomFramePreferenceKey.self) { pref in
            if pref != viewModel.bottomFrames {
                viewModel.bottomFrames = pref
            }
        }
    }
}

#Preview {
    BlocksGameView()
}
