//
//  VoiceInstructionManager.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import AVFoundation
import Combine
import Foundation
import UIKit

@MainActor
internal class VoiceInstructionManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let speechSynthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking = false
    
    override init() {
        super.init()
        speechSynthesizer.delegate = self
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            // Set up audio session to work well with VoiceOver
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .spokenAudio,
                options: [.mixWithOthers, .duckOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
    func speak(_ text: String) {
        // Always provide voice guidance for children, regardless of VoiceOver status
        // Also post accessibility announcement for VoiceOver users
        if UIAccessibility.isVoiceOverRunning {
            UIAccessibility.post(notification: .announcement, argument: text)
        }
        
        // Always use speech synthesizer for voice guidance
        // If already speaking, stop current and speak new message (for immediate feedback)
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        
        // Set Indonesian language
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        
        // If Indonesian voice not available, try alternatives
        if utterance.voice == nil {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        
        utterance.rate = 0.4
        utterance.pitchMultiplier = 1.0
        utterance.volume = 0.8
        
        speechSynthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.isSpeaking = true
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.isSpeaking = false
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.isSpeaking = false
        }
    }
}

// Indonesian Instructions
extension VoiceInstructionManager {
    func speakWelcome() {
        speak("Selamat datang di Kimo Breathing! Mari berlatih pernapasan bersama Kimo si gajah. Ayah atau Ibu akan mulai dengan balon merah terlebih dahulu.")
    }
    
    func speakParentTurn() {
        speak("Giliran Ayah atau Ibu untuk meniup balon merah. Tarik napas dalam-dalam, lalu tiup perlahan.")
    }
    
    func speakChildTurn() {
        speak("Sekarang giliran anak untuk meniup balon biru. Tarik napas dalam-dalam, lalu tiup perlahan.")
    }
    
    func speakTurnSwitch(to player: PlayerType, progress: Double) {
        let progressPercent = Int(progress)
        switch player {
        case .parent:
            speak("Bagus! Sekarang giliran Ayah atau Ibu lagi dengan balon merah. Progress \(progressPercent) persen!")
        case .child:
            speak("Hebat! Sekarang giliran anak dengan balon biru. Progress \(progressPercent) persen!")
        }
    }
    
    func speakMilestoneReached(progress: Double, player: PlayerType) {
        let progressPercent = Int(progress)
        let balloonColor = player == .parent ? "merah" : "biru"
        
        switch progressPercent {
        case 25:
            speak("Seperempat balon \(balloonColor) sudah mengembang! Saatnya bergantian!")
        case 50:
            speak("Setengah balon \(balloonColor) sudah mengembang! Terus semangat!")
        case 75:
            speak("Tiga perempat balon \(balloonColor) sudah mengembang! Hampir selesai!")
        case 100:
            speak("Balon \(balloonColor) sudah penuh! Luar biasa!")
        default:
            break
        }
    }
    
    func speakInhaleInstruction() {
        speak("Tarik napas dalam-dalam")
    }
    
    func speakExhaleInstruction() {
        speak("Tiup balon perlahan-lahan")
    }
    
    func speakGoodJob() {
        speak("Bagus sekali! Lanjutkan!")
    }
    
    func speakBalloonComplete() {
        speak("Balon sudah mengembang penuh! Hebat!")
    }
    
    func speakGameComplete() {
        speak("Permainan selesai! Kedua balon sudah mengembang penuh! Kalian sangat hebat dalam berlatih pernapasan bersama Kimo!")
    }
    
    func speakSceneTransition(scene: Int) {
        switch scene {
        case 1:
            speak("Scene satu: Mari mulai dengan meniup balon bersama Kimo!")
        case 2:
            speak("Scene dua: Sekarang kita bergantian meniup balon!")
        case 3:
            speak("Scene tiga: Selamat! Kedua balon sudah sempurna!")
        default:
            break
        }
    }
    
    // Enhanced breathing detection instructions
    func speakBreathingDetectionStart() {
        speak("Deteksi napas dimulai. Bernapaslah dengan normal.")
    }
    
    func speakBreathingDetectionStop() {
        speak("Deteksi napas dihentikan.")
    }
    
    func speakBreathingGuide() {
        speak("Tarik napas dalam-dalam melalui hidung, tahan sebentar, lalu hembuskan perlahan melalui mulut.")
    }
    
    func speakInhaleDetected() {
        speak("Menghirup terdeteksi")
    }
    
    func speakExhaleDetected() {
        speak("Menghembuskan terdeteksi")
    }
    
    func speakBreathingPattern() {
        speak("Ikuti pola: Tarik napas, satu, dua, tiga. Hembuskan, satu, dua, tiga, empat, lima.")
    }
    
    func speakEncouragement() {
        let encouragements = [
            "Terus berlatih!",
            "Napas yang bagus!",
            "Pertahankan ritme!",
            "Sangat baik!",
            "Lanjutkan seperti itu!"
        ]
        if let randomEncouragement = encouragements.randomElement() {
            speak(randomEncouragement)
        }
    }
    
    func speakCalm() {
        speak("Tenangkan diri, bernapaslah perlahan dan dalam.")
    }
}
