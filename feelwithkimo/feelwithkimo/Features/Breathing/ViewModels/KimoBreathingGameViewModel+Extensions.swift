//
//  KimoBreathingGameViewModel+Extensions.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 25/10/25.
//

import SwiftUI

// MARK: - Computed Properties Extension
extension KimoBreathingGameViewModel {
    
    @MainActor
    var phaseDescription: String {
        let currentScene = gameState.getCurrentScene()
        let parentProgress = Int(gameState.parentBalloonProgress)
        let childProgress = Int(gameState.childBalloonProgress)
        
        switch gameState.currentPhase {
        case .welcome:
            return "Selamat datang! Mari berlatih pernapasan bersama Kimo! (Scene 1)"
        case .parentTurn:
            return "Scene \(currentScene): Giliran Ayah/Ibu meniup balon merah (\(parentProgress)% vs \(childProgress)%)"
        case .childTurn:
            return "Scene \(currentScene): Giliran anak meniup balon biru (\(parentProgress)% vs \(childProgress)%)"
        case .gameComplete:
            return "Scene 3: Selamat! Kedua balon sudah sempurna! (\(parentProgress)% & \(childProgress)%)"
        }
    }
    
    @MainActor
    var isCurrentlyDetecting: Bool {
        useAudioLevelDetection ? audioLevelDetector.isBreathing : breathDetectionManager.isDetecting
    }
    
    @MainActor
    var currentBreathTypeText: String {
        let breathType = useAudioLevelDetection ? audioLevelDetector.breathType : breathDetectionManager.currentBreathType
        switch breathType {
        case .inhale: return "Menghirup"
        case .exhale: return "Menghembuskan"
        case .none: return "Tidak terdeteksi"
        }
    }
    
    @MainActor
    var currentBreathTypeColor: Color {
        let breathType = useAudioLevelDetection ? audioLevelDetector.breathType : breathDetectionManager.currentBreathType
        switch breathType {
        case .inhale: return .blue
        case .exhale: return .green
        case .none: return .gray
        }
    }
}
