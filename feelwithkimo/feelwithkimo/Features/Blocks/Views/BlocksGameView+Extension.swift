///
///  BlocksGameView+ext.swift
///  feelwithkimo
///
///  Created by Adeline Charlotte Augustinne on 14/11/25.
///

import SwiftUI

extension BlocksGameView {
    
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
    
    func hintBlockView(_ placement: BlockPlacement, index: Int) -> some View {
        shape(for: placement.block.type)
            .fill(placement.block.baseColor.opacity(0.3))
            .overlay(
                shape(for: placement.block.type)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [25]))
                    .foregroundColor(ColorToken.backgroundSecondary.toColor())
            )
            .foregroundColor(ColorToken.backgroundSecondary.toColor())
            .frame(width: placement.size.width, height: placement.size.height)
            .offset(x: placement.position.x, y: placement.position.y)
            .readPosition { frame in
                let finalX = frame.origin.x + placement.position.x + placement.size.width / 2
                let finalY = frame.origin.y + placement.position.y + placement.size.height / 2
                
                if index < viewModel.templatePositions.count {
                    viewModel.templatePositions[index].point = CGPoint(x: finalX, y: finalY)
                } else {
                    viewModel.templatePositions.append(
                        (shapeType: placement.block.type,
                         point: CGPoint(x: finalX, y: finalY))
                    )
                }
            }
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
    }
    
    func renderDraggableShapes(placements: [BlockPlacement?]) -> some View {
        VStack(alignment: .center) {
            ForEach(Array(placements.enumerated()), id: \.offset) { _, placement in
                if let placement {
                    DraggableBlockView(
                        placement: placement,
                        block: placement.block,
                        viewModel: viewModel,
                        gameCoordinateSpaceName: gameCoordinateSpaceName,
                        dragGesture: dragGesture
                    )
                    .frame(width: placement.size.width, height: placement.size.height)
                } else {
                    Color.clear
                        .frame(width: 120, height: 120)
                }
            }
        }
    }
    
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
        let prevLevel = GameLevel.allCases.filter { $0 != viewModel.level }
        
        return ZStack {
            Rectangle()
                .foregroundStyle(ColorToken.corePinkDialogue.toColor())
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)

            VStack(alignment: .center, spacing: 30.getHeight()) {
                renderShapes(
                    placements: viewModel.level.templatePlacements,
                    revealMode: true,
                    revealIndex: viewModel.revealIndex
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, viewModel.level == GameLevel.level1 ? 63.getHeight() : 0)
                
                if viewModel.level != GameLevel.level1 {
                    Divider()
                        .overlay(
                            Rectangle()
                                .stroke(style: StrokeStyle(lineWidth: 4, dash: [25]))
                                .foregroundColor(ColorToken.backgroundSecondary.toColor())
                        )
                        .frame(width: 300.getWidth())

                    renderShapes(placements: prevLevel[0].templatePlacements)
                        .frame(height: 150)
                        .clipped()
                }
            }
            .padding()
        }
        .frame(width: 422.getWidth(), height: 692.getHeight())
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
                
                // get bottom frame for this dragging item (in same coordinate space)
                if let bottomFrame = viewModel.bottomFrames[dragging.id] {
                    let startCenter = CGPoint(x: bottomFrame.midX, y: bottomFrame.midY)
                    let endPoint = CGPoint(x: startCenter.x + geo.translation.width,
                                           y: startCenter.y + geo.translation.height)
                    if viewModel.handleDragEnd(block: dragging, at: endPoint) {
                        withAnimation(.spring()) {
                            viewModel.currentDragBlock = nil
                            viewModel.dragTranslation = .zero
                        }
                        
                        /// Only show starburst if game is not complete yet
                        if !viewModel.isGameComplete {
                            showStarBurst(at: endPoint)
                        }
                    } else {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) {
                            viewModel.currentDragBlock = nil
                            viewModel.dragTranslation = .zero
                        }
                    }
                } else {
                    // bottom frame not known yet
                    withAnimation(.spring()) {
                        viewModel.currentDragBlock = nil
                        viewModel.dragTranslation = .zero
                    }
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

#Preview("Blocks Game View (Lv. 1)") {
    BlocksGameView(level: .level1)
}

#Preview("Blocks Game View (Lv. 2)") {
    BlocksGameView(level: .level2)
}
