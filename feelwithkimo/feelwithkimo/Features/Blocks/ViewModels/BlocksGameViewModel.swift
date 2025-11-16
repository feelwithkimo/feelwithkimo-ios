//
//  BlocksGameViewModel.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 13/11/25.
//

import SwiftUI

@MainActor
final class BlocksGameViewModel: ObservableObject {
    @Published var level: GameLevel = GameLevel.level2
    @Published var bottomBlocks: [BlockModel] = []
    @Published var placedMap: [Int: BlockModel] = [:]
    @Published var templateFrames: [Int: CGRect] = [:]
    @Published var bottomFrames: [UUID: CGRect] = [:]
    @Published var templatePositions: [(shapeType: ShapeType, point: CGPoint)] = []
    @Published var revealIndex: Int = 0
    
    @Published var snapTarget: CGPoint? = nil
    @Published var snappingBlockId: UUID? = nil
    
    var snapRadius: CGFloat = 150
    
    var blockSizes: [UUID: CGSize] {
        Dictionary(
            uniqueKeysWithValues: level.templatePlacements.map {
                ($0.block.id, $0.size)
            }
        )
    }
    
    init(level: GameLevel) {
        self.level = level
        bottomBlocks = level.templatePlacements.map { placement in
            BlockModel(id: placement.block.id, type: placement.block.type, color: placement.block.color)
        }
    }
    
    func isPlaced(_ id: UUID) -> Bool {
        return placedMap.values.contains { $0.id == id }
    }
    
    func advanceReveal() {
        self.revealIndex += 1
        
        if (self.revealIndex > level.templatePlacements.count) {
            self.revealIndex = 0
        }
    }
    
    /// location must be in the same coordinate space as templateFrames (we'll use "blocksGame")
    func handleDragEnd(block: BlockModel, at location: CGPoint) -> Bool {
        //        var bestIndex: Int?
        var bestDist = CGFloat.infinity
        var positionOfOutline = CGPoint.zero
        
        //        for (index, center) in templatePositions {
        //            // skip occupied
        //            guard placedMap[index] == nil else { continue }
        //            // only same shape
        //            let templateType = level.templatePlacements[index].block.type
        //            guard templateType == block.type else { continue }
        //
        //            let dx = center.x - location.x
        //            let dy = center.y - location.y
        //            let dist = hypot(dx, dy)
        //
        //            if dist < bestDist {
        //                bestDist = dist
        //                bestIndex = index
        //            }
        //        }
        
        //        if let best = bestIndex, bestDist <= snapRadius {
        //            placedMap[best] = block
        //            if let idx = bottomBlocks.firstIndex(where: { $0.id == block.id }) {
        //                bottomBlocks.remove(at: idx)
        //            }
        //            return best
        //        } else {
        //            return nil
        //        }
        print("location drag: ", location)
        print("===")
        for (shapeType, center) in templatePositions {
            guard shapeType == block.type else { continue }
            
            let dx = center.x - location.x
            let dy = center.y - location.y
            let dist = hypot(dx, dy)
            
            if dist < bestDist {
                bestDist = dist
                positionOfOutline = center
            }
            
            print(shapeType, center)
        }
        print("-------")
        print("Best Dist: ", bestDist)
        
        if bestDist <= snapRadius {
            DispatchQueue.main.async {
                    self.snappingBlockId = block.id
                    self.snapTarget = positionOfOutline
                }

                // Delay removal so animation can show
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    if let idx = self.bottomBlocks.firstIndex(where: { $0.id == block.id }) {
                        self.bottomBlocks.remove(at: idx)
                    }

                    // Remove outline
                    self.templatePositions.removeAll { $0.point == positionOfOutline }

                    self.advanceReveal()
                }
            
            return true
        }
        return false
    }
    
}
