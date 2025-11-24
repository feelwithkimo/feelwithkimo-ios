///
///  BlocksGameViewModel.swift
///  feelwithkimo
///
///  Created by Adeline Charlotte Augustinne on 13/11/25.
///

import SwiftUI
import RiveRuntime

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
    
    @Published var isPaused: Bool = false
    @Published var resetCounter: Int = 0
    
    @Published var showIdleOverlay: Bool = false
    @Published var riveViewModel = RiveViewModel(fileName: "LalaInBlockGame", fit: .fitHeight)
    @Published private(set) var lalaMascotCurrentState: BlockMascotState = .lalaConfused
    
    let idleTimer = Timer.publish(every: 7, on: .main, in: .common).autoconnect()
    
    private var timer: Timer?
        
    var onComplete: (() -> Void)?
    
    var blockSizes: [UUID: CGSize] {
        Dictionary(
            uniqueKeysWithValues: level.templatePlacements.map {
                ($0.block.id, $0.size)
            }
        )
    }
    
    var isGameComplete: Bool {
        var isCompleted = true
        bottomBlocks.forEach { block in
            if block.baseColor != .clear {
                isCompleted = false
            }
        }
        return isCompleted
    }
    
    init(level: GameLevel, onComplete: (() -> Void)? = nil) {
        self.level = level
        self.onComplete = onComplete
        bottomBlocks = level.templatePlacements.map { placement in
            BlockModel(
                id: placement.block.id,
                type: placement.block.type,
                baseColor: placement.block.baseColor,
                strokeColor: placement.block.strokeColor)
        }
    }
    
    func onPausePressed() {
        isPaused = !isPaused
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
    
    func resetGame() {
        switchAnimation(to: BlockMascotState.lalaConfused)
        
        placedMap = [:]
        templateFrames = [:]
        bottomFrames = [:]
        
        templatePositions.removeAll()
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        
        // to force UI refresh
        resetCounter += 1
        
        bottomBlocks = level.templatePlacements.map { placement in
            BlockModel(
                id: placement.block.id,
                type: placement.block.type,
                baseColor: placement.block.baseColor,
                strokeColor: placement.block.strokeColor
            )
        }
        
        revealIndex = 0
        
        snapTarget = nil
        snappingBlockId = nil
        
        currentDragBlock = nil
        dragTranslation = .zero
        dragStartLocationInGame = nil
        
        burstLocation = nil
    }
    
    func handleDragEnd(block: BlockModel, at location: CGPoint) -> Bool {
        var bestDist = CGFloat.infinity
        var positionOfOutline = CGPoint.zero
        
        let blockSize = blockSizes[block.id] ?? .zero
        let dynamicSnapRadius = min(blockSize.width, blockSize.height) / 2 + 20.getHeight()
        
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
        
        if bestDist <= dynamicSnapRadius {
            DispatchQueue.main.async {
                self.snappingBlockId = block.id
                self.snapTarget = positionOfOutline
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                if let index = self.bottomBlocks.firstIndex(where: { $0.id == block.id }) {
                    self.bottomBlocks[index] = BlockModel(
                        id: self.bottomBlocks[index].id,
                        type: self.bottomBlocks[index].type,
                        baseColor: Color.clear,
                        strokeColor: Color.clear
                    )
                }
                     
                self.updateMascotState()
                
                self.templatePositions.removeAll { $0.point == positionOfOutline }
                
                self.advanceReveal()
                
                if self.isGameComplete {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.onComplete?()
                    }
                }
            }
            
            return true
        }
        return false
    }
    
    func handleIdleTick() {
        guard currentDragBlock == nil else { return }
        guard !isPaused else { return }

        showIdleOverlay = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showIdleOverlay = false
        }
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
    
    func startLoop() {
        stopLoop()

        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.doLidSequence()
            }
        }
        timer?.tolerance = 0.1
    }

    func stopLoop() {
        timer?.invalidate()
        timer = nil
    }
    
    func switchAnimation(to state: BlockMascotState) {
        lalaMascotCurrentState = state
        riveViewModel.setInput("state", value: Double(state.rawValue))
    }

    @MainActor
    private func doLidSequence() {
        riveViewModel.triggerInput("doLidDown")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.riveViewModel.triggerInput("doLidUp")
        }
    }
    
    private func remainingBlocksCount() -> Int {
        bottomBlocks.filter { $0.baseColor != .clear }.count
    }
    
    private func updateMascotState() {
        let remaining = remainingBlocksCount()
         
        if remaining == 1 {
            let newState: BlockMascotState = .lalaClapping
            guard newState != lalaMascotCurrentState else { return }
            switchAnimation(to: newState)

        } else {
            let newState: BlockMascotState = .lalaExcited
            guard newState != lalaMascotCurrentState else { return }
            switchAnimation(to: newState)
        }
    }

}
