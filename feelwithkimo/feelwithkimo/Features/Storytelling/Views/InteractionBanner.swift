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
            BridgingPage(textDialogue: "Ayo Latihan Pernapasan") {
                BreathingModuleView(onCompletion: viewModel.completeBreathingExercise, storyViewModel: viewModel)
                .kimoNavigationAccessibility(
                    label: "Ayo Latihan Pernapasan",
                    hint: "Ketuk dua kali untuk memulai permainan latihan pernapasan",
                    identifier: "story.breathingButton"
                )
            }
            
        case .clapping:
            BridgingPage(textDialogue: "Mulai bermain") {
                ClapGameView(onCompletion: viewModel.completeClappingExercise, storyViewModel: viewModel)
                .kimoNavigationAccessibility(
                    label: "Mulai Bermain tepuk tangan",
                    hint: "Ketuk dua kali untuk memulai permainan tepuk tangan mengikuti detak jantung",
                    identifier: "story.clappingButton"
                )
            }
            
        default:
            EmptyView()
        }
    }
}
