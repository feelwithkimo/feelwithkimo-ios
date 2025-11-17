///
///  BlocksGameView.swift
///  feelwithkimo
///
///  Created by Adeline Charlotte Augustinne on 13/11/25.
///

import SwiftUI

struct BlocksGameView: View {
    @StateObject var viewModel: BlocksGameViewModel
    
    let gameCoordinateSpaceName = "blocksGame"
    
    init(level: GameLevel, onComplete: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: BlocksGameViewModel(level: level, onComplete: onComplete))
    }
    
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
            VStack(alignment: .leading) {
                Image("LalaBlocks")
                    .padding(.trailing, 1000.getWidth())
            }
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity)
            
            ZStack {
                ForEach(Array(viewModel.level.templatePlacements.enumerated()), id: \.offset) { index, _ in
                    if let placed = viewModel.placedMap[index] {
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
            
            VStack {
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
            Task { @MainActor in
                viewModel.updateTemplateFrames(from: pref)
            }
        }
        .onPreferenceChange(BottomFramePreferenceKey.self) { pref in
            Task { @MainActor in
                viewModel.updateBottomFrames(from: pref)
            }
        }
        .overlay(
            Group {
                if let loc = viewModel.burstLocation {
                    StarBurstView(center: loc)
                }
            }
        )
    }
}

#Preview {
    BlocksGameView(level: .level1)
}
