///
///  BlocksGameView+ext.swift
///  feelwithkimo
///
///  Created by Adeline Charlotte Augustinne on 14/11/25.
///

import SwiftUI

extension BlocksGameView {
    
    func renderShapesBar() -> some View {
        VStack {
            renderDraggableShapes(placements: viewModel.bottomBlocks.map { block in
                let size = viewModel.blockSizes[block.id] ?? CGSize(width: 120, height: 120)
                return BlockPlacement(block: block, position: .zero, size: size)
            })
        }
        .frame(width: 300.getWidth(), height: 658.getHeight())
        .background {
            Rectangle()
                .foregroundStyle(ColorToken.corePinkDialogue.toColor())
                .cornerRadius(26.71)
                .overlay(
                    RoundedRectangle(cornerRadius: 26.71)
                        .stroke(ColorToken.additionalColorsLightBlue.toColor(), lineWidth: 6)
                )
        }
    }
    
    func renderShapesOutline() -> some View {
        VStack {
            renderShapes(
                placements: viewModel.level.templatePlacements,
                revealMode: true,
                revealIndex: viewModel.revealIndex
            )
        }
        .frame(width: 422.getWidth(), height: 692.getHeight())
        .background {
            Rectangle()
                .foregroundStyle(ColorToken.corePinkDialogue.toColor())
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
        }
    }
    
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
        
        // MARK: - Extracted offset computation
        private var currentOffset: CGSize {
            if viewModel.currentDragBlock?.id == block.id {
                return viewModel.dragTranslation
            }
            
            if viewModel.snappingBlockId == block.id,
               let target = viewModel.snapTarget,
               let myFrame = viewModel.bottomFrames[block.id] {
                
                print("myFrame mids: ", myFrame.midX, myFrame.midY)
                
                let deltaX = target.x - myFrame.midX / 2
                let deltaY = target.y - myFrame.midY

                return CGSize(width: deltaX, height: deltaY)
            }
            
            return .zero
        }
        
        // MARK: - Extracted frame reader
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
    
    func renderDraggableShapes(placements: [BlockPlacement]) -> some View {
        VStack(alignment: .center) {
            ForEach(placements, id: \.block.id) { placement in
                DraggableBlockView(
                    placement: placement,
                    block: placement.block,
                    viewModel: viewModel,
                    gameCoordinateSpaceName: gameCoordinateSpaceName,
                    dragGesture: dragGesture
                )
            }
        }
    }
    
    func dragGesture(block: BlockModel) -> _EndedGesture<_ChangedGesture<DragGesture>> {
        DragGesture()
            .onChanged { geo in
                if viewModel.currentDragBlock == nil {
                    viewModel.currentDragBlock = block
                }
                viewModel.dragTranslation = geo.translation
            }
            .onEnded { geo in
                guard let dragging = viewModel.currentDragBlock else { return }
                
                /// get bottom frame for this dragging item (in same coordinate space)
                if let bottomFrame = viewModel.bottomFrames[dragging.id] {
                    let startCenter = CGPoint(x: bottomFrame.midX, y: bottomFrame.midY)
                    let endPoint = CGPoint(x: startCenter.x + geo.translation.width,
                                           y: startCenter.y + geo.translation.height)
                    if viewModel.handleDragEnd(block: dragging, at: endPoint) {
                        withAnimation(.spring()) {
                            viewModel.currentDragBlock = nil
                            viewModel.dragTranslation = .zero
                        }
                        
                        showStarBurst(at: endPoint)
                    } else {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) {
                            viewModel.currentDragBlock = nil
                            viewModel.dragTranslation = .zero
                        }
                    }
                } else {
                    /// bottom frame not known yet
                    withAnimation(.spring()) {
                        viewModel.currentDragBlock = nil
                        viewModel.dragTranslation = .zero
                    }
                }
            }
    }
    
    func hintBlockView(_ placement: BlockPlacement, index: Int) -> some View {
        shape(for: placement.block.type)
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [25]))
            .foregroundColor(ColorToken.backgroundSecondary.toColor())
            .frame(width: placement.size.width, height: placement.size.height)
            .offset(x: placement.position.x, y: placement.position.y)
            .readPosition { frame in
                let finalX = frame.origin.x + placement.position.x + placement.size.width / 2
                let finalY = frame.origin.y + placement.position.y + placement.size.height / 2
                
                if index < viewModel.templatePositions.count {
                    viewModel.templatePositions[index].point = CGPoint(x: finalX, y: finalY)
                } else {
                    print("templatePosition ", placement.block.type, finalX, finalY)
                    viewModel.templatePositions.append(
                        (shapeType: placement.block.type,
                         point: CGPoint(x: finalX, y: finalY))
                    )
                }
            }
    }
    
    func solidBlockView(_ placement: BlockPlacement) -> some View {
        shape(for: placement.block.type)
            .fill(placement.block.baseColor)
            .overlay(
                shape(for: placement.block.type)
                    .stroke(placement.block.strokeColor, lineWidth: 2)
            )
            .frame(width: placement.size.width, height: placement.size.height)
            .offset(x: placement.position.x, y: placement.position.y)
    }
    
    func renderShapes(
        placements: [BlockPlacement],
        revealMode: Bool = false,
        revealIndex: Int? = nil
    ) -> some View {
        let maxX = placements.map { $0.position.x + $0.size.width }.max() ?? 0
        let maxY = placements.map { $0.position.y + $0.size.height }.max() ?? 0
        
        return ZStack(alignment: .topLeading) {
            ForEach(Array(placements.enumerated()), id: \.element.block.id) { index, placement in
                
                let isHint = revealMode && revealIndex == index
                let isAfterHint = revealMode && revealIndex != nil && index > (revealIndex ?? -1)
                
                if !isAfterHint {
                    if isHint {
                        hintBlockView(placement, index: index)
                    } else {
                        solidBlockView(placement)
                    }
                }
            }
        }
        .frame(width: maxX, height: maxY, alignment: .topLeading)
//        .border(.red)
    }
    
    func shapesOutlineView(blockPlacements: [BlockPlacement]) -> some View {
        return VStack(alignment: .center) {
            Spacer()
            VStack {
                renderShapes(
                    placements: blockPlacements,
                    revealMode: true,
                    revealIndex: viewModel.revealIndex
                )
            }
        }
    }
    
    func showStarBurst(at point: CGPoint) {
        viewModel.burstLocation = point
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            viewModel.burstLocation = nil
        }
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGRect] = [:]
    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct ViewPositionKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

#Preview("Blocks Game View") {
    BlocksGameView(level: .level1)
}
