//
//  KimoBreathingGameViewModel.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 25/10/25.
//

import AVFoundation
import Foundation
import SwiftUI

internal class KimoBreathingGameViewModel: ObservableObject {
    // MARK: - State Management
    @Published var showingPermissionAlert = false
    @Published var hasRequestedPermission = false
    @Published var useAudioLevelDetection = false
    @Published var showOrientationGuide = false
    
    // MARK: - Managers (Lazy initialization for better performance)
    @MainActor private(set) lazy var audioLevelDetector = AudioLevelBreathDetector()
    @MainActor private(set) lazy var gameState = GameStateManager()
    @MainActor private(set) lazy var voiceManager = VoiceInstructionManager()
    let audioManager = AudioManager.shared
    
    // MARK: - Dependencies
    let breathDetectionManager: BreathDetectionManager
    let config: Binding<BreathingAppConfiguration>
    let configureAction: () -> Void
    let onCompletion: (() -> Void)?
    
    // MARK: - Constants
    static let breathingMusicVolume: Float = 0.3
    static let normalMusicVolume: Float = 1.0
    static let orientationGuideDelay: TimeInterval = 8.0
    static let milestones: [Double] = [25.0, 50.0, 75.0, 100.0]
    
    // MARK: - Initialization
    init(
        breathDetectionManager: BreathDetectionManager,
        config: Binding<BreathingAppConfiguration>,
        configureAction: @escaping () -> Void,
        onCompletion: (() -> Void)? = nil
    ) {
        self.breathDetectionManager = breathDetectionManager
        self.config = config
        self.configureAction = configureAction
        self.onCompletion = onCompletion
    }
    
    // MARK: - Helper Methods
    func requestMicrophonePermission() async {
        guard !hasRequestedPermission else { return }
        
        let granted: Bool = await withCheckedContinuation { continuation in
            if #available(iOS 17.0, *) {
                AVAudioApplication.requestRecordPermission { allowed in
                    continuation.resume(returning: allowed)
                }
            } else {
                AVAudioSession.sharedInstance().requestRecordPermission { allowed in
                    continuation.resume(returning: allowed)
                }
            }
        }

        await MainActor.run {
            self.hasRequestedPermission = true
            if !granted {
                self.showingPermissionAlert = true
            }
        }
    }
    
    @MainActor
    func handleViewAppear() {
        Task { await requestMicrophonePermission() }
        audioManager.startBackgroundMusic(volume: Self.breathingMusicVolume)
        print("🎵 Breathing game music started at 30% volume")
    }
    
    func handleViewDisappear() {
        print("🎮 KimoBreathingGameView disappeared")
    }

    @MainActor
    func handlePhaseChange(_ phase: GamePhase) {
        switch phase {
        case .welcome:
            voiceManager.speakWelcome()
        case .parentTurn:
            voiceManager.speakParentTurn()
        case .childTurn:
            voiceManager.speakChildTurn()
        case .gameComplete:
            voiceManager.speakGameComplete()
            stopAllDetection()
        }
    }

    @MainActor
    func resetGame() {
        stopAllDetection()
        gameState.resetGame()
        voiceManager.stopSpeaking()
        voiceManager.speak("Permainan direset. Siap untuk bermain lagi!")
        // Keep the background music playing during reset
    }
    
    @MainActor
    func startGame() {
        gameState.startGame()
        if useAudioLevelDetection {
            audioLevelDetector.startDetection()
            voiceManager.speak("Permainan dimulai dengan deteksi level audio. Bersiaplah untuk menarik napas!")
        } else {
            breathDetectionManager.startDetection()
            voiceManager.speak("Permainan dimulai dengan SoundAnalysis Apple. Bersiaplah untuk menarik napas!")
        }
    }
    
    @MainActor
    func toggleDetection() {
        if useAudioLevelDetection {
            if isCurrentlyDetecting {
                audioLevelDetector.stopDetection()
                voiceManager.speak("Deteksi napas dihentikan")
            } else {
                audioLevelDetector.startDetection()
                voiceManager.speak("Deteksi napas dimulai")
            }
        } else {
            if isCurrentlyDetecting {
                breathDetectionManager.stopDetection()
                voiceManager.speak("Deteksi napas dihentikan")
            } else {
                breathDetectionManager.startDetection()
                voiceManager.speak("Deteksi napas dimulai")
            }
        }
    }
    
    @MainActor
    func toggleDetectionMode() {
        useAudioLevelDetection.toggle()
        if useAudioLevelDetection {
            breathDetectionManager.stopDetection()
            audioLevelDetector.startDetection()
            voiceManager.speak("Beralih ke deteksi level audio")
        } else {
            audioLevelDetector.stopDetection()
            breathDetectionManager.startDetection()
            voiceManager.speak("Beralih ke klasifikasi suara Apple")
        }
    }
    
    @MainActor
    func showOrientationGuideWithDelay() {
        showOrientationGuide = true
        voiceManager.speak("Bernapaslah ke arah mikrofon iPad yang berada di sisi kiri. Lihat panah kuning untuk petunjuk arah.")
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.orientationGuideDelay) {
            withAnimation(.easeOut(duration: 0.5)) {
                self.showOrientationGuide = false
            }
        }
    }
    
    @MainActor
    func handleContinueAction() {
        voiceManager.speak("Latihan pernapasan selesai! Melanjutkan cerita...")
        print("🎮 Continue button pressed - calling completion callback")
        // Stop current music and restart at full volume
        audioManager.stop()
        audioManager.startBackgroundMusic(volume: Self.normalMusicVolume)
        audioManager.setVolume(Self.normalMusicVolume)
        print("🎵 Music stopped and restarted at 100% volume from Lanjut button")
        onCompletion?()
    }
    
    @MainActor
    func handleBreathDetected(breathType: BreathType, confidence: Double) {
        guard !useAudioLevelDetection else { return }
        
        gameState.processBreath(type: breathType, confidence: confidence)
        
        guard gameState.isGameActive else { return }
        
        switch breathType {
        case .inhale:
            let message = gameState.currentPlayer == .parent
                ? "Bagus Ayah atau Ibu! Terus tarik napas."
                : "Bagus anak! Terus tarik napas."
            voiceManager.speak(message)
        case .exhale:
            let message = gameState.currentPlayer == .parent
                ? "Sempurna! Tiup balon merahnya."
                : "Sempurna! Tiup balon birunya."
            voiceManager.speak(message)
        case .none:
            break
        }
    }
    
    @MainActor
    func handleAudioLevelBreathDetected(breathType: BreathType, audioLevel: Double) {
        guard useAudioLevelDetection else { return }
        
        gameState.processBreath(type: breathType, confidence: audioLevel * 10)
        
        guard gameState.isGameActive else { return }
        
        switch breathType {
        case .inhale:
            voiceManager.speak(
                gameState.currentPlayer == .parent
                    ? "Ayah atau Ibu sedang menarik napas dengan baik!"
                    : "Anak sedang menarik napas dengan baik!"
            )
        case .exhale:
            voiceManager.speak(
                gameState.currentPlayer == .parent
                    ? "Tiup balon merah lebih kuat!"
                    : "Tiup balon biru lebih kuat!"
            )
        case .none:
            break
        }
    }
    
    @MainActor
    func handlePlayerChange(oldPlayer: PlayerType, newPlayer: PlayerType) {
        if oldPlayer != newPlayer && gameState.isGameActive {
            let currentProgress = gameState.getCurrentBalloonProgress()
            voiceManager.speakTurnSwitch(to: newPlayer, progress: currentProgress)
        }
    }

    @MainActor
    func checkMilestoneProgress(
        oldProgress: Double,
        newProgress: Double,
        player: PlayerType
    ) {
        for milestone in Self.milestones {
            if oldProgress < milestone && newProgress >= milestone {
                voiceManager.speakMilestoneReached(progress: milestone, player: player)
                let currentScene = gameState.getCurrentScene()
                if milestone == 50.0 && currentScene == 2 {
                    voiceManager.speakSceneTransition(scene: 2)
                } else if milestone == 100.0 &&
                            gameState.parentBalloonProgress >= 100.0 &&
                            gameState.childBalloonProgress >= 100.0 {
                    voiceManager.speakSceneTransition(scene: 3)
                }
                break
            }
        }
    }
    
    // MARK: - Private Methods
    @MainActor
    private func stopAllDetection() {
        breathDetectionManager.stopDetection()
        audioLevelDetector.stopDetection()
    }
}
