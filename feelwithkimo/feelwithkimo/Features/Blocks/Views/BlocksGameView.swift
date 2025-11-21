///
///  BlocksGameView.swift
///  feelwithkimo
///
///  Created by Adeline Charlotte Augustinne on 13/11/25.
///

import SwiftUI
import RiveRuntime

struct BlocksGameView: View {
    @StateObject var viewModel: BlocksGameViewModel
    // TODO: refactor to environtment model
    @StateObject private var riveViewModel: RiveViewModel
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storyViewModel: StoryViewModel
    
    let gameCoordinateSpaceName = "blocksGame"
    
    init(level: GameLevel, onComplete: (() -> Void)? = nil, storyViewModel: StoryViewModel) {
        let rive = RiveViewModel(fileName: "LalaInBlockGame")

        _riveViewModel = StateObject(wrappedValue: rive)
        _viewModel = StateObject(
            wrappedValue: BlocksGameViewModel(
                level: level,
                onComplete: onComplete,
                riveViewModel: rive
            )
        )

        self.storyViewModel = storyViewModel
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 18.getHeight()) {
                HStack(spacing: 18.getWidth()) {
                    Spacer()
                    
                    KimoReplayButton(action: viewModel.resetGame)
                        .frame(width: 80, height: 80)
                    KimoPauseButton(action: viewModel.onPausePressed)
                }
                
                VStack {
                    ZStack(alignment: .topLeading) {
                        HStack {
                            Spacer()
                            HStack(alignment: .top) {
                                renderShapesBar()
                                    .zIndex(100)
                                
                                Spacer()
                                Divider()
                                    .overlay(
                                        Rectangle()
                                            .stroke(style: StrokeStyle(lineWidth: 4,
                                                                       dash: [25]))
                                            .foregroundColor(ColorToken.backgroundSecondary.toColor())
                                    )
                                    .frame(height: 658.getHeight())
                                Spacer()
                                renderShapesOutline()
                                    .id(viewModel.resetCounter)
                            }
                            .frame(width: 854.getWidth())
                        }
                        
                        riveViewModel.view()
                            .frame(width: 276.getWidth())
                            .padding(.top, 150.getHeight())
                    }
                }
            }
            .padding(.vertical, 44.getHeight())
            .padding(.horizontal, 55.getWidth())
            
            if viewModel.isPaused {
                BlocksGamePauseView(
                    onReset: {
                        viewModel.resetGame()
                        viewModel.onPausePressed()
                    },
                    onHome: {
                        self.storyViewModel.quitStory = true
                        dismiss()
                    },
                    onResume: viewModel.onPausePressed
                )
            }
        }
        .background(
            ZStack {
                ColorToken.emotionSadness.toColor()
                
                Circle()
                    .foregroundStyle(ColorToken.backgroundIdentity.toColor())
                    .frame(width: 651.getWidth(), height: 591.getHeight())
                    .padding(.bottom, 540.getHeight())
                    .padding(.trailing, 636.getWidth())
                    .opacity(0.5)
                
                Circle()
                    .foregroundStyle(ColorToken.backgroundIdentity.toColor())
                    .frame(width: 651.getWidth(), height: 591.getHeight())
                    .padding(.bottom, 711.getHeight())
                    .padding(.leading, 743.getWidth())
                    .opacity(0.5)
                
                Circle()
                    .foregroundStyle(ColorToken.backgroundIdentity.toColor())
                    .frame(width: 651.getWidth(), height: 591.getHeight())
                    .padding(.top, 772.getHeight())
                    .padding(.trailing, 555.getWidth())
                    .opacity(0.5)
                
                Circle()
                    .foregroundStyle(ColorToken.backgroundIdentity.toColor())
                    .frame(width: 500.getWidth(), height: 500.getHeight())
                    .padding(.top, 733.getHeight())
                    .padding(.leading, 751.getWidth())
                    .opacity(0.5)
            })
        .coordinateSpace(name: gameCoordinateSpaceName)
        .ignoresSafeArea(edges: .all)
        .onPreferenceChange(FramePreferenceKey.self) { pref in
            Task { @MainActor in
                viewModel.updateTemplateFrames(from: pref)
            }
        }
        .onPreferenceChange(FramePreferenceKey.self) { pref in
            Task { @MainActor in
                viewModel.updateBottomFrames(from: pref)
            }
        }
        .overlay(
            Group {
                    if viewModel.showIdleOverlay {
                        BlocksGameAnimationView()
                            .transition(.opacity)
                    }

                    if let loc = viewModel.burstLocation {
                        StarBurstView(center: loc)
                    }
                }
        )
        .onReceive(viewModel.idleTimer) { _ in
            viewModel.handleIdleTick()
        }
        .onAppear {
            AudioManager.shared.startBackgroundMusic(assetName: "BlockSong")
            viewModel.startLoop()
        }
        .onDisappear {
            viewModel.stopLoop()
        }
        .navigationBarBackButtonHidden(true)
    }
}
