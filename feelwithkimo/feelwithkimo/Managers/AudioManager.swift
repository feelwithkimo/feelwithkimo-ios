//
//  AudioManager.swift
//  Kimo
//
//  Created by Aristo Yongka on 12/10/25.
//

import AVFoundation
import Combine
import UIKit

final class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private var player: AVAudioPlayer?
    @Published var isMuted: Bool = false {
        didSet {
            updateVolume()
        }
    }
    private var baseVolume: Float = 1.0

    private init() {}

    /// Coba mainkan musik dengan 3 strategi:
    /// 1) Cari file "backsong.mp3" di bundle (kalau ternyata ada),
    /// 2) Cari file "backsong" TANPA ekstensi di bundle,
    /// 3) Ambil dari Assets.xcassets sebagai Data Asset bernama "backsong".
    func startBackgroundMusic(assetName: String = "backsong", volume: Float = 1.0) {
        if let audioPlayer = player, audioPlayer.isPlaying { return }
        self.baseVolume = volume

        // 1) URL dengan ekstensi mp3
        if let url = Bundle.main.url(forResource: assetName, withExtension: "mp3") {
            startFromURL(url)
            return
        }

        // 2) URL tanpa ekstensi
        if let urlNoExt = Bundle.main.url(forResource: assetName, withExtension: nil) {
            startFromURL(urlNoExt)
            return
        }

        // 3) Data Asset dari Assets.xcassets (nama "backsong")
        if let dataAsset = NSDataAsset(name: assetName) {
            startFromData(dataAsset.data, fileTypeHint: AVFileType.mp3.rawValue)
            return
        }

        // Jika semua gagal, beri log jelas
        assertionFailure("Audio '\(assetName)' tidak ditemukan sebagai file (.mp3 / tanpa ekstensi) atau Data Asset.")
    }

    private func startFromURL(_ url: URL) {
        do {
            try configureSession()
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = isMuted ? 0.0 : baseVolume
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            self.player = audioPlayer
            print("🎵 Start music from URL: \(url.lastPathComponent)")
        } catch {
            assertionFailure("Audio error (URL): \(error.localizedDescription)")
        }
    }

    private func startFromData(_ data: Data, fileTypeHint: String? = AVFileType.mp3.rawValue) {
        do {
            try configureSession()
            let audioPlayer = try AVAudioPlayer(data: data, fileTypeHint: fileTypeHint)
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = isMuted ? 0.0 : baseVolume
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            self.player = audioPlayer
            print("🎵 Start music from Data Asset")
        } catch {
            assertionFailure("Audio error (Data): \(error.localizedDescription)")
        }
    }

    private func configureSession() throws {
        let session = AVAudioSession.sharedInstance()
        // Use .playAndRecord to allow both music playback and microphone recording for breathing detection
        do {
            try session.setCategory(
                .playAndRecord,
                mode: .default,
                options: [.defaultToSpeaker, .allowBluetoothHFP]
            )
        } catch {
            print("Failed to set audio session category: \(error)")
        }

        try session.setActive(true)
    }
    private func updateVolume() {
        player?.volume = isMuted ? 0.0 : baseVolume
    }
    /// Toggle mute state for the background music
    func toggleMute() {
        isMuted.toggle()
    }
    /// Set volume (0.0 to 1.0), will be ignored if muted
    func setVolume(_ volume: Float) {
        baseVolume = min(max(volume, 0.0), 1.0)
        if !isMuted {
            player?.volume = baseVolume
        }
    }
    /// Check if music is currently playing
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }

    func stop() {
        player?.stop()
        player = nil
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
