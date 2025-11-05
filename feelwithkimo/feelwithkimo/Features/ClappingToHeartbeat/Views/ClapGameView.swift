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
    var onCompletion: (() -> Void)?

    init(onCompletion: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: ClapGameViewModel(onCompletion: onCompletion, accessibilityManager: AccessibilityManager.shared))
    }

    var body: some View {
        VStack {
            headerView()
            
            RoundedContainer {
                ZStack {
                    // MARK: - Content
                    cameraContentView
                    
                    // MARK: - ProgressBar
                    KimoProgressBar(value: viewModel.progress)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.top, 33.getHeight())
                        .padding(.horizontal, 181.getWidth())
                        .animation(.spring(duration: 0.5), value: viewModel.progress)
                    
                    skeletonPairView()
                }
            }
            .padding(.horizontal, 31.getWidth())
        }
        .padding(.horizontal, 65.getWidth())
        .onAppear {
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.announceGameStart()
            }
        }
    }
}

#Preview {
    ClapGameView {
        print("Test")
    }
}
