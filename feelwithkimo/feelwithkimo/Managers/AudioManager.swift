//
//  AudioManager.swift
//  Kimo
//
//  Created by Aristo Yongka on 12/10/25.
//

import AVFoundation
import Combine
import UIKit

final class AudioManager: NSObject, ObservableObject {
    static let shared = AudioManager()

    // Separate players so multiple sounds can run in parallel
    private var backgroundPlayer: AVAudioPlayer?
    private var effectPlayer: AVAudioPlayer?

    // Optional: remember current background asset name
    private(set) var currentBackgroundAsset: String?

    @Published var isMuted: Bool = false {
        didSet { updateVolume() }
    }

    /// baseVolume controls the background player's volume (0.0 .. 1.0)
    private var baseVolume: Float = 1.0

    private override init() {
        super.init()
        // audio session configuration is lazy and called before playback in helpers,
        // but you can call configureSession() here if you prefer early activation.
    }

    // MARK: - Background music

    /// Start background music. If the same asset is already playing and forceRestart is false, this is a no-op.
    func startBackgroundMusic(
        assetName: String = "backsong",
        volume: Float = 1.0,
        forceRestart: Bool = false,
        loop: Bool = true
    ) {
        // If already playing the same asset and not asked to restart, do nothing.
        if let player = backgroundPlayer,
           player.isPlaying,
           !forceRestart,
           currentBackgroundAsset == assetName {
            return
        }

        currentBackgroundAsset = assetName
        baseVolume = min(max(volume, 0.0), 1.0)

        // Try resources in order: mp3, no extension, NSDataAsset
        if let url = Bundle.main.url(forResource: assetName, withExtension: "mp3") ??
                     Bundle.main.url(forResource: assetName, withExtension: nil) {
            startBackgroundFromURL(url, loop: loop)
            return
        }

        if let dataAsset = NSDataAsset(name: assetName) {
            startBackgroundFromData(dataAsset.data, fileTypeHint: AVFileType.mp3.rawValue, loop: loop)
            return
        }

        assertionFailure("Audio '\(assetName)' not found as .mp3, file without extension, or NSDataAsset.")
    }

    // MARK: - Sound effects

    /// Play a one-off sound effect (stored so you can stop it early). Playing a new effect stops any previous effect.
    func playSoundEffect(effectName: String, volume: Float = 1.0, loop: Bool = false, soundExtension: String = "mp3") {
        guard effectName != "" else { return }
        
        // Stop existing effect (we only keep a single effect player in this manager)
        effectPlayer?.stop()
        effectPlayer = nil

        guard let url = Bundle.main.url(forResource: effectName, withExtension: soundExtension)
                ?? Bundle.main.url(forResource: effectName, withExtension: nil) else {
            if let dataAsset = NSDataAsset(name: effectName) {
                startEffectFromData(dataAsset.data, fileTypeHint: AVFileType.mp3.rawValue, volume: volume, loop: loop)
            } else {
                print("⚠️ Effect '\(effectName)' not found in bundle or NSDataAsset.")
            }
            return
        }

        startEffectFromURL(url, volume: volume, loop: loop)
    }

    /// Stop only the current sound effect, leave background playing
    func stopEffectOnly() {
        effectPlayer?.stop()
        effectPlayer = nil
    }

    // MARK: - Control / volume

    private func updateVolume() {
        // Mute flag only affects background music in this implementation.
        backgroundPlayer?.volume = isMuted ? 0.0 : baseVolume
    }

    func toggleMute() {
        isMuted.toggle()
    }

    func setVolume(_ volume: Float) {
        baseVolume = min(max(volume, 0.0), 1.0)
        if !isMuted {
            backgroundPlayer?.volume = baseVolume
        }
    }

    var isPlaying: Bool {
        return backgroundPlayer?.isPlaying ?? false
    }

    // Stop everything and deactivate session
    func stopAll() {
        backgroundPlayer?.stop()
        backgroundPlayer = nil
        currentBackgroundAsset = nil

        effectPlayer?.stop()
        effectPlayer = nil
    }

    // MARK: - Private helpers

    // Configure the audio session. We include .mixWithOthers so playback can coexist with other audio.
    private func configureSessionIfNeeded() throws {
        let session = AVAudioSession.sharedInstance()

        // Prefer mixing behavior so multiple players can play simultaneously and other apps can keep audio
        // Also keep .playAndRecord because the app uses mic for breathing detection; include defaultToSpeaker and allowBluetoothHFP
        let options: AVAudioSession.CategoryOptions = [.defaultToSpeaker, .allowBluetoothHFP, .mixWithOthers]

        do {
            try session.setCategory(.playAndRecord, mode: .default, options: options)
        } catch {
            // If setting playAndRecord fails for some reason, fallback to .playback with mixing to avoid catastrophic failure.
            print("Warning: setCategory(.playAndRecord) failed: \(error). Falling back to .playback with .mixWithOthers.")
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        }

        try session.setActive(true)
    }

    private func makePlayer(from url: URL, volume: Float, loop: Bool) -> AVAudioPlayer? {
        do {
            try configureSessionIfNeeded()
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = loop ? -1 : 0
            player.volume = volume
            player.prepareToPlay()
            player.delegate = self
            return player
        } catch {
            print("Failed to create AVAudioPlayer for url \(url): \(error)")
            return nil
        }
    }

    private func makePlayer(from data: Data, fileTypeHint: String?, volume: Float, loop: Bool) -> AVAudioPlayer? {
        do {
            try configureSessionIfNeeded()
            let player = try AVAudioPlayer(data: data, fileTypeHint: fileTypeHint)
            player.numberOfLoops = loop ? -1 : 0
            player.volume = volume
            player.prepareToPlay()
            player.delegate = self
            return player
        } catch {
            print("Failed to create AVAudioPlayer from data: \(error)")
            return nil
        }
    }

    // Background helpers
    private func startBackgroundFromURL(_ url: URL, loop: Bool) {
        backgroundPlayer?.stop()      // stop any existing background player
        backgroundPlayer = makePlayer(from: url, volume: isMuted ? 0.0 : baseVolume, loop: loop)
        backgroundPlayer?.play()
    }

    private func startBackgroundFromData(_ data: Data, fileTypeHint: String?, loop: Bool) {
        backgroundPlayer?.stop()
        backgroundPlayer = makePlayer(from: data, fileTypeHint: fileTypeHint, volume: isMuted ? 0.0 : baseVolume, loop: loop)
        backgroundPlayer?.play()
    }

    // Effect helpers
    private func startEffectFromURL(_ url: URL, volume: Float, loop: Bool) {
        let player = makePlayer(from: url, volume: volume, loop: loop)
        effectPlayer = player
        effectPlayer?.play()
    }

    private func startEffectFromData(_ data: Data, fileTypeHint: String?, volume: Float, loop: Bool) {
        let player = makePlayer(from: data, fileTypeHint: fileTypeHint, volume: volume, loop: loop)
        effectPlayer = player
        effectPlayer?.play()
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Clean up effect player automatically when it finishes
        if player === effectPlayer {
            effectPlayer = nil
        }
        // If background player finished (unlikely when loop = true), clean it up
        if player === backgroundPlayer {
            backgroundPlayer = nil
            currentBackgroundAsset = nil
        }
    }
}
