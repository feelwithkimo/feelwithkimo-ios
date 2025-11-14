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
                    position: CGPoint(x: 0.getWidth(), y: 260.getHeight()),
                    size: CGSize(width: 320.getWidth(), height: 130.getHeight())
                ),
                BlockPlacement(
                    block: BlockModel(type: .square, color: ColorToken.coreAccent.toColor()),
                    position: CGPoint(x: 20.getWidth(), y: 120.getHeight()),
                    size: CGSize(width: 120.getWidth(), height: 120.getHeight())
                ),
                BlockPlacement(
                    block: BlockModel(type: .square, color: ColorToken.coreAccent.toColor()),
                    position: CGPoint(x: 180.getWidth(), y: 120.getHeight()),
                    size: CGSize(width: 120.getWidth(), height: 120.getHeight())
                ),
                BlockPlacement(
                    block: BlockModel(type: .rectangle, color: ColorToken.additionalColorsDustyYellow.toColor()),
                    position: CGPoint(x: 10.getWidth(), y: 0.getHeight()),
                    size: CGSize(width: 300.getWidth(), height: 100.getHeight())
                )
            ]
        case .level2:
            return [
                BlockPlacement(
                    block: BlockModel(type: .arch, color: ColorToken.additionalColorsLightPink.toColor()),
                    position: CGPoint(x: 0.getWidth(), y: 307.getHeight()),
                    size: CGSize(width: 100.getWidth(), height: 280.getHeight())
                ),
                BlockPlacement(
                    block: BlockModel(type: .square, color: ColorToken.emotionSadness.toColor()),
                    position: CGPoint(x: 33.getWidth(), y: 197.getHeight()),
                    size: CGSize(width: 90.getWidth(), height: 90.getHeight())
                ),
                BlockPlacement(
                    block: BlockModel(type: .square, color: ColorToken.emotionSadness.toColor()),
                    position: CGPoint(x: 158.getWidth(), y: 197.getHeight()),
                    size: CGSize(width: 90.getWidth(), height: 90.getHeight())
                ),
                BlockPlacement(
                    block: BlockModel(type: .rectangle, color: ColorToken.additionalColorsDarkPink.toColor()),
                    position: CGPoint(x: 15.getWidth(), y: 117.getHeight()),
                    size: CGSize(width: 250.getWidth(), height: 60.getHeight())
                ),
                BlockPlacement(
                    block: BlockModel(type: .triangle, color: ColorToken.additionalColorsDustyYellow.toColor()),
                    position: CGPoint(x: 34.getWidth(), y: 0.getHeight()),
                    size: CGSize(width: 212.getWidth(), height: 97.getHeight())
                )
            ]
        }
    }
}
