//
//  BlocksGamePauseView.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 18/11/25.
//

import SwiftUI

struct BlocksGamePauseView: View {
    let onReset: () -> Void
    let onHome: () -> Void
    let onResume: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
            
            VStack(alignment: .center) {
                HStack {
                    KimoHomeButton(isLarge: true, action: onHome)
                    KimoResumeButton(isLarge: true, action: onResume)
                }
                
                HStack {
                    KimoReplayButton(isLarge: true, action: onReset)
                    KimoMuteButton(isLarge: true, audioManager: AudioManager.shared)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BlocksGamePauseView(
        onReset: { print("Reset") },
        onHome: { print("Home") },
        onResume: { print("Resume") }
    )
}
