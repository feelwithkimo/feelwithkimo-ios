//
//  BreathingModuleViewModel.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 02/11/25.
//
import Foundation
import SwiftUI

final class BreathingModuleViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentPhase: BreathingPhase = .inhale
    @Published var animationScale: CGFloat = 1.0
    @Published var remainingTime: Int = 4
    @Published var isActive = false
    @Published var startAnimation = false
    @Published var kimoMascotScale: CGFloat = 1.0
    @Published var cycleCount = 0
    @Published var isMascotTapped = false
    @Published var showCompletionView = false
    @Published var showDialogue: Bool = false
    @Published var maxCycles = 3 // Complete full breathing cycles before showing completion
    
    // MARK: - Private Properties
    private var timer: Timer?
    
    // MARK: - Lazy Computed Properties
    private lazy var breathingDuration: TimeInterval = 4.0
    private lazy var animationConfiguration = AnimationConfiguration()
    
    // MARK: - Animation Configuration Helper
    private struct AnimationConfiguration {
        let easeInOutDuration: TimeInterval = 0.2
        let breathingCycleDuration: TimeInterval = 4.0
        let delayMultiplier: Double = 0.2
    }
    
    // MARK: - Completion Handler
    var onCompletion: (() -> Void)?
    
    let dialogueText = "Ayo latihan pernafasan bersama 4 kali tarik nafas, 4 kali tahan nafas dan 4 kali buang nafas!"
    
    // MARK: - Enum
    enum BreathingPhase: String, CaseIterable {
        case inhale = "Tarik\nNafas"
        case hold = "Tahan\nNafas"
        case exhale = "Buang\nNafas"
        
        var duration: TimeInterval {
            return 4.0 // 4 seconds for each phase
        }
        
        var localizedText: String {
            switch self {
            case .inhale:
                return NSLocalizedString("Inhale", comment: "")
            case .hold:
                return NSLocalizedString("Hold", comment: "")
            case .exhale:
                return NSLocalizedString("Exhale", comment: "")
            }
        }
        
        var imageName: String {
            switch self {
            case .inhale:
                return "Kimo-Inhale"
            case .hold:
                return "Kimo-Hold-Breath"
            case .exhale:
                return "Kimo-Exhale"
            }
        }
        
        // Lazy computed property for scale values
        var scaleValue: CGFloat {
            switch self {
            case .inhale, .hold:
                return 1.5
            case .exhale:
                return 1.0
            }
        }
    }
    
    // MARK: - Breathing Functions
    func startBreathing() {
        isActive = true
        currentPhase = .inhale
        remainingTime = 4
        
        // Explicitly animate only the breathing scale
        withAnimation(.easeInOut(duration: currentPhase.duration)) {
            animationScale = currentPhase.scaleValue
        }
        
        startBreathingCycle()
        startTimer()
    }
    
    func stopBreathing() {
        isActive = false
        timer?.invalidate()
        timer = nil
        animationScale = 1.0
        currentPhase = .inhale
        remainingTime = 4
        startAnimation = false
    }
    
    private func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.remainingTime > 1 {
                self.remainingTime -= 1
            } else {
                // Move to next phase
                switch self.currentPhase {
                case .inhale:
                    self.currentPhase = .hold
                case .hold:
                    self.currentPhase = .exhale
                case .exhale:
                    self.currentPhase = .inhale
                    self.cycleCount += 1
                    
                    // Check if we've completed enough cycles
                    if self.cycleCount >= self.maxCycles {
                        self.completeBreathingSession()
                        return
                    }
                }
                
                self.remainingTime = 4
                
                // Explicitly animate the breathing scale changes
                withAnimation(.easeInOut(duration: self.currentPhase.duration)) {
                    self.animationScale = self.currentPhase.scaleValue
                }
            }
        }
    }
    
    private func startBreathingCycle() {
        // Initial state - breathe in
        withAnimation(.easeInOut(duration: animationConfiguration.breathingCycleDuration)) {
            startAnimation = true
        }
        
        // After 4 seconds, hold breath
        DispatchQueue.main.asyncAfter(deadline: .now() + animationConfiguration.breathingCycleDuration) { [weak self] in
            guard let self = self else { return }
            if self.isActive {
                // Continue holding the animation state
            }
        }
        
        // After 8 seconds total, breathe out
        DispatchQueue.main.asyncAfter(deadline: .now() + (animationConfiguration.breathingCycleDuration * 2)) { [weak self] in
            guard let self = self else { return }
            if self.isActive {
                withAnimation(.easeInOut(duration: self.animationConfiguration.breathingCycleDuration)) {
                    self.startAnimation = false
                }
            }
        }
        
        // Continue the cycle after 12 seconds if still active
        DispatchQueue.main.asyncAfter(deadline: .now() + (animationConfiguration.breathingCycleDuration * 3)) { [weak self] in
            guard let self = self else { return }
            if self.isActive {
                self.startBreathingCycle()
            }
        }
    }
    
    // MARK: - Mascot Functions
    func toggleMascot() {
        withAnimation(.easeInOut(duration: animationConfiguration.easeInOutDuration)) {
            if isMascotTapped {
                kimoMascotScale = 1.0
                isMascotTapped = false
            } else {
                kimoMascotScale = 1.5
                isMascotTapped = true
            }
        }
    }
    
    // MARK: - Completion Functions
    private func completeBreathingSession() {
        stopBreathing()
        showCompletionView = true
    }
    
    func restartBreathing() {
        cycleCount = 0
        showCompletionView = false
        startBreathing()
    }
    
    func finishSession() {
        showCompletionView = false
        onCompletion?()
    }
    
    // MARK: - Cleanup
    deinit {
        timer?.invalidate()
    }
}
