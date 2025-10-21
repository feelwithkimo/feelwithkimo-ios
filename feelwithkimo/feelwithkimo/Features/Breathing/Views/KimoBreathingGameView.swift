//
//  KimoBreathingGameView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import SwiftUI
import AVFoundation
import UIKit

// MARK: - KimoBreathingGameView

struct KimoBreathingGameView: View {
    @ObservedObject var breathDetectionManager: BreathDetectionManager
    @StateObject private var audioLevelDetector = AudioLevelBreathDetector()
    @StateObject private var gameState = GameStateManager()
    @StateObject private var voiceManager = VoiceInstructionManager()
    @Binding var config: BreathingAppConfiguration
    let configureAction: () -> Void

    @State private var showingPermissionAlert = false
    @State private var hasRequestedPermission = false
    @State private var useAudioLevelDetection = false
    @State private var showOrientationGuide = false

    init(
        breathDetectionManager: BreathDetectionManager,
        config: Binding<BreathingAppConfiguration>,
        configureAction: @escaping () -> Void
    ) {
        self.breathDetectionManager = breathDetectionManager
        self._config = config
        self.configureAction = configureAction
    }

    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 20) {
                HeaderView(phaseDescription: phaseDescription)
                KimoImageView(gameState: gameState)
                BalloonsSectionView(gameState: gameState)
                ProgressSectionView(gameState: gameState)
                BreathInfoSectionView(
                    useAudioLevelDetection: $useAudioLevelDetection,
                    isCurrentlyDetecting: isCurrentlyDetecting,
                    audioLevel: useAudioLevelDetection ? audioLevelDetector.audioLevel : breathDetectionManager.audioLevel,
                    confidence: useAudioLevelDetection ? audioLevelDetector.audioLevel * 10 : breathDetectionManager.breathingConfidence,
                    currentBreathTypeText: currentBreathTypeText,
                    currentBreathTypeColor: currentBreathTypeColor,
                    startSoundAnalysis: { breathDetectionManager.startDetection() },
                    stopSoundAnalysis: { breathDetectionManager.stopDetection() },
                    startAudioLevel: { audioLevelDetector.startDetection() },
                    stopAudioLevel: { audioLevelDetector.stopDetection() },
                    speak: { voiceManager.speak($0) }
                )
                Spacer()
                ControlButtonsSectionView(
                    gameState: gameState,
                    isCurrentlyDetecting: isCurrentlyDetecting,
                    useAudioLevelDetection: useAudioLevelDetection,
                    startAudioLevel: { audioLevelDetector.startDetection() },
                    stopAudioLevel: { audioLevelDetector.stopDetection() },
                    startSoundAnalysis: { breathDetectionManager.startDetection() },
                    stopSoundAnalysis: { breathDetectionManager.stopDetection() },
                    resetAction: { resetGame() },
                    configureAction: configureAction,
                    speak: { voiceManager.speak($0) },
                    showGuide: {
                        showOrientationGuide = true
                        voiceManager.speak("Bernapaslah ke arah mikrofon iPad yang berada di sisi kiri. Lihat panah kuning untuk petunjuk arah.")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showOrientationGuide = false
                            }
                        }
                    }
                )
                Spacer()
            }
            .padding()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.green.opacity(0.1),
                    Color.blue.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .onAppear { Task { await requestMicrophonePermission() } }
        .onChange(of: gameState.currentPhase) { _, phase in
            handlePhaseChange(phase)
        }
        .onChange(of: gameState.currentPlayer) { oldPlayer, newPlayer in
            if oldPlayer != newPlayer && gameState.isGameActive {
                let currentProgress = gameState.getCurrentBalloonProgress()
                voiceManager.speakTurnSwitch(to: newPlayer, progress: currentProgress)
            }
        }
        .onChange(of: gameState.parentBalloonProgress) { oldProgress, newProgress in
            checkMilestoneProgress(
                oldProgress: oldProgress,
                newProgress: newProgress,
                player: .parent
            )
        }
        .onChange(of: gameState.childBalloonProgress) { oldProgress, newProgress in
            checkMilestoneProgress(
                oldProgress: oldProgress,
                newProgress: newProgress,
                player: .child
            )
        }
        .onChange(of: breathDetectionManager.currentBreathType) { _, breathType in
            if !useAudioLevelDetection {
                gameState.processBreath(
                    type: breathType,
                    confidence: breathDetectionManager.breathingConfidence
                )
                if gameState.isGameActive {
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
            }
        }
        .onChange(of: audioLevelDetector.breathType) { _, breathType in
            if useAudioLevelDetection {
                gameState.processBreath(
                    type: breathType,
                    confidence: audioLevelDetector.audioLevel * 10
                )
                if gameState.isGameActive {
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
            }
        }
        .alert("Izin Mikrofon Diperlukan", isPresented: $showingPermissionAlert) {
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
            OrientationGuideView(showOrientationGuide: showOrientationGuide),
            alignment: .bottomLeading
        )
    }

    // MARK: - Helper Properties

    private var phaseDescription: String {
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

    private var isCurrentlyDetecting: Bool {
        useAudioLevelDetection ? audioLevelDetector.isBreathing : breathDetectionManager.isDetecting
    }

    private var currentBreathTypeText: String {
        let breathType = useAudioLevelDetection ? audioLevelDetector.breathType : breathDetectionManager.currentBreathType
        switch breathType {
        case .inhale: return "Menghirup"
        case .exhale: return "Menghembuskan"
        case .none: return "Tidak terdeteksi"
        }
    }

    private var currentBreathTypeColor: Color {
        let breathType = useAudioLevelDetection ? audioLevelDetector.breathType : breathDetectionManager.currentBreathType
        switch breathType {
        case .inhale: return .blue
        case .exhale: return .green
        case .none: return .gray
        }
    }

    // MARK: - Helper Methods

    private func requestMicrophonePermission() async {
        let granted = await withCheckedContinuation { (continuation: CheckedContinuation<Bool, Never>) in
            AVAudioSession.sharedInstance().requestRecordPermission { allowed in
                continuation.resume(returning: allowed)
            }
        }
        await MainActor.run {
            if !granted { self.showingPermissionAlert = true }
        }
    }

    private func handlePhaseChange(_ phase: GamePhase) {
        switch phase {
        case .welcome:
            voiceManager.speakWelcome()
        case .parentTurn:
            voiceManager.speakParentTurn()
        case .childTurn:
            voiceManager.speakChildTurn()
        case .gameComplete:
            voiceManager.speakGameComplete()
            breathDetectionManager.stopDetection()
        }
    }

    private func resetGame() {
        breathDetectionManager.stopDetection()
        audioLevelDetector.stopDetection()
        gameState.resetGame()
        voiceManager.stopSpeaking()
        voiceManager.speak("Permainan direset. Siap untuk bermain lagi!")
    }

    private func checkMilestoneProgress(
        oldProgress: Double,
        newProgress: Double,
        player: PlayerType
    ) {
        let milestones: [Double] = [25.0, 50.0, 75.0, 100.0]
        for milestone in milestones {
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
}

struct OrientationGuideView: View {
    let showOrientationGuide: Bool
    var body: some View {
        VStack {
            if showOrientationGuide {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "mic.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.red.opacity(0.9))
                            .clipShape(Circle())
                            .scaleEffect(showOrientationGuide ? 1.1 : 1.0)
                            .animation(
                                .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                                value: showOrientationGuide
                            )
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.yellow)
                            .scaleEffect(1.2)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tiup ke sini")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Mikrofon iPad")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
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
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("Bernapaslah ke arah mikrofon")
                            .font(.caption)
                            .foregroundColor(.white)
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

struct HeaderView: View {
    let phaseDescription: String
    var body: some View {
        VStack(spacing: 8) {
            Text("Kimo Breathing")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel("Kimo Breathing - Aplikasi Latihan Pernapasan")
            Text(phaseDescription)
                .font(.title2)
                .foregroundColor(.secondary)
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
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
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

struct BalloonsSectionView: View {
    @ObservedObject var gameState: GameStateManager
    var body: some View {
        HStack(spacing: 40) {
            VStack {
                Text("Ayah/Ibu")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(
                        gameState.currentPlayer == .parent && gameState.isGameActive ? .red : .gray
                    )
                BalloonView(
                    progress: gameState.parentBalloonProgress,
                    color: .red,
                    isActive: gameState.currentPlayer == .parent && gameState.isGameActive
                )
                .scaleEffect(
                    gameState.currentPlayer == .parent && gameState.isGameActive ? 1.1 : 1.0
                )
                .animation(.easeInOut(duration: 0.3), value: gameState.currentPlayer == .parent)
                if gameState.currentPlayer == .parent && gameState.isGameActive {
                    Text("🎈 GILIRANMU!")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                            value: gameState.isGameActive
                        )
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Balon merah untuk ayah atau ibu")
            .accessibilityValue(
                "Progress \(Int(gameState.parentBalloonProgress)) persen, \(gameState.currentPlayer == .parent && gameState.isGameActive ? "aktif, giliran meniup sekarang" : "menunggu giliran")"
            )
            if gameState.isGameActive {
                VStack {
                    Text("🐘").font(.title).scaleEffect(1.2)
                    Text("Kimo").font(.caption2).foregroundColor(.gray)
                }
            }
            VStack {
                Text("Anak")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(
                        gameState.currentPlayer == .child && gameState.isGameActive ? .blue : .gray
                    )
                BalloonView(
                    progress: gameState.childBalloonProgress,
                    color: .blue,
                    isActive: gameState.currentPlayer == .child && gameState.isGameActive
                )
                .scaleEffect(
                    gameState.currentPlayer == .child && gameState.isGameActive ? 1.1 : 1.0
                )
                .animation(.easeInOut(duration: 0.3), value: gameState.currentPlayer == .child)
                if gameState.currentPlayer == .child && gameState.isGameActive {
                    Text("🎈 GILIRANMU!")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                            value: gameState.isGameActive
                        )
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Balon biru untuk anak")
            .accessibilityValue(
                "Progress \(Int(gameState.childBalloonProgress)) persen, \(gameState.currentPlayer == .child && gameState.isGameActive ? "aktif, giliran meniup sekarang" : "menunggu giliran")"
            )
        }
        .accessibilityElement(children: .ignore)
    }
}

struct ProgressSectionView: View {
    @ObservedObject var gameState: GameStateManager
    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Ayah/Ibu 🎈")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                    Spacer()
                    Text("\(Int(gameState.parentBalloonProgress))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    if gameState.currentPlayer == .parent && gameState.isGameActive {
                        Text("← AKTIF")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
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
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    Spacer()
                    Text("\(Int(gameState.childBalloonProgress))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    if gameState.currentPlayer == .child && gameState.isGameActive {
                        Text("← AKTIF")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
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
                        .font(.caption2)
                        .foregroundColor(.gray)
                    ForEach([25, 50, 75, 100], id: \.self) { milestone in
                        Circle()
                            .fill(gameState.getCurrentBalloonProgress() >= Double(milestone) ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .overlay(
                                Text("\(milestone)")
                                    .font(.system(size: 6))
                                    .foregroundColor(.white)
                            )
                    }
                    Text("%")
                        .font(.caption2)
                        .foregroundColor(.gray)
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
    let startSoundAnalysis: () -> Void
    let stopSoundAnalysis: () -> Void
    let startAudioLevel: () -> Void
    let stopAudioLevel: () -> Void
    let speak: (String) -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Mode Deteksi:")
                    .font(.caption)
                    .fontWeight(.medium)
                Button(action: toggleMode) {
                    Text(useAudioLevelDetection ? "Audio Level" : "SoundAnalysis")
                        .font(.caption)
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
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Audio Level: \(String(format: "%.3f", audioLevel))")
                    .font(.caption)
                    .foregroundColor(.secondary)
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
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text("Jenis napas: \(currentBreathTypeText)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(currentBreathTypeColor)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Informasi deteksi napas")
    }

    private func toggleMode() {
        useAudioLevelDetection.toggle()
        if useAudioLevelDetection {
            stopSoundAnalysis()
            startAudioLevel()
            speak("Beralih ke deteksi level audio")
        } else {
            stopAudioLevel()
            startSoundAnalysis()
            speak("Beralih ke klasifikasi suara Apple")
        }
    }
}

struct ControlButtonsSectionView: View {
    @ObservedObject var gameState: GameStateManager
    let isCurrentlyDetecting: Bool
    let useAudioLevelDetection: Bool
    let startAudioLevel: () -> Void
    let stopAudioLevel: () -> Void
    let startSoundAnalysis: () -> Void
    let stopSoundAnalysis: () -> Void
    let resetAction: () -> Void
    let configureAction: () -> Void
    let speak: (String) -> Void
    let showGuide: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            if gameState.currentPhase == .welcome {
                Button(action: startGame) {
                    Text("Mulai Bermain")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(15)
                        .accessibilityLabel("Mulai bermain latihan pernapasan dengan Kimo")
                }
            } else {
                Button(action: {
                    resetAction()
                    showGuide()
                }) {
                    Text("Mulai Ulang")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(15)
                        .accessibilityLabel("Mulai ulang permainan dari awal")
                        .accessibilityHint("Ketuk untuk memulai ulang latihan pernapasan")
                }
                Button(action: toggleDetection) {
                    Text(isCurrentlyDetecting ? "Stop" : "Mulai Deteksi")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isCurrentlyDetecting ? Color.red : Color.blue)
                        .cornerRadius(15)
                        .accessibilityLabel(isCurrentlyDetecting ? "Hentikan deteksi napas" : "Mulai deteksi napas")
                        .accessibilityHint(
                            isCurrentlyDetecting ? "Ketuk untuk menghentikan pendeteksian napas" : "Ketuk untuk mulai mendeteksi napas"
                        )
                }
                Button(action: configureAction) {
                    Text("Pengaturan")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
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

    private func startGame() {
        gameState.startGame()
        if useAudioLevelDetection {
            startAudioLevel()
            speak("Permainan dimulai dengan deteksi level audio. Bersiaplah untuk menarik napas!")
        } else {
            startSoundAnalysis()
            speak("Permainan dimulai dengan SoundAnalysis Apple. Bersiaplah untuk menarik napas!")
        }
    }

    private func toggleDetection() {
        if useAudioLevelDetection {
            if isCurrentlyDetecting {
                stopAudioLevel()
                speakBreathingDetectionStop()
            } else {
                startAudioLevel()
                speakBreathingDetectionStart()
            }
        } else {
            if isCurrentlyDetecting {
                stopSoundAnalysis()
                speakBreathingDetectionStop()
            } else {
                startSoundAnalysis()
                speakBreathingDetectionStart()
            }
        }
    }

    private func speakBreathingDetectionStart() { speak("Deteksi napas dimulai") }
    private func speakBreathingDetectionStop() { speak("Deteksi napas dihentikan") }
}

#Preview {
    KimoBreathingGameView(
        breathDetectionManager: BreathDetectionManager(),
        config: .constant(BreathingAppConfiguration()),
        configureAction: {}
    )
}
