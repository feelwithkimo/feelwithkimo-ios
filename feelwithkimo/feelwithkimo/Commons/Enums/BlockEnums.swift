//
//  BlockEnums.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 14/11/25.
//

import SwiftUI

enum ShapeType: String {
    case rectangle, square, arch, triangle
}

enum RectangleRatio {
    case ratio3to1
    case ratio25to6
    
    var value: CGFloat {
        switch self {
        case .ratio3to1:   return 3.0 / 1.0
        case .ratio25to6:  return 25.0 / 6.0
        }
    }
}

struct BlockPlacement {
    let block: BlockModel
    let position: CGPoint
    let size: CGSize
}

enum GameLevel: CaseIterable {
    case level1, level2

    
    var templatePlacements: [BlockPlacement] {
        switch self {
        case .level1:
            return [
                BlockPlacement(
                    block: BlockModel(type: .arch, color: ColorToken.additionalColorsLightPink.toColor()),
                    position: CGPoint(x: 0, y: 260),
                    size: CGSize(width: 320, height: 130)
                ),
                BlockPlacement(
                    block: BlockModel(type: .square, color: ColorToken.coreAccent.toColor()),
                    position: CGPoint(x: 20, y: 120),
                    size: CGSize(width: 120, height: 120)
                ),
                BlockPlacement(
                    block: BlockModel(type: .square, color: ColorToken.coreAccent.toColor()),
                    position: CGPoint(x: 180, y: 120),
                    size: CGSize(width: 120, height: 120)
                ),
                BlockPlacement(
                    block: BlockModel(type: .rectangle, color: ColorToken.additionalColorsDustyYellow.toColor()),
                    position: CGPoint(x: 10, y: 0),
                    size: CGSize(width: 300, height: 100)
                )
            ]
        case .level2:
            return [
                BlockPlacement(
                    block: BlockModel(type: .arch, color: ColorToken.additionalColorsLightPink.toColor()),
                    position: CGPoint(x: 0, y: 307),
                    size: CGSize(width: 100, height: 280)
                ),
                BlockPlacement(
                    block: BlockModel(type: .square, color: ColorToken.emotionSadness.toColor()),
                    position: CGPoint(x: 33, y: 197),
                    size: CGSize(width: 90, height: 90)
                ),
                BlockPlacement(
                    block: BlockModel(type: .square, color: ColorToken.emotionSadness.toColor()),
                    position: CGPoint(x: 158, y: 197),
                    size: CGSize(width: 90, height: 90)
                ),
                BlockPlacement(
                    block: BlockModel(type: .rectangle, color: ColorToken.additionalColorsDarkPink.toColor()),
                    position: CGPoint(x: 15, y: 117),
                    size: CGSize(width: 250, height: 60)
                ),
                BlockPlacement(
                    block: BlockModel(type: .triangle, color: ColorToken.additionalColorsDustyYellow.toColor()),
                    position: CGPoint(x: 34, y: 0),
                    size: CGSize(width: 212, height: 97)
                )
            ]
        }
    }
}
