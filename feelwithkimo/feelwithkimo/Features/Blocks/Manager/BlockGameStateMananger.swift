//
//  BlockGameStateManager.swift
//  feelwithkimo
//
//  Created by Aristo Yongka on 14/11/25.
//

import SwiftUI

struct BlockGameStateManager: View {
    @State private var currentState: BlockBuildingState = .stage1
    
    var body: some View {
        ZStack {
            // Always show the game view in the background
            switch currentState {
            case .stage1, .stage1Completed:
                BlocksGameView(level: .level1, onComplete: {
                    currentState = .stage1Completed
                })
                
            case .stage2, .stage2Completed:
                BlocksGameView(level: .level2, onComplete: {
                    currentState = .stage2Completed
                })
            }
            
            // Overlay completion pages on top when needed
            if currentState == .stage1Completed {
                CompletionPageView(
                    title: "Tahap 1 Selesai!!!",
                    primaryButtonLabel: "Coba lagi",
                    secondaryButtonLabel: "Lanjutkan",
                    onPrimaryAction: {
                        // Retry stage 1
                        currentState = .stage1
                    },
                    onSecondaryAction: {
                        // Continue to stage 2
                        currentState = .stage2
                    },
                    background: {
                        EmptyView()
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
                        // Retry stage 2
                        currentState = .stage2
                    },
                    onSecondaryAction: {
                        // Void for now - will be implemented later
                        print("Stage 2 completed - Lanjutkan button pressed")
                    },
                    background: {
                        EmptyView()
                    }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentState)
    }
}

#Preview {
    BlockGameStateManager()
}
