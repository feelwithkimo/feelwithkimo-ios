//
//  MusicMuteButton.swift
//  feelwithkimo
//
//  Created by GitHub Copilot on 21/10/25.
//

import SwiftUI

/// A mute button for controlling background music
struct MusicMuteButton: View {
    @ObservedObject var audioManager: AudioManager
    var body: some View {
        Button(action: {
            audioManager.toggleMute()
        }, label: {
            ZStack {
                // Larger invisible tap area
                Circle()
                    .fill(Color.clear)
                    .frame(width: 70, height: 70) // Larger tap target
                // Visible button
                Circle()
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 50, height: 50)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 2)
                Image(systemName: audioManager.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
        })
        .scaleEffect(audioManager.isMuted ? 0.9 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: audioManager.isMuted)
        .accessibilityLabel(audioManager.isMuted ? "Nyalakan musik latar" : "Matikan musik latar")
        .accessibilityHint("Ketuk untuk \(audioManager.isMuted ? "menyalakan" : "mematikan") musik latar belakang")
    }
}

#Preview {
    MusicMuteButton(audioManager: AudioManager.shared)
        .padding()
        .background(Color.blue.opacity(0.3))
}
