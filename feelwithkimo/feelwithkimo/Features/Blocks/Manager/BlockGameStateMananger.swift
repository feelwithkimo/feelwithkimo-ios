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
            switch currentState {
            case .stage1:
                BlocksGameView(level: .level1, onComplete: {
                    currentState = .stage1Completed
                })
                
            case .stage1Completed:
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
                    }
                )
                
            case .stage2:
                BlocksGameView(level: .level2, onComplete: {
                    currentState = .stage2Completed
                })
                
            case .stage2Completed:
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
                    }
                )
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: currentState)
    }
}

#Preview {
    BlockGameStateManager()
}
