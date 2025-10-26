//
//  AccessibilityHelper.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import SwiftUI
import UIKit

/// Helper for accessibility features and VoiceOver support
struct AccessibilityManager {
    
    /// Checks if VoiceOver is currently running
    static var isVoiceOverRunning: Bool {
        return UIAccessibility.isVoiceOverRunning
    }
    
    /// Posts an accessibility announcement that works well with VoiceOver
    static func announce(_ message: String, important: Bool = false) {
        DispatchQueue.main.async {
            var announcement = message
            
            // Add priority prefix for important announcements
            if important {
                announcement = "Penting: \(message)"
            }
            
            UIAccessibility.post(notification: .announcement, argument: announcement)
        }
    }
    
    /// Creates a breathing status announcement for accessibility
    static func announceBreathingStatus(breathType: BreathType, confidence: Double, isActive: Bool) {
        guard isVoiceOverRunning else { return }
        
        var message = ""
        
        switch breathType {
        case .inhale:
            message = "Sedang menghirup napas"
        case .exhale:
            message = "Sedang menghembuskan napas"
        case .none:
            message = "Tidak ada napas terdeteksi"
        }
        
        if isActive && confidence > 0.5 {
            message += ", deteksi kuat"
        } else if isActive {
            message += ", deteksi lemah"
        }
        
        announce(message, important: false)
    }
    
    /// Creates a game progress announcement
    static func announceGameProgress(parentProgress: Double, childProgress: Double, currentPlayer: PlayerType) {
        guard isVoiceOverRunning else { return }
        
        let parentPercent = Int(parentProgress * 100)
        let childPercent = Int(childProgress * 100)
        
        let message = "Progress balon: Ayah atau Ibu \(parentPercent) persen, Anak \(childPercent) persen. Sekarang giliran \(currentPlayer == .parent ? "Ayah atau Ibu" : "Anak")"
        
        announce(message)
    }
    
    /// Creates an accessibility hint for breathing exercises
    static func createBreathingHint(phase: GamePhase) -> String {
        switch phase {
        case .welcome:
            return "Ketuk tombol Mulai Bermain untuk memulai latihan pernapasan"
        case .parentTurn:
            return "Ayah atau Ibu harus meniup balon merah dengan bernapas ke mikrofon"
        case .childTurn:
            return "Anak harus meniup balon biru dengan bernapas ke mikrofon"
        case .gameComplete:
            return "Latihan pernapasan selesai! Ketuk Mulai Ulang untuk bermain lagi"
        }
    }
}

/// Extension to add accessibility modifiers to views
extension View {
    /// Adds comprehensive accessibility support for breathing app elements
    func breathingAccessibility(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = [],
        value: String? = nil
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
            .accessibilityValue(value ?? "")
    }
    
    /// Adds breathing game specific accessibility
    func breathingGameAccessibility(
        isActive: Bool,
        breathType: BreathType,
        confidence: Double
    ) -> some View {
        let label = "Deteksi napas \(isActive ? "aktif" : "tidak aktif")"
        let value = breathType == .none ? "Tidak ada napas" : (breathType == .inhale ? "Menghirup" : "Menghembuskan")
        let hint = "Bernapaslah normal ke mikrofon untuk bermain"
        
        return self
            .accessibilityLabel(label)
            .accessibilityValue(value)
            .accessibilityHint(hint)
            .accessibilityAddTraits(.updatesFrequently)
    }
}
