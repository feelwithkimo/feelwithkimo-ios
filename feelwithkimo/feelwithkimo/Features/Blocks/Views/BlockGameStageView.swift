///
///  BlockGameStageView.swift
///  feelwithkimo
///
///  Created by Aristo Yongka on 14/11/25.
///

import SwiftUI

struct BlockGameStageView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showCompletion: Bool = false
    @State private var gameResetKey: Int = 0
    
    var phase: Int  // 1 or 2
    var onCompletion: (() -> Void)?
    @ObservedObject var storyViewModel: StoryViewModel
    
    var currentLevel: GameLevel {
        return phase == 1 ? .level1 : .level2
    }
    
    var completionTitle: String {
        return phase == 1 ? "Tahap 1 Selesai!!!" : "Hore Berhasil!!!"
    }
    
    var body: some View {
        ZStack {
            /// Show the game view
            BlocksGameView(level: currentLevel, onComplete: {
                showCompletion = true
            }, storyViewModel: storyViewModel)
            .id("level\(phase)-\(gameResetKey)")
            
            /// Overlay completion page when game is complete
            if showCompletion {
                CompletionPageView(
                    title: completionTitle,
                    primaryButtonLabel: "Coba lagi",
                    secondaryButtonLabel: "Lanjutkan",
                    onPrimaryAction: {
                        /// Retry current phase
                        showCompletion = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            gameResetKey += 1
                        }
                    },
                    onSecondaryAction: {
                        /// Complete current phase and return to story
                        /// Call completion BEFORE dismiss to ensure phase updates
                        onCompletion?()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showCompletion)
    }
}
