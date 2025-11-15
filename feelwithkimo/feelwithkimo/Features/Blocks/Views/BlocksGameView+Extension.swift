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
            shapesGuideCard(blockPlacements: GameLevel.level1.templatePlacements)
            shapesOutlineView(blockPlacements:GameLevel.level1.templatePlacements)
        }
        .padding(.horizontal, 160.getWidth())
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
                    .offset(currentDragBlock?.id == block.id ? dragTranslation : .zero)
                    .zIndex(currentDragBlock?.id == block.id ? 100 : 0)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .preference(
                                    key: FramePreferenceKey.self,
                                    value: [placement.block.id: geo.frame(in: .named(gameCoordinateSpaceName))]
                                )
                        }
                        .allowsHitTesting(false)
                    )
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
                                    if viewModel.handleDragEnd(block: dragging, at: endPoint) != nil {
                                        withAnimation(.spring()) {
                                            currentDragBlock = nil
                                            dragTranslation = .zero
                                        }
                                    } else {
                                        withAnimation(.spring()) {
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
                let isBeforeHint = revealMode && revealIndex != nil && index < revealIndex!
                let isAfterHint = revealMode && revealIndex != nil && index > revealIndex!
                
                if !isAfterHint {
                    if isHint {
                        // hint: no fill, dashed stroke
                        shape(for: placement.block.type)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [25]))
                            .foregroundColor(ColorToken.backgroundSecondary.toColor())
                            .frame(width: placement.size.width, height: placement.size.height)
                            .offset(x: placement.position.x, y: placement.position.y)
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
        return VStack(alignment: .center){
            Spacer()
            VStack{
                renderShapes(
                    placements: blockPlacements,
                    revealMode: true,
                    revealIndex: 2
                )
            }
            .padding(.horizontal, 43.getWidth())
            .padding(.vertical, 23.getHeight())
        }
        .padding(.horizontal, 43.getWidth())
        .cornerRadius(30.getHeight())
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


struct DraggableBlock: View {
    @ObservedObject var viewModel: BlocksGameViewModel
    
    let block: BlockModel
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    let containerCoordinateSpace: CoordinateSpace
    var placedIndex: Int? = nil
    
    var body: some View {
        let shapeView = shape(for: block.type)
            .fill(block.color)
            .overlay(shape(for: block.type).stroke(ColorToken.additionalColorsBlack.toColor(), lineWidth: 2))
        
        Group {
            if let placedIdx = placedIndex, let frame = viewModel.templateFrames[placedIdx] {
                shapeView
                    .frame(width: frame.width, height: frame.height)
                    .position(x: frame.midX, y: frame.midY)
                    .animation(.spring(), value: viewModel.templateFrames)
            } else {
                shapeView
                    .frame(width: 90, height: 90)
                    .offset(dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { g in
                                isDragging = true
                                dragOffset = g.translation
                            }
                            .onEnded { g in
                                isDragging = false
                                
                                if let window = UIApplication.shared.windows.first {
                                    
                                }
                                
                            }
                    )
            }
        }
    }
}

#Preview {
    BlocksGameView().shapesGuideCard(blockPlacements: GameLevel.level2.templatePlacements)
}

#Preview("Blocks Game View") {
    BlocksGameView()
}
