//
//  BlockBuildingStateMananger.swift
//  feelwithkimo
//
//  Created by Aristo Yongka on 14/11/25.
//

import SwiftUI

struct BlockBuildingStateManager: View {
    @State private var currentState: BlockBuildingEnums = .stage1
    
    var body: some View {
        ZStack {
            switch currentState {
            case .stage1:
                // TODO: Replace with your actual GameStage1View
                GameStage1View(onComplete: {
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
                // TODO: Replace with your actual GameStage2View
                GameStage2View(onComplete: {
                    currentState = .stage2Completed
                })
                
            case .stage2Completed:
                CompletionPageView(
                    title: "Hore Berhasil!!!",
                    primaryButtonLabel: "Main Lagi",
                    secondaryButtonLabel: "Selesai",
                    onPrimaryAction: {
                        // Restart from stage 1
                        currentState = .stage1
                    },
                    onSecondaryAction: {
                        // Exit game or go to home
                        // Handle game completion
                        handleGameCompletion()
                    }
                )
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: currentState)
    }
    
    // MARK: - Helper Methods
    private func handleGameCompletion() {
        // TODO: Implement game completion logic
        // e.g., navigate to home, save progress, show rewards, etc.
        print("Game completed!")
    }
}
