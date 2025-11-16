//
//  BlocksGameView+ext.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 14/11/25.
//

import SwiftUI

extension BlocksGameView {
    
    var shapesView: some View {
        HStack(spacing: 82.getWidth()) {
            shapesGuideCard(blockPlacements: GameLevel.level1.templatePlacements)
            shapesOutlineView(blockPlacements: GameLevel.level1.templatePlacements)
        }
        .padding(.vertical, 44.getHeight())
        .padding(.leading, 252.getWidth())
        .border(.cyan)
    }
    
    func renderBtmBarShapes(placements: [BlockPlacement]) -> some View {
        return HStack(alignment: .center) {
            ForEach(Array(placements.enumerated()), id: \.element.block.id) { index, placement in
                
                let block = placement.block
                
                shape(for: placement.block.type)
                    .fill(placement.block.color)
                    .overlay(
                        shape(for: placement.block.type)
                            .stroke(ColorToken.additionalColorsBlack.toColor(), lineWidth: 2)
                    )
                    .frame(width: placement.size.width, height: placement.size.height)
                    .padding(.horizontal, 30.getWidth())
                    .contentShape(Rectangle())
                    .offset({
                        if currentDragBlock?.id == block.id {
                            return dragTranslation
                        }
                        
                        if viewModel.snappingBlockId == block.id,
                           let target = viewModel.snapTarget,
                           let myFrame = viewModel.bottomFrames[block.id] {
                            
                            let dx = target.x - myFrame.midX + 20.getHeight()
                            let dy = target.y - myFrame.midY
                            return CGSize(width: dx, height: dy)
                        }
                        
                        return .zero
                    }())
                    .animation(.spring(), value: viewModel.snappingBlockId)
                    .zIndex(currentDragBlock?.id == block.id ? 100 : 0)
                    .background(
                        GeometryReader { geo in
                            Color.clear .preference(
                                key: FramePreferenceKey.self,
                                value: [placement.block.id: geo.frame(in: .named(gameCoordinateSpaceName))]
                            )
                        }
                            .onPreferenceChange(FramePreferenceKey.self) { prefs in
                                for (id, frame) in prefs {
                                    viewModel.bottomFrames[id] = frame
                                }
                            } .allowsHitTesting(false) )
                    .gesture(
                        DragGesture()
                            .onChanged { g in
                                if currentDragBlock == nil {
                                    currentDragBlock = block
                                }
                                dragTranslation = g.translation
                            }
                            .onEnded { g in
                                guard let dragging = currentDragBlock else { return }
                                
                                // get bottom frame for this dragging item (in same coordinate space)
                                if let bottomFrame = viewModel.bottomFrames[dragging.id] {
                                    let startCenter = CGPoint(x: bottomFrame.midX, y: bottomFrame.midY)
                                    let endPoint = CGPoint(x: startCenter.x + g.translation.width,
                                                           y: startCenter.y + g.translation.height)
                                    if viewModel.handleDragEnd(block: dragging, at: endPoint) {
                                        withAnimation(.spring()) {
                                            currentDragBlock = nil
                                            dragTranslation = .zero
                                        }
                                        
                                        showStarBurst(at: endPoint)
                                    } else {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) {
                                            currentDragBlock = nil
                                            dragTranslation = .zero
                                        }
                                    }
                                } else {
                                    // bottom frame not known yet — reset
                                    withAnimation(.spring()) {
                                        currentDragBlock = nil
                                        dragTranslation = .zero
                                    }
                                }
                            }
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
                let isBeforeHint = revealMode && revealIndex != nil && index < revealIndex ?? -1
                let isAfterHint = revealMode && revealIndex != nil && index > revealIndex ?? -1
                
                if !isAfterHint {
                    if isHint {
                        // hint: no fill, dashed stroke
                        shape(for: placement.block.type)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [25]))
                            .foregroundColor(ColorToken.backgroundSecondary.toColor())
                            .frame(width: placement.size.width, height: placement.size.height)
                            .offset(x: placement.position.x, y: placement.position.y)
                            .readPosition { frame in
                                //                                print(placement.block.type, frame.origin)
                                //                                print("Adjustment from placement: ", placement.position.x, placement.position.y)
                                let finalX = frame.origin.x + placement.position.x + placement.size.width / 2
                                let finalY = frame.origin.y + placement.position.y + placement.size.height / 2
                                
                                // ALWAYS insert the center
                                if index < viewModel.templatePositions.count {
                                    viewModel.templatePositions[index].point = CGPoint(x: finalX, y: finalY)
                                } else {
                                    viewModel.templatePositions.append(
                                        (shapeType: placement.block.type,
                                         point: CGPoint(x: finalX, y: finalY))
                                    )
                                }
                            }
                    } else {
                        // solid block
                        shape(for: placement.block.type)
                            .fill(placement.block.color)
                            .overlay(
                                shape(for: placement.block.type)
                                    .stroke(ColorToken.additionalColorsBlack.toColor(), lineWidth: 2)
                            )
                            .frame(width: placement.size.width, height: placement.size.height)
                            .offset(x: placement.position.x, y: placement.position.y)
                    }
                }
            }
        }
        .frame(width: maxX, height: maxY, alignment: .topLeading)
        .border(.red)
        .readPosition { frame in
            print("rendering renderShapes()")
            print(frame.origin)
        }
    }
    
    func shapesGuideCard(blockPlacements: [BlockPlacement]) -> some View {
        let placements: [BlockPlacement] = blockPlacements
        let maxX = placements.map { $0.position.x + $0.size.width }.max() ?? 0
        let maxY = placements.map { $0.position.y + $0.size.height }.max() ?? 0
        
        return VStack(spacing: 2){
            
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
            
            VStack{
                renderShapes(placements: placements)
            }
            .frame(width: 546.getWidth(), height: maxY, alignment: .center)
            .padding(23.getHeight())
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
            //            .padding(.horizontal, 43.getWidth())
            //            .padding(.vertical, 23.getHeight())
            .border(.black)
        }
    }
    
    func bottomBar(placements: [BlockPlacement]) -> some View {
        HStack(alignment: .center){
            renderBtmBarShapes(placements: placements)
        }
        .padding(.horizontal, 60.getWidth())
        .frame(height: 150.getHeight())
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 60, style: .continuous)
                    .fill(ColorToken.additionalColorsLightBlue.toColor())
                    .offset(y: -7.getHeight())
                
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .fill(ColorToken.emotionSadness.toColor())
            }
                .padding(.bottom, -50.getHeight())
        )
        .shadow(color: ColorToken.emotionSadness.toColor().opacity(0.2),
                radius: 20, x: 0, y: -15.getHeight())
    }
    
    func showStarBurst(at point: CGPoint) {
        burstLocation = point
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            burstLocation = nil
        }
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGRect] = [:]
    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct BottomFramePreferenceKey: PreferenceKey {
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

extension View {
    func readPosition(_ onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: ViewPositionKey.self,
                                value: proxy.frame(in: .global))
            }
        )
        .onPreferenceChange(ViewPositionKey.self, perform: onChange)
    }
}

#Preview {
    BlocksGameView().shapesGuideCard(blockPlacements: GameLevel.level2.templatePlacements)
}

#Preview("Blocks Game View") {
    BlocksGameView()
}
