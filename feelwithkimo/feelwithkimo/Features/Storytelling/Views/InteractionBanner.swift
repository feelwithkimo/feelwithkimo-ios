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
            BridgingPage(textDialogue: viewModel.currentScene.text, storyViewModel: viewModel) {
                BreathingModuleView(onCompletion: viewModel.completeBreathingExercise)
                .kimoNavigationAccessibility(
                    label: "Ayo Latihan Pernapasan",
                    hint: "Ketuk dua kali untuk memulai permainan latihan pernapasan",
                    identifier: "story.breathingButton"
                )
            }
            
        case .clapping:
            BridgingPage(textDialogue: viewModel.currentScene.text, storyViewModel: viewModel) {
                ClapGameView(onCompletion: viewModel.completeClappingExercise, storyViewModel: viewModel)
                .kimoNavigationAccessibility(
                    label: "Mulai Bermain tepuk tangan",
                    hint: "Ketuk dua kali untuk memulai permainan tepuk tangan mengikuti detak jantung",
                    identifier: "story.clappingButton"
                )
            }
            
        case .blockGame:
            let currentPhase = viewModel.currentBlockGamePhase
            BridgingPage(textDialogue: viewModel.currentScene.text, storyViewModel: viewModel) {
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
            
        case .scaffoldingOption:
            ScaffoldingView(storyViewModel: viewModel, accessibilityManager: accessibilityManager)
            
        case .ending:
            switch viewModel.isEnding {
            case true:
                CompletionPageView(
                    title: NSLocalizedString("StoryEnd", comment: ""),
                    primaryButtonLabel: NSLocalizedString("Exit", comment: ""),
                    secondaryButtonLabel: NSLocalizedString("Replay", comment: ""),
                    primaryButtonSymbol: .exitSymbol,
                    secondaryButtonSymbol: .arrowClockwise,
                    onPrimaryAction: {
                        viewModel.exitStory()
                    },
                    onSecondaryAction: {
                        viewModel.replayStory()
                    },
                    imagePath: "KimoSenang"
                )
                .transition(.opacity)
            case false:
                BridgingPage<EmptyView>(textDialogue: viewModel.currentScene.text, storyViewModel: viewModel, action: {
                    viewModel.isEnding = true
                    viewModel.currentScene.path = viewModel.story.storyScene[viewModel.story.storyScene.count - 2].path
                }, isOverlayed: false)
            }
            
        default:
            EmptyView()
        }
    }
}
