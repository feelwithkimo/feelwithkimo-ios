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
    // Cukup satu StateObject untuk ViewModel
    @StateObject var viewModel: ClapGameViewModel
    @StateObject private var accessibilityManager = AccessibilityManager.shared

    var onCompletion: (() -> Void)?

    init(onCompletion: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: ClapGameViewModel(onCompletion: onCompletion))
    }

    var body: some View {
        VStack {
            // MARK: - Header
            headerView

            // MARK: - Progress Bar
            ProgressBarView(currentStep: viewModel.beatCount)
                .clappingProgressAccessibility(
                    currentStep: viewModel.beatCount
                )

            // MARK: - Content
            cameraContentView
        }
        .padding(40)
        .onAppear {
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                accessibilityManager.announceScreenChange("Permainan tepuk tangan dimulai. Posisikan kedua tangan di depan kamera dan ikuti irama detak jantung.")
            }
        }
        .onChange(of: viewModel.user1HandState) {
            ClappingAccessibilityManager.announceHandDetection(handState: viewModel.user1HandState)
        }
        .onChange(of: viewModel.isHeartbeatActive) {
            ClappingAccessibilityManager.announceHeartbeatStatus(isActive: viewModel.isHeartbeatActive)
        }
        .onChange(of: viewModel.showClapFeedback) {
            if viewModel.showClapFeedback {
                ClappingAccessibilityManager.announceClapFeedback(isSuccessful: viewModel.didClapSuccessfully)
            }
        }
        .onChange(of: viewModel.beatCount) {
            if viewModel.beatCount > 0 {
                ClappingAccessibilityManager.announceGameProgress(currentStep: viewModel.beatCount)
            }
        }
    }
}
