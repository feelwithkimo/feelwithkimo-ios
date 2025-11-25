//
//  InteractionBanner.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 02/11/25.
//

import SwiftUI

struct InteractionBanner: View {
    @ObservedObject var viewModel: StoryViewModel
    @ObservedObject var accessibilityManager: AccessibilityManager
    
    var body: some View {
        switch viewModel.currentScene.interactionType {
        case .breathing:
            BridgingPage(textDialogue: NSLocalizedString("BreathingBridgingText", comment: "")) {
                BreathingModuleView(onCompletion: viewModel.completeBreathingExercise)
                .kimoNavigationAccessibility(
                    label: "Ayo Latihan Pernapasan",
                    hint: "Ketuk dua kali untuk memulai permainan latihan pernapasan",
                    identifier: "story.breathingButton"
                )
            }
            
        case .clapping:
            BridgingPage(textDialogue: NSLocalizedString("StartPlaying", comment: "")) {
                ClapGameView(onCompletion: viewModel.completeClappingExercise, storyViewModel: viewModel)
                .kimoNavigationAccessibility(
                    label: "Mulai Bermain tepuk tangan",
                    hint: "Ketuk dua kali untuk memulai permainan tepuk tangan mengikuti detak jantung",
                    identifier: "story.clappingButton"
                )
            }
            
        case .blockGame:
            let currentPhase = viewModel.currentBlockGamePhase
            BridgingPage(textDialogue: viewModel.currentScene.text) {
                BlockGameStageView(
                    phase: currentPhase,
                    onCompletion: {
                        viewModel.completeBlockGamePhase()
                    },
                    storyViewModel: viewModel
                )
                .kimoNavigationAccessibility(
                    label: "Mulai Bermain Membangun Balok",
                    hint: "Tekan dan Geser balok dengan bentuk yang sesuai",
                    identifier: "story.blockButton"
                )
            }
            
        case .scaffolding:
            BridgingPage<EmptyView>(
                textDialogue: viewModel.currentScene.text,
                destination: nil,
                action: {
                    viewModel.goScene(to: 1)
                }
            )
            
        default:
            EmptyView()
        }
    }
}
