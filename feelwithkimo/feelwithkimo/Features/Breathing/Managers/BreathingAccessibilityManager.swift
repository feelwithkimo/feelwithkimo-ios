//
//  BreathingAccessibilityManager.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import SwiftUI

/// Breathing-specific accessibility manager that extends the main AccessibilityManager
struct BreathingAccessibilityManager {
    /// Creates a breathing status announcement for accessibility
    static func announceBreathingStatus(breathType: BreathType, confidence: Double, isActive: Bool) {
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
        
        AccessibilityManager.announce(message, important: false)
    }
    
    /// Creates a game progress announcement
    static func announceGameProgress(parentProgress: Double, childProgress: Double, currentPlayer: PlayerType) {
        let parentPercent = Int(parentProgress * 100)
        let childPercent = Int(childProgress * 100)
        
        let message = "Progress balon: Ayah atau Ibu \(parentPercent) persen, Anak \(childPercent) persen. Sekarang giliran \(currentPlayer == .parent ? "Ayah atau Ibu" : "Anak")"
        
        AccessibilityManager.announce(message)
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
    
    /// Announces game phase changes
    static func announcePhaseChange(phase: GamePhase) {
        let message: String
        switch phase {
        case .welcome:
            message = "Selamat datang di permainan pernapasan. Siap untuk bermain?"
        case .parentTurn:
            message = "Giliran Ayah atau Ibu. Tiup balon merah dengan bernapas ke mikrofon."
        case .childTurn:
            message = "Giliran Anak. Tiup balon biru dengan bernapas ke mikrofon."
        case .gameComplete:
            message = "Selamat! Permainan pernapasan selesai. Kalian berhasil!"
        }
        
        AccessibilityManager.announce(message, important: true)
    }
    
    /// Announces balloon progress
    static func announceBalloonProgress(progress: Double, player: PlayerType) {
        let percent = Int(progress * 100)
        let playerName = player == .parent ? "Ayah atau Ibu" : "Anak"
        let balloonColor = player == .parent ? "merah" : "biru"
        
        let message = "Balon \(balloonColor) \(playerName) sudah \(percent) persen penuh"
        AccessibilityManager.announce(message)
    }
}

/// Extension to add breathing-specific accessibility modifiers to views
extension View {
    /// Adds comprehensive accessibility support for breathing app elements
    func breathingAccessibility(
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
            identifier: identifier.map { "breathing.\($0)" }
        )
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
        
        return self.breathingAccessibility(
            label: label,
            hint: hint,
            traits: .updatesFrequently,
            value: value,
            identifier: "breathDetection"
        )
    }
    
    /// Adds balloon accessibility
    func balloonAccessibility(
        player: PlayerType,
        progress: Double,
        isActive: Bool
    ) -> some View {
        let playerName = player == .parent ? "Ayah atau Ibu" : "Anak"
        let balloonColor = player == .parent ? "merah" : "biru"
        let percent = Int(progress * 100)
        let status = isActive ? "sedang aktif" : "menunggu"
        
        let label = "Balon \(balloonColor) untuk \(playerName), \(percent) persen penuh, \(status)"
        let hint = isActive ? "Bernapas ke mikrofon untuk mengembangkan balon" : "Menunggu giliran"
        
        return self.breathingAccessibility(
            label: label,
            hint: hint,
            traits: isActive ? .updatesFrequently : .isStaticText,
            value: "\(percent) persen",
            identifier: "balloon.\(player == .parent ? "parent" : "child")"
        )
    }
}
