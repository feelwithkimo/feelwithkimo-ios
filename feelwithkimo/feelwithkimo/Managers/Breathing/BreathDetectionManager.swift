//
//  BreathDetectionManager.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import Foundation
import Combine
import SoundAnalysis
import AVFoundation

/// Breath detection manager using Apple's SoundAnalysis framework
class BreathDetectionManager: ObservableObject {
    @Published var currentBreathType: BreathType = .none
    @Published var breathingConfidence: Double = 0.0
    @Published var isDetecting = false
    @Published var audioLevel: Double = 0.0
    @Published var detectionStates: [(SoundIdentifierModel, DetectionState)] = []
    @Published var soundDetectionIsRunning: Bool = false
    /// A cancellable object for the lifetime of the sound classification
    private var detectionCancellable: AnyCancellable? = nil
    /// The configuration that governs sound classification
    private var appConfig = BreathingAppConfiguration()
    /// Breathing-related sound identifiers - including sounds that resemble breathing
    private let breathingSounds: Set<SoundIdentifierModel> = [
        SoundIdentifierModel(labelName: "breathing"),
        SoundIdentifierModel(labelName: "blowing"),
        SoundIdentifierModel(labelName: "wind"),
        SoundIdentifierModel(labelName: "whoosh"),
        SoundIdentifierModel(labelName: "rustling"),
        SoundIdentifierModel(labelName: "air_conditioning"),
        SoundIdentifierModel(labelName: "breeze"),
        SoundIdentifierModel(labelName: "sigh"),
        SoundIdentifierModel(labelName: "whistle"),
        SoundIdentifierModel(labelName: "hiss"),
        SoundIdentifierModel(labelName: "gust"),
        SoundIdentifierModel(labelName: "puff")
    ]
    private var previousAudioLevel: Double = 0.0
    private let audioLevelThreshold: Double = 0.02  // Increased from 0.01 to reduce sensitivity
    init() {
        setupBreathDetection()
    }
    private func setupBreathDetection() {
        // Initialize with breathing-related sounds including wind-like sounds
        do {
            let availableBreathingSounds = try BreathingSoundClassifier.getAllBreathingLabels()
            print("🫁 Available breathing labels: \(availableBreathingSounds)")
            // Use breathing and wind-like sounds that resemble breathing but exclude speech/crowd
            let filteredSounds = availableBreathingSounds.filter { label in
                let lowercaseLabel = label.lowercased()
                return lowercaseLabel.contains("breath") || 
                       lowercaseLabel.contains("blow") ||
                       lowercaseLabel.contains("wind") ||
                       lowercaseLabel.contains("whoosh") ||
                       lowercaseLabel.contains("rustle") ||
                       lowercaseLabel.contains("air") ||
                       lowercaseLabel.contains("breeze") ||
                       lowercaseLabel.contains("sigh") ||
                       lowercaseLabel.contains("whistle") ||
                       lowercaseLabel.contains("hiss") ||
                       lowercaseLabel.contains("gust") ||
                       lowercaseLabel.contains("puff") &&
                       !lowercaseLabel.contains("speech") &&
                       !lowercaseLabel.contains("crowd") &&
                       !lowercaseLabel.contains("music") &&
                       !lowercaseLabel.contains("voice") &&
                       !lowercaseLabel.contains("talk")
            }
            appConfig.monitoredSounds = Set(filteredSounds.map { SoundIdentifierModel(labelName: $0) })
            print("🫁 Monitoring sounds: \(appConfig.monitoredSounds.map { $0.labelName })")
        } catch {
            print("Error getting breathing labels: \(error)")
            // Fallback to expanded breathing sounds
            appConfig.monitoredSounds = breathingSounds
        }
    }
    /// Begins detecting breathing sounds according to the configuration
    func startDetection() {
        print("🫁 Starting breathing detection with SoundAnalysis...")
        BreathingSoundClassifier.singleton.stopSoundClassification()

        let classificationSubject = PassthroughSubject<SNClassificationResult, Error>()

        detectionCancellable =
          classificationSubject
          .receive(on: DispatchQueue.main)
          .sink(receiveCompletion: { _ in
              self.soundDetectionIsRunning = false
              self.isDetecting = false
          },
                receiveValue: { [weak self] result in
                    self?.processBreathingResult(result)
                })

        self.detectionStates =
          [SoundIdentifierModel](appConfig.monitoredSounds)
          .sorted(by: { $0.displayName < $1.displayName })
          .map { ($0, DetectionState(presenceThreshold: 0.65,
                                     absenceThreshold: 0.4,
                                     presenceMeasurementsToStartDetection: 3,
                                     absenceMeasurementsToEndDetection: 8))
          }

        soundDetectionIsRunning = true
        isDetecting = true
        BreathingSoundClassifier.singleton.startSoundClassification(
          subject: classificationSubject,
          inferenceWindowSize: appConfig.inferenceWindowSize,
          overlapFactor: appConfig.overlapFactor)
    }
    func stopDetection() {
        print("🛑 Stopping breathing detection...")
        // Stop sound classification first
        BreathingSoundClassifier.singleton.stopSoundClassification()
        
        // Cancel and clean up detection
        detectionCancellable?.cancel()
        detectionCancellable = nil
        
        // Reset state
        isDetecting = false
        soundDetectionIsRunning = false
        currentBreathType = .none
        breathingConfidence = 0.0
        audioLevel = 0.0
        
        // Clear detection states to prevent memory leaks
        detectionStates.removeAll()
        
        print("🛑 Breathing detection fully stopped and cleaned up")
    }
    /// Processes breathing classification results and determines breath type
    private func processBreathingResult(_ result: SNClassificationResult) {
        // Update detection states for breathing and blowing sounds only
        self.detectionStates = BreathDetectionManager.advanceDetectionStates(
            self.detectionStates,
            givenClassificationResult: result
        )
        // Find the strongest breathing-related detection
        var maxBreathingConfidence: Double = 0.0
        var isBreathingDetected = false
        for (_, state) in detectionStates {
            if state.isDetected && state.currentConfidence > maxBreathingConfidence {
                maxBreathingConfidence = state.currentConfidence
                isBreathingDetected = true
                // Estimate audio level from confidence
                audioLevel = state.currentConfidence
            }
        }
        // If no breathing detected through classification, try basic audio level detection
        if !isBreathingDetected {
            // Use simple audio level detection as fallback
            let averageConfidence = result.classifications.reduce(0.0) { sum, classification in
                sum + Double(classification.confidence)
            } / Double(result.classifications.count)
            if averageConfidence > 0.15 { // Increased threshold from 0.1 to reduce sensitivity
                maxBreathingConfidence = averageConfidence * 0.5 // Scale down for fallback detection
                isBreathingDetected = true
                audioLevel = maxBreathingConfidence
            }
        }
        breathingConfidence = maxBreathingConfidence
        // Determine breath type based on audio level changes - balanced threshold for better detection
        if isBreathingDetected && maxBreathingConfidence > 0.6 { // Increased from 0.5 to reduce false positives
            let audioLevelChange = audioLevel - previousAudioLevel
            if audioLevelChange > audioLevelThreshold {
                // Increasing audio level indicates inhaling or start of breathing
                if currentBreathType != .inhale {
                    currentBreathType = .inhale
                    print("🫁 INHALE detected - Confidence: \(String(format: "%.3f", maxBreathingConfidence))")
                }
            } else if audioLevelChange < -audioLevelThreshold && previousAudioLevel > 0.4 { // Increased threshold from 0.3 to 0.4
                // Decreasing audio level after detection indicates exhaling
                if currentBreathType != .exhale {
                    currentBreathType = .exhale
                    print("💨 EXHALE detected - Confidence: \(String(format: "%.3f", maxBreathingConfidence))")
                }
            }
        } else {
            currentBreathType = .none
        }
        previousAudioLevel = audioLevel
    }
    /// Updates the detection states according to the latest classification result
    static func advanceDetectionStates(_ oldStates: [(SoundIdentifierModel, DetectionState)],
                                       givenClassificationResult result: SNClassificationResult) -> [(SoundIdentifierModel, DetectionState)] {
        let confidenceForLabel = { (sound: SoundIdentifierModel) -> Double in
            let confidence: Double
            let label = sound.labelName
            if let classification = result.classification(forIdentifier: label) {
                confidence = Double(classification.confidence)
            } else {
                confidence = 0
            }
            return confidence
        }
        return oldStates.map { (key, value) in
            (key, DetectionState(advancedFrom: value, currentConfidence: confidenceForLabel(key)))
        }
    }
    /// Get all breathing-related labels that the classifier can detect
    static let breahitngRelatedLabels: [String] = ["breathing", "blowing", "wind", "whoosh", "rustling", "air_conditioning", "breeze", "sigh", "whistle", "hiss", "gust", "puff"]
    static func getBreathingRelatedLabels() -> [String] {
        do {
            return Array(try BreathingSoundClassifier.getAllBreathingLabels())
        } catch {
            print("Error getting breathing labels: \(error)")
            return breahitngRelatedLabels
        }
    }
}

/// Contains customizable settings that control breathing detection behavior
struct BreathingAppConfiguration {
    /// Indicates the amount of audio, in seconds, that informs a prediction
    var inferenceWindowSize = Double(0.75)
    /// The amount of overlap between consecutive analysis windows
    var overlapFactor = Double(0.9)
    /// A list of breathing sounds to identify from system audio input
    var monitoredSounds = Set<SoundIdentifierModel>()
}
