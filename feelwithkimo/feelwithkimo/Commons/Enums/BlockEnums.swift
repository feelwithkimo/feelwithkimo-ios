///
///  BlockEnums.swift
///  feelwithkimo
///
///  Created by Adeline Charlotte Augustinne on 14/11/25.
///

import SwiftUI

enum BlockBuildingState {
    case stage1
    case stage1Completed
    case stage2
    case stage2Completed
}

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
                    block:
                        BlockModel(
                            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001") ?? UUID(),
                            type: .arch,
                            baseColor: ColorToken.additionalColorsLightPink.toColor(),
                            strokeColor: ColorToken.additionalColorsDarkPink.toColor()
                        ),
                    position: CGPoint(x: 0.getWidth(), y: 260.getHeight()),
                    size: CGSize(width: 320.getWidth(), height: 130.getHeight())
                ),
                BlockPlacement(
                    block:
                        BlockModel(
                            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002") ?? UUID(),
                            type: .square,
                            baseColor: ColorToken.coreAccent.toColor(),
                            strokeColor: ColorToken.emotionDisgusted.toColor()
                        ),
                    position: CGPoint(x: 20, y: 120.getHeight()),
                    size: CGSize(width: 120.getWidth(), height: 120.getHeight())
                ),
                BlockPlacement(
                    block:
                        BlockModel(
                            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003") ?? UUID(),
                            type: .square,
                            baseColor: ColorToken.coreAccent.toColor(),
                            strokeColor: ColorToken.emotionDisgusted.toColor()
                        ),
                    position: CGPoint(x: 180.getWidth(), y: 120.getHeight()),
                    size: CGSize(width: 120.getWidth(), height: 120.getHeight())
                ),
                BlockPlacement(
                    block:
                        BlockModel(
                            id: UUID(uuidString: "00000000-0000-0000-0000-000000000004") ?? UUID(),
                            type: .rectangle,
                            baseColor: ColorToken.backgroundIdentity.toColor(),
                            strokeColor: ColorToken.additionalColorsLightBlue.toColor()
                        ),
                    position: CGPoint(x: 10.getWidth(), y: 0.getHeight()),
                    size: CGSize(width: 300.getWidth(), height: 100.getHeight())
                )
            ]
        case .level2:
            return [
                BlockPlacement(
                    block:
                        BlockModel(
                            id: UUID(uuidString: "00000000-0000-0000-0000-000000000005") ?? UUID(),
                            type: .arch,
                            baseColor: ColorToken.additionalColorsLightPink.toColor(),
                            strokeColor: ColorToken.additionalColorsDarkPink.toColor()
                        ),
                    position: CGPoint(x: 0.getWidth(), y: 307.getHeight()),
                    size: CGSize(width: 280.getWidth(), height: 100.getHeight())
                ),
                BlockPlacement(
                    block:
                        BlockModel(
                            id: UUID(uuidString: "00000000-0000-0000-0000-000000000006") ?? UUID(),
                            type: .square,
                            baseColor: ColorToken.coreAccent.toColor(),
                            strokeColor: ColorToken.emotionDisgusted.toColor()
                        ),
                    position: CGPoint(x: 33.getWidth(), y: 197.getHeight()),
                    size: CGSize(width: 90.getWidth(), height: 90.getHeight())
                ),
                BlockPlacement(
                    block:
                        BlockModel(
                            id: UUID(uuidString: "00000000-0000-0000-0000-000000000007") ?? UUID(),
                            type: .square,
                            baseColor: ColorToken.coreAccent.toColor(),
                            strokeColor: ColorToken.emotionDisgusted.toColor()
                        ),
                    position: CGPoint(x: 158.getWidth(), y: 197.getHeight()),
                    size: CGSize(width: 90.getWidth(), height: 90.getHeight())
                ),
                BlockPlacement(
                    block:
                        BlockModel(
                            id: UUID(uuidString: "00000000-0000-0000-0000-000000000008") ?? UUID(),
                            type: .rectangle,
                            baseColor: ColorToken.backgroundIdentity.toColor(),
                            strokeColor: ColorToken.additionalColorsLightBlue.toColor()
                        ),
                    position: CGPoint(x: 15.getWidth(), y: 117.getHeight()),
                    size: CGSize(width: 250.getWidth(), height: 60.getHeight())
                ),
                BlockPlacement(
                    block:
                        BlockModel(
                            id: UUID(uuidString: "00000000-0000-0000-0000-000000000009") ?? UUID(),
                            type: .triangle,
                            baseColor: ColorToken.backgroundEntry.toColor(),
                            strokeColor: ColorToken.backgroundSecondary.toColor()
                        ),
                    position: CGPoint(x: 34.getWidth(), y: 0.getHeight()),
                    size: CGSize(width: 212.getWidth(), height: 97.getHeight())
                )
            ]
        }
    }
}
