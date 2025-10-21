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
    
    /// Breathing-related sound identifiers - only pure breathing/blowing sounds
    private let breathingSounds: Set<SoundIdentifierModel> = [
        SoundIdentifierModel(labelName: "breathing"),
        SoundIdentifierModel(labelName: "blowing")
    ]
    
    private var previousAudioLevel: Double = 0.0
    private let audioLevelThreshold: Double = 0.01
    
    init() {
        setupBreathDetection()
    }
    
    private func setupBreathDetection() {
        // Initialize with only breathing and blowing sounds - no other sounds
        do {
            let availableBreathingSounds = try BreathingSoundClassifier.getAllBreathingLabels()
            print("🫁 Available breathing labels: \(availableBreathingSounds)")
            
            // Only use breathing and blowing sounds
            let filteredSounds = availableBreathingSounds.filter { label in
                let lowercaseLabel = label.lowercased()
                return lowercaseLabel == "breathing" || lowercaseLabel == "blowing"
            }
            
            appConfig.monitoredSounds = Set(filteredSounds.map { SoundIdentifierModel(labelName: $0) })
            print("🫁 Monitoring sounds: \(appConfig.monitoredSounds.map { $0.labelName })")
        } catch {
            print("Error getting breathing labels: \(error)")
            // Fallback to basic breathing and blowing sounds only
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
          .map { ($0, DetectionState(presenceThreshold: 0.5,
                                     absenceThreshold: 0.3,
                                     presenceMeasurementsToStartDetection: 2,
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
        BreathingSoundClassifier.singleton.stopSoundClassification()
        detectionCancellable?.cancel()
        isDetecting = false
        soundDetectionIsRunning = false
        currentBreathType = .none
        breathingConfidence = 0.0
        audioLevel = 0.0
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
        
        breathingConfidence = maxBreathingConfidence
        
        // Determine breath type based on audio level changes - increased threshold for more accuracy
        if isBreathingDetected && maxBreathingConfidence > 0.5 {
            let audioLevelChange = audioLevel - previousAudioLevel
            
            if audioLevelChange > audioLevelThreshold {
                // Increasing audio level indicates inhaling or start of breathing
                if currentBreathType != .inhale {
                    currentBreathType = .inhale
                    print("🫁 INHALE detected - Confidence: \(String(format: "%.3f", maxBreathingConfidence))")
                }
            } else if audioLevelChange < -audioLevelThreshold && previousAudioLevel > 0.3 {
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
    static func getBreathingRelatedLabels() -> [String] {
        do {
            return Array(try BreathingSoundClassifier.getAllBreathingLabels())
        } catch {
            print("Error getting breathing labels: \(error)")
            return ["breathing", "blowing"]
        }
    }
}

/// Contains customizable settings that control breathing detection behavior
struct BreathingAppConfiguration {
    /// Indicates the amount of audio, in seconds, that informs a prediction
    var inferenceWindowSize = Double(1.0)

    /// The amount of overlap between consecutive analysis windows
    var overlapFactor = Double(0.8)

    /// A list of breathing sounds to identify from system audio input
    var monitoredSounds = Set<SoundIdentifierModel>()
}
