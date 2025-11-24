//
//  PauseView.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 18/11/25.
//

import SwiftUI

struct PauseView: View {
    let onReset: () -> Void
    let onHome: () -> Void
    let onResume: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            ColorToken.additionalColorsBlack.toColor().opacity(0.8)
            
            VStack(alignment: .center) {
                HStack {
                    KimoHomeButton(isLarge: true, action: onHome)
                    KimoResumeButton(isLarge: true, action: onResume)
                }
                
                HStack {
                    KimoBackButton(imagePath: "BackButton", action: onBack)
                    KimoReplayButton(isLarge: true, action: onReset)
                    KimoMuteButton(isLarge: true, audioManager: AudioManager.shared)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PauseView(
        onReset: { print("Reset") },
        onHome: { print("Home") },
        onResume: { print("Resume") },
        onBack: { print("Back") }
    )
}
