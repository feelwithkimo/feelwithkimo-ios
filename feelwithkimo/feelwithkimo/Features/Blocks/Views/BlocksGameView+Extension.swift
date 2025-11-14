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
    BlocksGameView().shapesGuideCard(blockPlacements: GameLevel.level2.templatePlacements)
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
