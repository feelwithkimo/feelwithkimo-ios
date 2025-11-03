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
    var onCompletion: (() -> Void)?

    init(onCompletion: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: ClapGameViewModel(onCompletion: onCompletion, accessibilityManager: AccessibilityManager.shared))
    }

    var body: some View {
        VStack {
            RoundedContainer {
                ZStack {
                    // MARK: - Content
                    cameraContentView
                    
                    // MARK: - Header
//                    let progress = Double(viewModel.beatCount) / Double(viewModel.totalClap)

                    headerView(progress: viewModel.progress)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.top, 24)
                        .padding(.horizontal, 202)
                }
            }
        }
        .padding(40)
        .background(ColorToken.coreAccent.toColor())
        .onAppear {
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.announceGameStart()
            }
        }
    }
}
