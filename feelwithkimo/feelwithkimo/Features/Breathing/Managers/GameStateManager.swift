//
//  GameStateManager.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import Combine
import Foundation

internal class GameStateManager: ObservableObject {
    @Published var currentPhase: GamePhase = .welcome
    @Published var currentPlayer: PlayerType = .parent
    @Published var parentBalloonProgress: Double = 0.0
    @Published var childBalloonProgress: Double = 0.0
    @Published var isGameActive = false
    private let maxBalloonProgress: Double = 100.0
    private let progressPerBreath: Double = 8.0
    private let turnSwitchThreshold: Double = 25.0
    
    func startGame() {
        currentPhase = .parentTurn
        currentPlayer = .parent
        parentBalloonProgress = 0.0
        childBalloonProgress = 0.0
        isGameActive = true
    }
    
    func processBreath(type: BreathType, confidence: Double) {
        guard isGameActive else { return }
        // Much lower confidence threshold for easier detection - made even more sensitive
        let minConfidence: Double = 0.02
        guard confidence > minConfidence else { return }
        switch type {
        case .inhale, .exhale:
            addBreathProgress()
        case .none:
            break
        }
    }
    private func addBreathProgress() {
        let previousProgress = getCurrentBalloonProgress()
        switch currentPlayer {
        case .parent:
            parentBalloonProgress = min(parentBalloonProgress + progressPerBreath, maxBalloonProgress)
            checkForTurnSwitch(previousProgress: previousProgress, newProgress: parentBalloonProgress)
        case .child:
            childBalloonProgress = min(childBalloonProgress + progressPerBreath, maxBalloonProgress)
            checkForTurnSwitch(previousProgress: previousProgress, newProgress: childBalloonProgress)
        }
    }
    private func checkForTurnSwitch(previousProgress: Double, newProgress: Double) {
        // Calculate which 25% milestone we've crossed
        let previousMilestone = Int(previousProgress / turnSwitchThreshold)
        let newMilestone = Int(newProgress / turnSwitchThreshold)
        // Check if both balloons are complete (100%)
        if parentBalloonProgress >= maxBalloonProgress && childBalloonProgress >= maxBalloonProgress {
            completeGame()
            return
        }
        // Switch turns if we've crossed a 25% milestone and haven't reached 100%
        if newMilestone > previousMilestone && newProgress < maxBalloonProgress {
            switchPlayer()
        }
        // Special case: if current balloon reaches 100% but the other doesn't, switch to other player
        if newProgress >= maxBalloonProgress {
            if currentPlayer == .parent && childBalloonProgress < maxBalloonProgress {
                switchToChild()
            } else if currentPlayer == .child && parentBalloonProgress < maxBalloonProgress {
                switchToParent()
            }
        }
    }
    private func switchPlayer() {
        switch currentPlayer {
        case .parent:
            switchToChild()
        case .child:
            switchToParent()
        }
    }
    private func switchToChild() {
        currentPhase = .childTurn
        currentPlayer = .child
    }
    private func switchToParent() {
        currentPhase = .parentTurn
        currentPlayer = .parent
    }
    private func completeGame() {
        currentPhase = .gameComplete
        isGameActive = false
    }
    func resetGame() {
        currentPhase = .welcome
        currentPlayer = .parent
        parentBalloonProgress = 0.0
        childBalloonProgress = 0.0
        isGameActive = false
    }
    func getCurrentBalloonProgress() -> Double {
        switch currentPlayer {
        case .parent:
            return parentBalloonProgress
        case .child:
            return childBalloonProgress
        }
    }
    // Helper function to get current scene number
    func getCurrentScene() -> Int {
        let totalProgress = parentBalloonProgress + childBalloonProgress
        if totalProgress < 100 {
            return 1 // Scene 1: Initial breathing with one balloon
        } else if totalProgress < maxBalloonProgress * 2 {
            return 2 // Scene 2: Active breathing alternating between balloons
        } else {
            return 3 // Scene 3: Both balloons complete (200%)
        }
    }
}
