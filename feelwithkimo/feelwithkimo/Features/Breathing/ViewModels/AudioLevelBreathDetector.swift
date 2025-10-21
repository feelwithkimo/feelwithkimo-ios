//
//  AudioLevelBreathDetector.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import Foundation
import AVFoundation
import Combine

class AudioLevelBreathDetector: ObservableObject {
    @Published var audioLevel: Double = 0.0
    @Published var isBreathing: Bool = false
    @Published var breathType: BreathType = .none
    private let audioEngine = AVAudioEngine()
    private var audioLevelTimer: Timer?
    private var previousLevel: Double = 0.0
    private let breathThreshold: Double = 0.02
    private let changeThreshold: Double = 0.01
    func startDetection() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.processAudioBuffer(buffer)
            }
            try audioEngine.start()
            print("🎤 Audio level detection started")
        } catch {
            print("Failed to start audio detection: \(error)")
        }
    }
    func stopDetection() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioLevelTimer?.invalidate()
        DispatchQueue.main.async {
            self.audioLevel = 0.0
            self.isBreathing = false
            self.breathType = .none
        }
        print("🔇 Audio level detection stopped")
    }
    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let channelDataArray = Array(UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))
        // Calculate RMS (Root Mean Square) for audio level
        let rms = sqrt(channelDataArray.map { $0 * $0 }.reduce(0, +) / Float(channelDataArray.count))
        let level = Double(rms)
        DispatchQueue.main.async {
            self.audioLevel = level
            self.detectBreathPattern(level: level)
        }
    }
    private func detectBreathPattern(level: Double) {
        let levelChange = level - previousLevel
        if level > breathThreshold {
            isBreathing = true
            if levelChange > changeThreshold {
                breathType = .inhale
                print("🫁 Audio Level INHALE - Level: \(level), Change: \(levelChange)")
            } else if levelChange < -changeThreshold {
                breathType = .exhale
                print("💨 Audio Level EXHALE - Level: \(level), Change: \(levelChange)")
            }
        } else {
            isBreathing = false
            breathType = .none
        }
        previousLevel = level
    }
}
