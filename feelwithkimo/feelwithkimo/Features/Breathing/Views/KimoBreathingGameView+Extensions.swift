//
//  KimoBreathingGameView+Extensions.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 25/10/25.
//
import Foundation
import SwiftUI

struct HeaderView: View {
    let phaseDescription: String
    var body: some View {
        VStack(spacing: 8) {
            Text("Kimo Breathing")
                .font(.app(.largeTitle, family: .primary))
                .foregroundStyle(ColorToken.textPrimary.toColor())
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel("Kimo Breathing - Aplikasi Latihan Pernapasan")
            Text(phaseDescription)
                .font(.app(.title2, family: .primary))
                .foregroundStyle(ColorToken.textSecondary.toColor())
                .multilineTextAlignment(.center)
                .accessibilityLabel(phaseDescription)
        }
        .accessibilityElement(children: .combine)
    }
}

struct KimoImageView: View {
    @ObservedObject var gameState: GameStateManager
    var body: some View {
        VStack(spacing: 8) {
            Group {
                if gameState.isGameActive {
                    Image(gameState.currentPlayer.kimoImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .scaleEffect(1.05)
                        .animation(.easeInOut(duration: 0.5), value: gameState.currentPlayer)
                        .accessibilityLabel(
                            "Scene \(gameState.getCurrentScene()): Kimo sedang \(gameState.currentPlayer == .parent ? "membantu orang tua meniup balon merah" : "membantu anak meniup balon biru")"
                        )
                } else if gameState.currentPhase == .gameComplete {
                    Image("KimoBreathing-Happy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .scaleEffect(1.1)
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                            value: gameState.currentPhase == .gameComplete
                        )
                        .accessibilityLabel("Scene 3: Kimo gajah yang sangat bahagia karena kedua balon sudah penuh!")
                } else {
                    Image("KimoBreathing-Happy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .accessibilityLabel("Kimo gajah yang bahagia, siap membantu latihan pernapasan")
                }
            }
            .shadow(radius: 5)
            .accessibilityAddTraits(.isImage)
            if gameState.isGameActive || gameState.currentPhase == .gameComplete {
                Text("Scene \(gameState.getCurrentScene())")
                    .font(.app(.caption1, family: .primary))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule().fill(Color.purple.opacity(0.8))
                    )
                    .shadow(radius: 2)
            }
        }
    }
}

struct ProgressSectionView: View {
    @ObservedObject var gameState: GameStateManager
    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Ayah/Ibu 🎈")
                        .font(.app(.caption1, family: .primary))
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                    Spacer()
                    Text("\(Int(gameState.parentBalloonProgress))%")
                        .font(.app(.caption1, family: .primary))
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                    if gameState.currentPlayer == .parent && gameState.isGameActive {
                        Text("← AKTIF")
                            .font(.app(.caption2, family: .primary))
                            .fontWeight(.bold)
                            .foregroundStyle(.red)
                    }
                }
                BreathingProgressBar(
                    progress: gameState.parentBalloonProgress,
                    color: .red
                )
                .opacity(
                    gameState.currentPlayer == .parent && gameState.isGameActive ? 1.0 : 0.6
                )
                .animation(.easeInOut(duration: 0.3), value: gameState.currentPlayer)
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Anak 🎈")
                        .font(.app(.caption1, family: .primary))
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                    Spacer()
                    Text("\(Int(gameState.childBalloonProgress))%")
                        .font(.app(.caption1, family: .primary))
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                    if gameState.currentPlayer == .child && gameState.isGameActive {
                        Text("← AKTIF")
                            .font(.app(.caption2, family: .primary))
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    }
                }
                BreathingProgressBar(
                    progress: gameState.childBalloonProgress,
                    color: .blue
                )
                .opacity(
                    gameState.currentPlayer == .child && gameState.isGameActive ? 1.0 : 0.6
                )
                .animation(.easeInOut(duration: 0.3), value: gameState.currentPlayer)
            }
            if gameState.isGameActive {
                HStack(spacing: 8) {
                    Text("Bergantian setiap:")
                        .font(.app(.caption2, family: .primary))
                        .foregroundStyle(.gray)
                    ForEach([25, 50, 75, 100], id: \.self) { milestone in
                        Circle()
                            .fill(gameState.getCurrentBalloonProgress() >= Double(milestone) ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .overlay(
                                Text("\(milestone)")
                                    .font(.system(size: 6))
                                    .foregroundStyle(.white)
                            )
                    }
                    Text("%")
                        .font(.app(.caption2, family: .primary))
                        .foregroundStyle(ColorToken.grayscale100.toColor())
                }
                .padding(.top, 8)
            }
        }
        .padding(.horizontal)
    }
}

struct BreathInfoSectionView: View {
    @Binding var useAudioLevelDetection: Bool
    let isCurrentlyDetecting: Bool
    let audioLevel: Double
    let confidence: Double
    let currentBreathTypeText: String
    let currentBreathTypeColor: Color
    let toggleMode: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Mode Deteksi:")
                    .font(.app(.caption1, family: .primary))
                    .fontWeight(.medium)
                    .foregroundStyle(ColorToken.textSecondary.toColor())
                Button(action: toggleMode) {
                    Text(useAudioLevelDetection ? "Audio Level" : "SoundAnalysis")
                        .font(.app(.caption1, family: .primary))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
                .accessibilityLabel("Ubah mode deteksi")
                .accessibilityValue(useAudioLevelDetection ? "Mode level audio" : "Mode SoundAnalysis")
            }
            HStack {
                Circle()
                    .fill(isCurrentlyDetecting ? Color.green : Color.gray)
                    .frame(width: 12, height: 12)
                Text(isCurrentlyDetecting ? "Mendeteksi napas..." : "Tidak mendeteksi")
                    .font(.app(.caption1, family: .primary))
                    .foregroundStyle(ColorToken.textSecondary.toColor())
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Audio Level: \(String(format: "%.3f", audioLevel))")
                    .font(.app(.caption1, family: .primary))
                    .foregroundStyle(ColorToken.textSecondary.toColor())
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 8)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.green)
                            .frame(
                                width: geometry.size.width * min(audioLevel * 20, 1.0),
                                height: 8
                            )
                    }
                }
                .frame(height: 8)
            }
            if confidence > 0 {
                Text("Kepercayaan: \(Int(confidence * 100))%")
                    .font(.app(.caption1, family: .primary))
                    .foregroundStyle(ColorToken.textSecondary.toColor())
            }
            Text("Jenis napas: \(currentBreathTypeText)")
                .font(.app(.caption1, family: .primary))
                .fontWeight(.medium)
                .foregroundStyle(currentBreathTypeColor)
        }
        .padding()
        .background(ColorToken.grayscale10.toColor())
        .cornerRadius(10)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Informasi deteksi napas")
    }
}

struct ControlButtonsSectionView: View {
    @ObservedObject var gameState: GameStateManager
    let isCurrentlyDetecting: Bool
    let useAudioLevelDetection: Bool
    let resetAction: () -> Void
    let configureAction: () -> Void
    let speak: (String) -> Void
    let showGuide: () -> Void
    let onCompletion: (() -> Void)?
    let audioManager: AudioManager
    let startGame: () -> Void
    let toggleDetection: () -> Void
    let handleContinueAction: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            if gameState.currentPhase == .welcome {
                Button(action: startGame) {
                    Text("Mulai Bermain")
                        .font(.app(.title2, family: .primary))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(15)
                        .accessibilityLabel("Mulai bermain latihan pernapasan dengan Kimo")
                }
            } else if gameState.currentPhase == .gameComplete {
                // Show only "Lanjut" button when game is completed
                Button(action: handleContinueAction) {
                    Text("Lanjut")
                        .font(.app(.title2, family: .primary))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .accessibilityLabel("Lanjut ke cerita berikutnya")
                        .accessibilityHint("Ketuk untuk melanjutkan cerita setelah latihan pernapasan selesai")
                }
            } else {
                Button(action: resetAction) {
                    Text("Mulai Ulang")
                        .font(.app(.title3, family: .primary))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(15)
                        .accessibilityLabel("Mulai ulang permainan dari awal")
                        .accessibilityHint("Ketuk untuk memulai ulang latihan pernapasan")
                }
                let currentDetectionLabel = isCurrentlyDetecting ? "Hentikan deteksi napas" : "Mulai deteksi napas"
                let currentDetectionHint = isCurrentlyDetecting ? "Ketuk untuk menghentikan pendeteksian napas" : "Ketuk untuk mulai mendeteksi napas"
                Button(action: toggleDetection) {
                    Text(isCurrentlyDetecting ? "Stop" : "Mulai Deteksi")
                        .font(.app(.title3, family: .primary))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isCurrentlyDetecting ? Color.red : Color.blue)
                        .cornerRadius(15)
                        .accessibilityLabel(currentDetectionLabel)
                        .accessibilityHint(currentDetectionHint)
                }
                Button(action: configureAction) {
                    Text("Pengaturan")
                        .font(.app(.title3, family: .primary))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(15)
                        .accessibilityLabel("Pengaturan deteksi suara")
                        .accessibilityHint("Ketuk untuk mengatur suara napas yang akan dideteksi")
                }
            }
        }
    }
}

struct OrientationGuideView: View {
    let showOrientationGuide: Bool
    var body: some View {
        VStack {
            if showOrientationGuide {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "mic.fill")
                            .font(.app(.title2, family: .primary))
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(Color.red.opacity(0.9))
                            .clipShape(Circle())
                            .scaleEffect(showOrientationGuide ? 1.1 : 1.0)
                            .animation(
                                .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                                value: showOrientationGuide
                            )
                        Image(systemName: "chevron.left")
                            .font(.app(.title1, family: .primary))
                            .foregroundStyle(.yellow)
                            .scaleEffect(1.2)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tiup ke sini")
                                .font(.app(.headline, family: .primary))
                                .foregroundStyle(.white)
                            Text("Mikrofon iPad")
                                .font(.app(.caption1, family: .primary))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.8))
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 2, y: 2)
                    )
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.right")
                            .font(.app(.caption1, family: .primary))
                            .foregroundStyle(.green)
                        Text("Bernapaslah ke arah mikrofon")
                            .font(.app(.caption1, family: .primary))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green.opacity(0.8))
                    )
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .opacity
                    )
                )
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showOrientationGuide)
            }
        }
        .padding(.leading, 20)
        .padding(.bottom, 100)
    }
}
