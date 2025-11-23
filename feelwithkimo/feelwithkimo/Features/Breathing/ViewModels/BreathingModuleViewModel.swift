//
//  BreathingModuleViewModel.swift
//  feelwithkimo
//
//  Created by Aristo Yongka on 23/11/25.
//

import SwiftUI
import Combine

class BreathingModuleViewModel: ObservableObject {
    @Published var currentPhase: Int = 0
    @Published var circleProgress: CGFloat = 0
    @Published var lineProgress: CGFloat = 0
    @Published var isAnimating = false
    @Published var hasCompleted = false
    
    let phases: [(id: Int, title: String, duration: Double)] = [
        (id: 0, title: "Tarik Nafas", duration: 4.0),
        (id: 1, title: "Tahan Nafas", duration: 3.0),
        (id: 2, title: "Hembus Nafas", duration: 4.0)
    ]
    
    /// Constants for path calculations
    let circleSize: CGFloat = 60
    let lineHeight: CGFloat = 80
    
    var circleCircumference: CGFloat {
        .pi * circleSize
    }
    
    var totalPathLength: CGFloat {
        circleCircumference + lineHeight
    }
    
    func startBreathingCycle() {
        guard currentPhase < phases.count else { return }
        
        isAnimating = true
        circleProgress = 0
        lineProgress = 0
        
        let currentPhaseDuration = phases[currentPhase].duration
        
        /// Calculate durations based on path lengths for constant velocity
        let circleDuration = (circleCircumference / totalPathLength) * currentPhaseDuration
        let lineDuration = (lineHeight / totalPathLength) * currentPhaseDuration
        
        /// Animate circle first
        withAnimation(.linear(duration: circleDuration)) {
            circleProgress = 1.0
        }
        
        /// After circle completes, animate line (only if not last phase)
        if currentPhase < phases.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + circleDuration) {
                withAnimation(.linear(duration: lineDuration)) {
                    self.lineProgress = 1.0
                }
            }
        }
        
        /// Move to next phase after total duration
        DispatchQueue.main.asyncAfter(deadline: .now() + currentPhaseDuration) {
            /// Instantly set line to complete before moving to next phase (no animation)
            withAnimation(nil) {
                self.lineProgress = 1.0
            }
            
            self.currentPhase += 1
            
            if self.currentPhase < self.phases.count {
                self.startBreathingCycle()
            } else {
                self.isAnimating = false
                self.hasCompleted = true
            }
        }
    }
    
    func isPhaseActive(_ index: Int) -> Bool {
        return currentPhase == index && isAnimating
    }
    
    func isPhaseCompleted(_ index: Int) -> Bool {
        return index < currentPhase
    }
}
