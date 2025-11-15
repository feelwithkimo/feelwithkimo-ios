//
//  BlocksGameViewModel.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 13/11/25.
//

import SwiftUI

@MainActor
final class BlocksGameViewModel: ObservableObject {
    @Published var level: GameLevel = GameLevel.level1
    @Published var bottomBlocks: [BlockModel] = []
    @Published var placedMap: [Int: BlockModel] = [:]
    @Published var templateFrames: [Int: CGRect] = [:]
    @Published var bottomFrames: [UUID: CGRect] = [:]
    
    var snapRadius: CGFloat = 60
    
    var blockSizes: [UUID: CGSize] {
        Dictionary(
            uniqueKeysWithValues: level.templatePlacements.map {
                ($0.block.id, $0.size)
            }
        )
    }
    
    init(level: GameLevel) {
        bottomBlocks = level.templatePlacements.map { placement in
            BlockModel(id: placement.block.id, type: placement.block.type, color: placement.block.color)
        }
    }
    
    func isPlaced(_ id: UUID) -> Bool {
        return placedMap.values.contains { $0.id == id }
    }
    
    /// location must be in the same coordinate space as templateFrames (we'll use "blocksGame")
    func handleDragEnd(block: BlockModel, at location: CGPoint) -> Int? {
        // consider only template slots with same type and empty
        var bestIndex: Int?
        var bestDist = CGFloat.infinity
        
        for (index, frame) in templateFrames {
            guard placedMap[index] == nil else { continue } // skip occupied
            let templateType = level.templatePlacements[index].block.type
            guard templateType == block.type else { continue }
            let center = CGPoint(x: frame.midX, y: frame.midY)
            let dx = center.x - location.x
            let dy = center.y - location.y
            let dist = hypot(dx, dy)
            if dist < bestDist {
                bestDist = dist
                bestIndex = index
            }
        }
        
        if let best = bestIndex, bestDist <= snapRadius {
            // place block
            placedMap[best] = block
            // remove from bottomBlocks (by id)
            if let idx = bottomBlocks.firstIndex(where: { $0.id == block.id }) {
                bottomBlocks.remove(at: idx)
            }
            return best
        } else {
            return nil
        }
    }
    
}
