//
//  BreathingSoundClassifier.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import Foundation
import AVFoundation
import SoundAnalysis
import Combine

/// A class for performing breathing sound classification using Apple's SoundAnalysis framework
final class BreathingSoundClassifier: NSObject {
    /// A dispatch queue to asynchronously perform analysis on
    private let analysisQueue = DispatchQueue(label: "com.kimobreathing.AnalysisQueue")

    /// An audio engine the app uses to record system input
    private var audioEngine: AVAudioEngine?

    /// An analyzer that performs sound classification
    private var analyzer: SNAudioStreamAnalyzer?

    /// An array of sound analysis observers that the class stores to control their lifetimes
    private var retainedObservers: [SNResultsObserving]?

    /// A subject to deliver sound classification results to, including an error, if necessary
    private var subject: PassthroughSubject<SNClassificationResult, Error>?

    /// Initializes a BreathingSoundClassifier instance, and marks it as private because the instance operates as a singleton
    private override init() {}

    /// A singleton instance of the BreathingSoundClassifier class
    static let singleton = BreathingSoundClassifier()

    /// Requests permission to access microphone input, throwing an error if the user denies access
    private func ensureMicrophoneAccess() throws {
        var hasMicrophoneAccess = false
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .notDetermined:
            let sem = DispatchSemaphore(value: 0)
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { success in
                hasMicrophoneAccess = success
                sem.signal()
            })
            _ = sem.wait(timeout: DispatchTime.distantFuture)
        case .denied, .restricted:
            break
        case .authorized:
            hasMicrophoneAccess = true
        @unknown default:
            fatalError("unknown authorization status for microphone access")
        }

        if !hasMicrophoneAccess {
            throw BreathingClassificationError.noMicrophoneAccess
        }
    }

    /// Configures and activates an AVAudioSession
    private func startAudioSession() throws {
        stopAudioSession()
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true)
        } catch {
            stopAudioSession()
            throw error
        }
    }

    /// Deactivates the app's AVAudioSession
    private func stopAudioSession() {
        autoreleasepool {
            let audioSession = AVAudioSession.sharedInstance()
            try? audioSession.setActive(false)
        }
    }

    /// Starts observing for audio recording interruptions
    private func startListeningForAudioSessionInterruptions() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioSessionInterruption),
            name: AVAudioSession.interruptionNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioSessionInterruption),
            name: AVAudioSession.mediaServicesWereLostNotification,
            object: nil)
    }

    /// Stops observing for audio recording interruptions
    private func stopListeningForAudioSessionInterruptions() {
        NotificationCenter.default.removeObserver(
          self,
          name: AVAudioSession.interruptionNotification,
          object: nil)
        NotificationCenter.default.removeObserver(
          self,
          name: AVAudioSession.mediaServicesWereLostNotification,
          object: nil)
    }

    /// Handles notifications the system emits for audio interruptions
    @objc
    private func handleAudioSessionInterruption(_ notification: Notification) {
        let error = BreathingClassificationError.audioStreamInterrupted
        subject?.send(completion: .failure(error))
        stopSoundClassification()
    }
    
    /// Starts sound analysis of the system's audio input
    private func startAnalyzing(_ requestsAndObservers: [(SNRequest, SNResultsObserving)]) throws {
        stopAnalyzing()

        do {
            try startAudioSession()
            try ensureMicrophoneAccess()

            let newAudioEngine = AVAudioEngine()
            audioEngine = newAudioEngine

            let busIndex = AVAudioNodeBus(0)
            let bufferSize = AVAudioFrameCount(4096)
            let audioFormat = newAudioEngine.inputNode.outputFormat(forBus: busIndex)

            let newAnalyzer = SNAudioStreamAnalyzer(format: audioFormat)
            analyzer = newAnalyzer

            try requestsAndObservers.forEach { try newAnalyzer.add($0.0, withObserver: $0.1) }
            retainedObservers = requestsAndObservers.map { $0.1 }

            newAudioEngine.inputNode.installTap(
              onBus: busIndex,
              bufferSize: bufferSize,
              format: audioFormat,
              block: { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                  self.analysisQueue.async {
                      newAnalyzer.analyze(buffer, atAudioFramePosition: when.sampleTime)
                  }
              })

            try newAudioEngine.start()
        } catch {
            stopAnalyzing()
            throw error
        }
    }

    /// Stops the active sound analysis and resets the state of the class
    private func stopAnalyzing() {
        autoreleasepool {
            if let audioEngine = audioEngine {
                audioEngine.stop()
                audioEngine.inputNode.removeTap(onBus: 0)
            }

            if let analyzer = analyzer {
                analyzer.removeAllRequests()
            }

            analyzer = nil
            retainedObservers = nil
            audioEngine = nil
        }
        stopAudioSession()
    }

    /// Classifies system audio input using the built-in classifier for breathing detection
    func startSoundClassification(subject: PassthroughSubject<SNClassificationResult, Error>,
                                  inferenceWindowSize: Double = 1.0,
                                  overlapFactor: Double = 0.8) {
        stopSoundClassification()

        do {
            let observer = BreathingResultsSubject(subject: subject)

            let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
            request.windowDuration = CMTimeMakeWithSeconds(inferenceWindowSize, preferredTimescale: 48_000)
            request.overlapFactor = overlapFactor

            self.subject = subject

            startListeningForAudioSessionInterruptions()
            try startAnalyzing([(request, observer)])
        } catch {
            subject.send(completion: .failure(error))
            self.subject = nil
            stopSoundClassification()
        }
    }

    /// Stops any active sound classification task
    func stopSoundClassification() {
        stopAnalyzing()
        stopListeningForAudioSessionInterruptions()
    }

    /// Emits the set of labels producible by sound classification that are related to breathing
    static func getAllBreathingLabels() throws -> Set<String> {
        let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
        let allLabels = Set<String>(request.knownClassifications)
        
        // Only use very specific breathing and blowing labels - exclude wind and other ambiguous sounds
        let exactBreathingLabels = ["breathing", "blowing"]
        
        return allLabels.filter { label in
            let lowercaseLabel = label.lowercased()
            return exactBreathingLabels.contains(lowercaseLabel)
        }
    }
}

/// An observer that forwards breathing sound analysis results to a combine subject
class BreathingResultsSubject: NSObject, SNResultsObserving {
    private let subject: PassthroughSubject<SNClassificationResult, Error>

    init(subject: PassthroughSubject<SNClassificationResult, Error>) {
        self.subject = subject
    }

    func request(_ request: SNRequest,
                 didFailWithError error: Error) {
        subject.send(completion: .failure(error))
    }

    func requestDidComplete(_ request: SNRequest) {
        subject.send(completion: .finished)
    }

    func request(_ request: SNRequest,
                 didProduce result: SNResult) {
        if let result = result as? SNClassificationResult {
            subject.send(result)
        }
    }
}
