//
//  BlocksGameViewModel.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 13/11/25.
//

import SwiftUI

@MainActor
final class BlocksGameViewModel: ObservableObject {
    @Published var level: GameLevel
    @Published var bottomBlocks: [BlockModel] = []
    @Published var placedMap: [Int: BlockModel] = [:]
    @Published var templateFrames: [Int: CGRect] = [:]
    @Published var bottomFrames: [UUID: CGRect] = [:]
    @Published var templatePositions: [(shapeType: ShapeType, point: CGPoint)] = []
    @Published var revealIndex: Int = 0
    
    @Published var snapTarget: CGPoint?
    @Published var snappingBlockId: UUID?
    
    @Published var currentDragBlock: BlockModel?
    @Published var dragTranslation: CGSize = .zero
    @Published var dragStartLocationInGame: CGPoint?
    @Published var burstLocation: CGPoint?
    
    var snapRadius: CGFloat = 150
    var onComplete: (() -> Void)?
    
    var blockSizes: [UUID: CGSize] {
        Dictionary(
            uniqueKeysWithValues: level.templatePlacements.map {
                ($0.block.id, $0.size)
            }
        )
    }
    
    // Check if game is complete
    var isGameComplete: Bool {
        return bottomBlocks.isEmpty
    }
    
    init(level: GameLevel, onComplete: (() -> Void)? = nil) {
        self.level = level
        self.onComplete = onComplete
        bottomBlocks = level.templatePlacements.map { placement in
            BlockModel(id: placement.block.id, type: placement.block.type, color: placement.block.color)
        }
    }
    
    func isPlaced(_ id: UUID) -> Bool {
        return placedMap.values.contains { $0.id == id }
    }
    
    func advanceReveal() {
        self.revealIndex += 1
        
        if self.revealIndex > level.templatePlacements.count {
            self.revealIndex = 0
        }
    }
    
    func handleDragEnd(block: BlockModel, at location: CGPoint) -> Bool {
        var bestDist = CGFloat.infinity
        var positionOfOutline = CGPoint.zero
        
        for (shapeType, center) in templatePositions {
            guard shapeType == block.type else { continue }
            
            let deltaX = center.x - location.x
            let deltaY = center.y - location.y
            let dist = hypot(deltaX, deltaY)
            
            if dist < bestDist {
                bestDist = dist
                positionOfOutline = center
            }
        }
        
        if bestDist <= snapRadius {
            DispatchQueue.main.async {
                self.snappingBlockId = block.id
                self.snapTarget = positionOfOutline
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                if let idx = self.bottomBlocks.firstIndex(where: { $0.id == block.id }) {
                    self.bottomBlocks.remove(at: idx)
                }
                
                self.templatePositions.removeAll { $0.point == positionOfOutline }
                
                self.advanceReveal()
                
                // Check if game is complete after snap animation
                if self.isGameComplete {
                    // Delay to show the final placement before completion
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.onComplete?()
                    }
                }
            }
            
            return true
        }
        return false
    }
    
    @MainActor
    func updateTemplateFrames(from pref: [UUID: CGRect]) {
        var dict: [Int: CGRect] = [:]

        for (idx, placement) in level.templatePlacements.enumerated() {
            if let frame = pref[placement.block.id] {
                dict[idx] = frame
            }
        }

        if dict != templateFrames {
            templateFrames = dict
        }
    }

    @MainActor
    func updateBottomFrames(from pref: [UUID: CGRect]) {
        if pref != bottomFrames {
            bottomFrames = pref
        }
    }
}
