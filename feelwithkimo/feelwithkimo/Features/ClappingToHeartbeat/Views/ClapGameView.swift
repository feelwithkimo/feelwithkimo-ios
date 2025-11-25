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
                }
                .padding(.horizontal, 31.getWidth())
            }
            .padding(.horizontal, 55.getWidth())

            if viewModel.showCompletionView {
                completionView(skip: viewModel.skip)
                    .padding(.horizontal, 55.getWidth())
            }
            
            if viewModel.showTutorial {
                TutorialPage(textDialogue:
                    "Tantangan Tepuk Tangan! Letakkan perangkat agar kamera bisa melihat kalian berdua." +
                    "Posisikan wajah di dalam area garis putus-putus.  Mulai tepuk tangan bersama!" +
                    "Pastikan tangan kalian terlihat kamera agar progress bar cepat penuh dan permainan selesai!")
                .onTapGesture {
                    viewModel.showTutorial = false
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.announceGameStart()
            }
        }
    }
}
