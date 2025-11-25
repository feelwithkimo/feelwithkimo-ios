//
//  ClappingAccessibilityManager.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 27/10/25.
//
import SwiftUI

/// Clapping-specific accessibility manager that extends the main AccessibilityManager
struct ClappingAccessibilityManager {
    
    /// Announces hand detection status changes
    static func announceHandDetection(handState: HandState) {
        let message: String
        switch handState {
        case .noHand:
            message = "Tidak ada tangan terdeteksi. Posisikan tangan di depan kamera."
        case .oneHand:
            message = "Satu tangan terdeteksi. Posisikan kedua tangan untuk bermain."
        case .twoHands:
            message = "Kedua tangan terdeteksi. Siap untuk bermain tepuk tangan."
        }
        
        AccessibilityManager.announce(message)
    }
    
    /// Announces heartbeat status
    static func announceHeartbeatStatus(isActive: Bool, bpm: Int = 100) {
        let message = isActive ? 
            "Detak jantung dimulai dengan \(bpm) ketukan per menit. Tepuk tangan mengikuti irama." :
            "Detak jantung berhenti."
        
        AccessibilityManager.announce(message, important: true)
    }
    
    /// Announces clap feedback
    static func announceClapFeedback(isSuccessful: Bool) {
        let message = isSuccessful ? "Tepukan berhasil!" : "Tepukan terlalu cepat atau lambat"
        AccessibilityManager.announce(message)
    }
    
    /// Announces game progress
    static func announceGameProgress(currentStep: Int, totalSteps: Int = 10) {
        let message = "Langkah \(currentStep) dari \(totalSteps) selesai"
        AccessibilityManager.announce(message)
    }
    
    /// Announces game completion
    static func announceGameCompletion() {
        let message = "Selamat! Permainan tepuk tangan selesai. Kalian berhasil mengikuti semua irama!"
        AccessibilityManager.announce(message, important: true)
    }
    
    /// Creates accessibility hints for different game phases
    static func createGameHint(isHeartbeatActive: Bool, handState: HandState) -> String {
        if !isHeartbeatActive {
            switch handState {
            case .noHand:
                return "Posisikan tangan di depan kamera, lalu ketuk tombol mulai untuk memulai permainan"
            case .oneHand:
                return "Posisikan kedua tangan di depan kamera untuk bermain"
            case .twoHands:
                return "Kedua tangan terdeteksi. Ketuk tombol mulai untuk memulai permainan"
            }
        } else {
            return "Tepuk tangan mengikuti irama detak jantung yang terdengar"
        }
    }
}

/// Extension to add clapping-specific accessibility modifiers to views
extension View {
    /// Adds comprehensive accessibility support for clapping game elements
    func clappingAccessibility(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = [],
        value: String? = nil,
        identifier: String? = nil
    ) -> some View {
        self.kimoAccessibility(
            label: label,
            hint: hint,
            traits: traits,
            value: value,
            identifier: identifier.map { "clapping.\($0)" }
        )
    }
    
    /// Adds hand detection accessibility
    func handDetectionAccessibility(
        handState: HandState
    ) -> some View {
        let label: String
        let hint: String
        
        switch handState {
        case .noHand:
            label = "Tidak ada tangan terdeteksi"
            hint = "Posisikan tangan di depan kamera untuk bermain"
        case .oneHand:
            label = "Satu tangan terdeteksi"
            hint = "Posisikan kedua tangan di depan kamera"
        case .twoHands:
            label = "Kedua tangan terdeteksi"
            hint = "Siap untuk bermain tepuk tangan"
        }
        
        return self.clappingAccessibility(
            label: label,
            hint: hint,
            traits: .updatesFrequently,
            identifier: "handDetection"
        )
    }
    
    /// Adds clap feedback accessibility
    func clapFeedbackAccessibility(
        showFeedback: Bool,
        isSuccessful: Bool
    ) -> some View {
        self.modifier(ClapFeedbackAccessibilityModifier(
            showFeedback: showFeedback,
            isSuccessful: isSuccessful
        ))
    }
    
    /// Adds heartbeat accessibility
    func heartbeatAccessibility(
        isActive: Bool,
        bpm: Int = 100
    ) -> some View {
        let label = isActive ? "Detak jantung aktif" : "Detak jantung tidak aktif"
        let value = isActive ? "\(bpm) ketukan per menit" : NSLocalizedString("Stop", comment: "")
        let hint = isActive ? "Dengarkan irama dan tepuk tangan mengikuti detak" : "Ketuk tombol mulai untuk memulai detak jantung"
        
        return self.clappingAccessibility(
            label: label,
            hint: hint,
            traits: isActive ? [.playsSound, .updatesFrequently] : .isStaticText,
            value: value,
            identifier: "heartbeat"
        )
    }
    
    /// Adds progress bar accessibility
    func clappingProgressAccessibility(
        currentStep: Int,
        totalSteps: Int = 10
    ) -> some View {
        let percentage = Int((Double(currentStep) / Double(totalSteps)) * 100)
        let label = "Progress permainan: \(currentStep) dari \(totalSteps) langkah"
        let value = "\(percentage) persen selesai"
        
        return self.clappingAccessibility(
            label: label,
            hint: "Menunjukkan kemajuan permainan tepuk tangan",
            traits: .updatesFrequently,
            value: value,
            identifier: "progressBar"
        )
    }
}

/// Custom ViewModifier to handle clap feedback accessibility with conditional logic
struct ClapFeedbackAccessibilityModifier: ViewModifier {
    let showFeedback: Bool
    let isSuccessful: Bool
    
    func body(content: Content) -> some View {
        if showFeedback {
            let label = isSuccessful ? "Tepukan berhasil" : "Tepukan gagal"
            let hint = isSuccessful ? "Tepukan sesuai dengan irama" : "Tepukan terlalu cepat atau lambat"
            
            content.clappingAccessibility(
                label: label,
                hint: hint,
                traits: .playsSound,
                identifier: "clapFeedback"
            )
        } else {
            content.accessibilityHidden(true)
        }
    }
}
