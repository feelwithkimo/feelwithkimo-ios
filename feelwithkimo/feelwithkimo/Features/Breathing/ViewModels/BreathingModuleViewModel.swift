import SwiftUI
import Combine

// MARK: - Breathing Phase Model
struct BreathingPhase {
    let id: Int
    let title: String
    let duration: Double
    let imageName: String
}

// MARK: - View Model
final class BreathingModuleViewModel: ObservableObject {
    @Published var currentPhase: Int = 0
    @Published var circleProgress: CGFloat = 0
    @Published var lineProgress: CGFloat = 0
    @Published var isAnimating = false
    @Published var hasCompleted = false
    @Published var isPaused = false
    @Published var currentRound: Int = 0
    
    let phases: [BreathingPhase] = [
        BreathingPhase(id: 0, title: "Tarik Nafas", duration: 4.0, imageName: "Kimo-Inhale"),
        BreathingPhase(id: 1, title: "Tahan Nafas", duration: 3.0, imageName: "Kimo-Hold-Breath"),
        BreathingPhase(id: 2, title: "Hembus Nafas", duration: 4.0, imageName: "Kimo-Exhale")
    ]
    
    let totalRounds = 4
    
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
        guard currentPhase < phases.count else { return }
        
        isAnimating = true
        circleProgress = 0
        lineProgress = 0
        
        let currentPhaseDuration = phases[currentPhase].duration
        
        /// For the last phase, circle takes full duration. Otherwise, split between circle and line
        let isLastPhase = currentPhase == phases.count - 1
        
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
            
            self.currentPhase += 1
            
            if self.currentPhase < self.phases.count {
                self.startBreathingCycle()
            } else {
                /// Completed one round
                self.currentRound += 1
                
                if self.currentRound < self.totalRounds {
                    /// Start next round
                    self.currentPhase = 0
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
        return currentPhase == index && isAnimating
    }
    
    func isPhaseCompleted(_ index: Int) -> Bool {
        return index < currentPhase
    }
    
    func resetBreathingCycle() {
        currentPhase = 0
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
    
    func getCurrentPhaseImage() -> String {
        guard currentPhase < phases.count else {
            return phases.last?.imageName ?? "Kimo-Inhale"
        }
        return phases[currentPhase].imageName
    }
}
