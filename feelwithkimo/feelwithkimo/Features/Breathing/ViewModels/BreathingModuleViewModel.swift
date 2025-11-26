import SwiftUI
import Combine

// MARK: - View Model
final class BreathingModuleViewModel: ObservableObject {
    @Published var currentPhase: BreathingPhase = .inhale
    @Published var phaseCounter = 0
    @Published var circleProgress: CGFloat = 0
    @Published var lineProgress: CGFloat = 0
    @Published var isAnimating = false
    @Published var hasCompleted = false
    @Published var isPaused = false
    @Published var currentRound: Int = 0
    @Published var showTutorial: Bool = false
    
    let totalRounds: Int = 4
    let totalPhaseCount: Int = 3
    
    /// Constants for path calculations
    let circleSize: CGFloat = 60.getWidth()
    let lineHeight: CGFloat = 80.getHeight()
    
    var circleCircumference: CGFloat {
        .pi * circleSize
    }
    
    var totalPathLength: CGFloat {
        circleCircumference + lineHeight
    }
    
    private var pausedTime: DispatchTime?
    private var remainingDuration: Double = 0
    private var circleWorkItem: DispatchWorkItem?
    private var lineWorkItem: DispatchWorkItem?
    private var phaseWorkItem: DispatchWorkItem?
    
    func startBreathingCycle() {
        guard phaseCounter < totalPhaseCount else { return }
        
        isAnimating = true
        circleProgress = 0
        lineProgress = 0
        
        let currentPhaseDuration = currentPhase.duration
        
        /// For the last phase, circle takes full duration. Otherwise, split between circle and line
        let isLastPhase = phaseCounter == totalPhaseCount - 1
        
        let circleDuration: Double
        let lineDuration: Double
        
        if isLastPhase {
            /// Last phase: circle takes the full duration
            circleDuration = currentPhaseDuration
            lineDuration = 0
        } else {
            /// Other phases: Calculate durations based on path lengths for constant velocity
            circleDuration = (circleCircumference / totalPathLength) * currentPhaseDuration
            lineDuration = (lineHeight / totalPathLength) * currentPhaseDuration
        }
        
        /// Animate circle first
        withAnimation(.linear(duration: circleDuration)) {
            circleProgress = 1.0
        }
        
        /// After circle completes, animate line (only if not last phase)
        if !isLastPhase {
            let workItem = DispatchWorkItem {
                withAnimation(.linear(duration: lineDuration)) {
                    self.lineProgress = 1.0
                }
            }
            lineWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + circleDuration, execute: workItem)
        }
        
        /// Move to next phase after total duration
        let workItem = DispatchWorkItem {
            /// Instantly set line to complete before moving to next phase (no animation)
            withAnimation(nil) {
                self.lineProgress = 1.0
            }
            
            self.phaseCounter += 1
            
            /// Update currentPhase based on phaseCounter
            let phases: [BreathingPhase] = [.inhale, .hold, .exhale]
            self.currentPhase = phases[self.phaseCounter % phases.count]
            
            if self.phaseCounter < self.totalPhaseCount {
                self.startBreathingCycle()
            } else {
                /// Completed one round
                self.currentRound += 1
                self.phaseCounter = 0
                
                if self.currentRound < self.totalRounds {
                    /// Start next round
                    self.currentPhase = .inhale
                    self.startBreathingCycle()
                } else {
                    /// All rounds completed
                    self.isAnimating = false
                    self.hasCompleted = true
                }
            }
        }
        phaseWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + currentPhaseDuration, execute: workItem)
    }
    
    func pauseBreathing() {
        isPaused = true
        isAnimating = false
        
        /// Cancel pending work items
        lineWorkItem?.cancel()
        phaseWorkItem?.cancel()
    }
    
    func resumeBreathing() {
        isPaused = false
        startBreathingCycle()
    }
    
    func isPhaseActive(_ index: Int) -> Bool {
        return phaseCounter == index && isAnimating
    }
    
    func isPhaseCompleted(_ index: Int) -> Bool {
        return index < phaseCounter
    }
    
    func resetBreathingCycle() {
        currentPhase = .inhale
        phaseCounter = 0
        circleProgress = 0
        lineProgress = 0
        isAnimating = false
        hasCompleted = false
        isPaused = false
        currentRound = 0
        
        /// Cancel any pending work items
        lineWorkItem?.cancel()
        phaseWorkItem?.cancel()
    }
}
