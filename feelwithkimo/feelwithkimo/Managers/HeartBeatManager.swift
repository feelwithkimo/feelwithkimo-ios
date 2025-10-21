//
//  HeartBeatManager.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 21/10/25.
//

// MARK: - HeartBeatManager
import Foundation
import AVFoundation

// MARK: - HeartBeatManager
final class HeartBeatManager: ObservableObject {
    private var player: AVAudioPlayer?

    func playLoopedSound(named name: String, fileExtension: String = "wav") {
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            print("❌ Sound file not found: \(name).\(fileExtension)")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1  // loop forever
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌ Failed to play sound: \(error)")
        }
    }

    func stopSound() {
        player?.stop()
    }
}
