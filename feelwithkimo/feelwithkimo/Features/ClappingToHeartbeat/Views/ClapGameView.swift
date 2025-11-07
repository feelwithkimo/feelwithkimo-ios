//
//  ClapGameView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 21/10/25.
//

import AVFoundation
import Combine
import SwiftUI

struct ClapGameView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ClapGameViewModel
    @ObservedObject var storyViewModel: StoryViewModel
    var onCompletion: (() -> Void)?

    init(onCompletion: @escaping () -> Void, storyViewModel: StoryViewModel) {
        _viewModel = StateObject(wrappedValue: ClapGameViewModel(onCompletion: onCompletion, accessibilityManager: AccessibilityManager.shared))
        _storyViewModel = ObservedObject(wrappedValue: storyViewModel)
    }

    var body: some View {
        ZStack {
            VStack {
                headerView()
                
                ZStack {
                    RoundedContainer {
                        ZStack {
                            // MARK: - Content
                            cameraContentView
                            
                            // MARK: - ProgressBar
                            ClapProgressBarView(value: viewModel.progress)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                .padding(.top, 33.getHeight())
                                .padding(.horizontal, 181.getWidth())
                                .animation(.spring(duration: 0.5), value: viewModel.progress)
                            
                            skeletonPairView()
                        }
                    }
                    
                    KimoAskView(dialogueText: viewModel.dialogueText,
                                mark: .mark,
                                showDialogue: $viewModel.showDialogue,
                                isMascotTapped: $viewModel.isMascotTapped)
                    .offset(x: 80.getHeight())
                }
                .padding(.horizontal, 31.getWidth())
            }
            
            if viewModel.showCompletionView {
                completionView(skip: viewModel.skip)
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding(.horizontal, 65.getHeight())
        .onAppear {
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.announceGameStart()
            }
        }
    }
}
