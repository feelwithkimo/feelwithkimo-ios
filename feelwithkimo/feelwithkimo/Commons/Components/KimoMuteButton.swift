//
//  KimoMuteButton.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//

import SwiftUI

/// A mute button for controlling background music
struct KimoMuteButton: View {
    @ObservedObject var audioManager: AudioManager
    var body: some View {
        Button(action: {
            audioManager.toggleMute()
        }, label: {
            ZStack {
                Circle()
                    .fill(ColorToken.grayscale60.toColor())
                    .frame(width: 65, height: 65)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 2)
                
                Image(audioManager.isMuted ? "Mute" : "Music")
                    .font(.app(.title3, family: .primary))
                    .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
            }
        })
        .scaleEffect(audioManager.isMuted ? 0.9 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: audioManager.isMuted)
        .kimoButtonAccessibility(
            label: audioManager.isMuted ? "Nyalakan musik latar" : "Matikan musik latar",
            hint: "Ketuk dua kali untuk \(audioManager.isMuted ? "menyalakan" : "mematikan") musik latar belakang",
            identifier: "kimoMuteButton"
        )
    }
}

#Preview {
    KimoMuteButton(audioManager: AudioManager.shared)
        .padding()
        .background(ColorToken.backgroundCard.toColor())
}
