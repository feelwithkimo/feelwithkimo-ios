///
///  BlockGameStageView.swift
///  feelwithkimo
///
///  Created by Aristo Yongka on 14/11/25.
///

import SwiftUI

struct BlockGameStageView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentState: BlockBuildingState = .stage1
    @State private var gameResetKey: Int = 0  /// Key to force game reset
    var onCompletion: (() -> Void)?
    
    var body: some View {
        ZStack {
            /// Always show the game view in the background
            switch currentState {
            case .stage1, .stage1Completed:
                BlocksGameView(level: .level1, onComplete: {
                    currentState = .stage1Completed
                })
                .id("level1-\(gameResetKey)")  /// Force recreate when key changes
                
            case .stage2, .stage2Completed:
                BlocksGameView(level: .level2, onComplete: {
                    currentState = .stage2Completed
                })
                .id("level2-\(gameResetKey)")  /// Force recreate when key changes
            }
            
            /// Overlay completion pages on top when needed
            if currentState == .stage1Completed {
                CompletionPageView(
                    title: "Tahap 1 Selesai!!!",
                    primaryButtonLabel: "Coba lagi",
                    secondaryButtonLabel: "Lanjutkan",
                    onPrimaryAction: {
                        /// Retry stage 1 - reset state first, then increment key
                        currentState = .stage1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            gameResetKey += 1
                        }
                    },
                    onSecondaryAction: {
                        /// Continue to stage 2 - reset state first, then increment key
                        currentState = .stage2
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            gameResetKey += 1
                        }
                    }
                )
                .transition(.opacity)
            }
            
            if currentState == .stage2Completed {
                CompletionPageView(
                    title: "Hore Berhasil!!!",
                    primaryButtonLabel: "Coba Lagi",
                    secondaryButtonLabel: "Lanjutkan",
                    onPrimaryAction: {
                        /// Retry stage 2 - reset state first, then increment key
                        currentState = .stage2
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            gameResetKey += 1
                        }
                    },
                    onSecondaryAction: {
                        dismiss()
                        onCompletion?()
                    },
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentState)
    }
}

#Preview {
    BlockGameStageView()
}
