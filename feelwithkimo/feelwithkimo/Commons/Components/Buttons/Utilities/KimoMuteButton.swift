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
            Image(audioManager.isMuted ? "Mute" : "Music")
                .resizable()
                .scaledToFit()
                .frame(width: 80.getWidth())
        })
        .scaleEffect(audioManager.isMuted ? 0.95 : 1.0)
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
