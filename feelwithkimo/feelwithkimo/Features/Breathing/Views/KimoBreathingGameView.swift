//
//  KimoBreathingGameView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import AVFoundation
import SwiftUI
import UIKit

// MARK: - KimoBreathingGameView

struct KimoBreathingGameView: View {
    @ObservedObject var breathDetectionManager: BreathDetectionManager
    @StateObject private var viewModel: KimoBreathingGameViewModel
    @Binding var config: BreathingAppConfiguration
    let configureAction: () -> Void
    let onCompletion: (() -> Void)?

    init(
        breathDetectionManager: BreathDetectionManager,
        config: Binding<BreathingAppConfiguration>,
        configureAction: @escaping () -> Void,
        onCompletion: (() -> Void)? = nil
    ) {
        self.breathDetectionManager = breathDetectionManager
        self._config = config
        self.configureAction = configureAction
        self.onCompletion = onCompletion
        
        // Initialize ViewModel with dependencies
        self._viewModel = StateObject(wrappedValue: KimoBreathingGameViewModel(
            breathDetectionManager: breathDetectionManager,
            config: config,
            configureAction: configureAction,
            onCompletion: onCompletion
        ))
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack(spacing: 20) {
                    HeaderView(phaseDescription: viewModel.phaseDescription)
                    KimoImageView(gameState: viewModel.gameState)
                    BalloonsSectionView(gameState: viewModel.gameState)
                    ProgressSectionView(gameState: viewModel.gameState)
                    BreathInfoSectionView(
                        useAudioLevelDetection: $viewModel.useAudioLevelDetection,
                        isCurrentlyDetecting: viewModel.isCurrentlyDetecting,
                        audioLevel: viewModel.useAudioLevelDetection ? viewModel.audioLevelDetector.audioLevel : breathDetectionManager.audioLevel,
                        confidence: viewModel.useAudioLevelDetection ? viewModel.audioLevelDetector.audioLevel * 10 : breathDetectionManager.breathingConfidence,
                        currentBreathTypeText: viewModel.currentBreathTypeText,
                        currentBreathTypeColor: viewModel.currentBreathTypeColor,
                        toggleMode: viewModel.toggleDetectionMode
                    )
                    Spacer()
                    ControlButtonsSectionView(
                        gameState: viewModel.gameState,
                        isCurrentlyDetecting: viewModel.isCurrentlyDetecting,
                        useAudioLevelDetection: viewModel.useAudioLevelDetection,
                        resetAction: { 
                            viewModel.resetGame()
                            viewModel.showOrientationGuideWithDelay()
                        },
                        configureAction: configureAction,
                        speak: { viewModel.voiceManager.speak($0) },
                        showGuide: viewModel.showOrientationGuideWithDelay,
                        onCompletion: onCompletion,
                        audioManager: viewModel.audioManager,
                        startGame: viewModel.startGame,
                        toggleDetection: viewModel.toggleDetection,
                        handleContinueAction: viewModel.handleContinueAction
                    )
                    Spacer()
                }
                .padding()
                // Mute button in top right corner
                VStack {
                    HStack {
                        Spacer()
                        MusicMuteButton(audioManager: viewModel.audioManager)
                            .padding(.top, 10)
                            .padding(.trailing, 20)
                    }
                    Spacer()
                }
            }
        }
        .background(backgroundGradient)
        .onAppear(perform: viewModel.handleViewAppear)
        .onDisappear(perform: viewModel.handleViewDisappear)
        .onChange(of: viewModel.gameState.currentPhase) { _, newPhase in
            viewModel.handlePhaseChange(newPhase)
        }
        .onChange(of: viewModel.gameState.currentPlayer) { oldPlayer, newPlayer in
            viewModel.handlePlayerChange(oldPlayer: oldPlayer, newPlayer: newPlayer)
        }
        .onChange(of: viewModel.gameState.parentBalloonProgress) { oldProgress, newProgress in
            viewModel.checkMilestoneProgress(
                oldProgress: oldProgress,
                newProgress: newProgress,
                player: .parent
            )
        }
        .onChange(of: viewModel.gameState.childBalloonProgress) { oldProgress, newProgress in
            viewModel.checkMilestoneProgress(
                oldProgress: oldProgress,
                newProgress: newProgress,
                player: .child
            )
        }
        .onChange(of: breathDetectionManager.currentBreathType) { _, breathType in
            viewModel.handleBreathDetected(
                breathType: breathType,
                confidence: breathDetectionManager.breathingConfidence
            )
        }
        .onChange(of: viewModel.audioLevelDetector.breathType) { _, breathType in
            viewModel.handleAudioLevelBreathDetected(
                breathType: breathType,
                audioLevel: viewModel.audioLevelDetector.audioLevel
            )
        }
        .alert("Izin Mikrofon Diperlukan", isPresented: $viewModel.showingPermissionAlert) {
            Button("Pengaturan") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            Button("Batal", role: .cancel) { }
        } message: {
            Text("Aplikasi memerlukan akses mikrofon untuk mendeteksi napas. Silakan aktifkan di Pengaturan.")
        }
        .overlay(
            OrientationGuideView(showOrientationGuide: viewModel.showOrientationGuide),
            alignment: .bottomLeading
        )
    }
    
    // MARK: - Helper Properties
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.green.opacity(0.1),
                Color.blue.opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    KimoBreathingGameView(
        breathDetectionManager: BreathDetectionManager(),
        config: .constant(BreathingAppConfiguration()),
        configureAction: {},
        onCompletion: nil
    )
}
