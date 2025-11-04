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
            interactionLink(
                label: "Ayo Latihan Pernapasan",
                accessibilityId: "story.breathingButton",
                destinationFactory: { BreathingModuleView(onCompletion: $0) },
                onCompletion: viewModel.completeBreathingExercise
            )
            .kimoNavigationAccessibility(
                label: "Ayo Latihan Pernapasan",
                hint: "Ketuk dua kali untuk memulai permainan latihan pernapasan",
                identifier: "story.breathingButton"
            )
            
        case .clapping:
            interactionLink(
                label: "Mulai Bermain",
                accessibilityId: "story.clappingButton",
                systemImage: "hands.clap",
                destinationFactory: { ClapGameView(onCompletion: $0) },
                onCompletion: viewModel.completeClappingExercise
            )
            .kimoNavigationAccessibility(
                label: "Mulai Bermain tepuk tangan",
                hint: "Ketuk dua kali untuk memulai permainan tepuk tangan mengikuti detak jantung",
                identifier: "story.clappingButton"
            )
            
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func interactionLink<Content: View>(
        label: String,
        accessibilityId: String,
        systemImage: String? = nil,
        destinationFactory: @escaping (@escaping () -> Void) -> Content,
        onCompletion: @escaping () -> Void
    ) -> some View {
        VStack {
            NavigationLink(
                destination: InteractionWrapper(onCompletion: {
                    onCompletion()
                    accessibilityManager.announce("Permainan selesai. Melanjutkan cerita.")
                }, viewFactory: destinationFactory)
            ) {
                HStack {
                    if let image = systemImage {
                        Image(systemName: image)
                            .font(.app(.title3, family: .primary))
                            .kimoImageAccessibility(label: "Ikon \(label)", isDecorative: true, identifier: "story.icon")
                    }
                    
                    Text(label)
                        .font(.app(.title3, family: .primary))
                        .fontWeight(.medium)
                }
                .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(ColorToken.corePrimary.toColor())
                .cornerRadius(12)
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)
            
            Spacer()
        }
    }
}
