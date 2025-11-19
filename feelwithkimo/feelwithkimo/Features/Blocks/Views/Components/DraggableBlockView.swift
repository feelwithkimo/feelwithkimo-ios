//
//  DraggableBlockView.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 18/11/25.
//

import SwiftUI

struct DraggableBlockView: View {
    let placement: BlockPlacement
    let block: BlockModel
    let viewModel: BlocksGameViewModel
    let gameCoordinateSpaceName: String
    let dragGesture: (BlockModel) -> _EndedGesture<_ChangedGesture<DragGesture>>
    private var currentScale: CGFloat {
        viewModel.currentDragBlock?.id == block.id ? 1.0 : 0.8
    }
    
    var body: some View {
        shape(for: block.type)
            .fill(block.baseColor)
            .overlay(
                shape(for: block.type)
                    .stroke(block.strokeColor, lineWidth: 2)
            )
            .frame(width: placement.size.width, height: placement.size.height)
            .contentShape(Rectangle())
            .offset(currentOffset)
            .animation(.spring(), value: viewModel.snappingBlockId)
            .zIndex(viewModel.currentDragBlock?.id == block.id ? 100 : 0)
            .background(frameReader)
            .gesture(dragGesture(block))
            .scaleEffect(currentScale)
            .animation(.spring(response: 0.3, dampingFraction: 0.7),
                       value: viewModel.currentDragBlock?.id)
    }
    
    private var currentOffset: CGSize {
        if viewModel.currentDragBlock?.id == block.id {
            return viewModel.dragTranslation
        }
        
        if viewModel.snappingBlockId == block.id,
           let target = viewModel.snapTarget,
           let myFrame = viewModel.bottomFrames[block.id] {
                        
            let deltaX = target.x - myFrame.midX / 2
            let deltaY = target.y - myFrame.midY

            return CGSize(width: deltaX, height: deltaY)
        }
        
        return .zero
    }
    
    private var frameReader: some View {
        GeometryReader { geo in
            Color.clear.preference(
                key: FramePreferenceKey.self,
                value: [block.id: geo.frame(in: .named(gameCoordinateSpaceName))]
            )
        }
        .onPreferenceChange(FramePreferenceKey.self) { prefs in
            Task { @MainActor in
                for (id, frame) in prefs {
                    viewModel.bottomFrames[id] = frame
                }
            }
        }
        .allowsHitTesting(false)
    }
}
