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
            shapesOutlineView
        }
        .padding(.horizontal, 160.getWidth())
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
                ZStack(alignment: .topLeading) {
                    ForEach(placements, id: \.block.id) { placement in
                        shape(for: placement.block.type)
                            .fill(placement.block.color)
                            .stroke(ColorToken.additionalColorsBlack.toColor(), lineWidth: 2)
                            .frame(width: placement.size.width, height: placement.size.height)
                            .offset(
                                x: placement.position.x,
                                y: placement.position.y
                            )
                    }
                }
                .frame(width: maxX, height: maxY, alignment: .topLeading)
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
            Spacer()
        }
        .frame(height: 150.getHeight())
        .padding(.horizontal, 60.getWidth())
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
    
    struct DraggableBlockView: View {
        let model: BlockModel
        @Binding var position: CGPoint
        let size: CGSize
        let onDragEnded: (UUID, CGPoint) -> Void
        
        @State private var dragOffset: CGSize = .zero
        @State private var isDragging = false
        
        var body: some View {
            TupleView {
                shape(for: model.type)
                    .fill(model.color)
                    .frame(width: size.width, height: size.height)
                    .overlay(
                        TupleView {
                            shape(for: model.type).stroke(Color.black.opacity(0.12), lineWidth: 1)
                        }
                    )
                    .shadow(radius: isDragging ? 8 : 2)
                    .position(CGPoint(x: position.x + dragOffset.width, y: position.y + dragOffset.height))
                    .gesture(
                        DragGesture()
                            .onChanged { g in
                                isDragging = true
                                dragOffset = g.translation
                            }
                            .onEnded { g in
                                isDragging = false
                                let finalCenter = CGPoint(x: position.x + dragOffset.width, y: position.y + dragOffset.height)
                                onDragEnded(model.id, finalCenter)
                                withAnimation(.easeOut(duration: 0.25)) {
                                    dragOffset = .zero
                                }
                            }
                    )
                    .animation(.interactiveSpring(), value: isDragging)
            }
        }
    }
    
    struct OutlineSlotView: View {
        let model: BlockModel
        var body: some View {
            TupleView {
                shape(for: model.type)
                    .stroke(style: StrokeStyle(lineWidth: 3, dash: [8]))
                    .foregroundColor(.gray.opacity(0.6))
                    .frame(width: sizeFor(model).width, height: sizeFor(model).height)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .preference(
                                    key: FramePreferenceKey.self,
                                    value: [model.id: geo.frame(in: .global)]
                                )
                        }
                    )
            }
        }
        
        private func sizeFor(_ model: BlockModel) -> CGSize {
            switch model.type {
            case .rectangle: return CGSize(width: 220, height: 90)
            case .square: return CGSize(width: 120, height: 120)
            case .arch: return CGSize(width: 260, height: 90)
            case .triangle: return CGSize(width: 180, height: 120)
            }
        }
    }
    
    // MARK: - Drag Logic
    
    // MARK: - Helpers
    
    func initialBottomBarPosition(for block: BlockModel) -> CGPoint {
        // return a precise pixel coordinate inside your bottom bar
        CGPoint(x: 200, y: UIScreen.main.bounds.height - 120)
    }
    
    func sizeFor(_ block: BlockModel) -> CGSize {
        switch block.type {
        case .rectangle: return CGSize(width: 220, height: 90)
        case .square: return CGSize(width: 120, height: 120)
        case .arch: return CGSize(width: 260, height: 90)
        case .triangle: return CGSize(width: 180, height: 120)
        }
    }
}

#Preview {
    BlocksGameView().shapesGuideCard(blockPlacements: GameLevel.level1.templatePlacements)
}

#Preview("Blocks Game View") {
    BlocksGameView()
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGRect] = [:]
    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
