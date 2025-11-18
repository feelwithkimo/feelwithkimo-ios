///
///  BlocksGameView.swift
///  feelwithkimo
///
///  Created by Adeline Charlotte Augustinne on 13/11/25.
///

import SwiftUI

struct BlocksGameView: View {
    @StateObject var viewModel: BlocksGameViewModel
    
    let gameCoordinateSpaceName = "blocksGame"
    
    init(level: GameLevel, onComplete: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: BlocksGameViewModel(level: level, onComplete: onComplete))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 18.getHeight()) {
            HStack(spacing: 18.getWidth()) {
                Spacer()
                KimoReplayButton()
                KimoPauseButton()
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
                        }
                        .frame(width: 854.getWidth())
                    }
                    Image("LalaBlocks")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 276.getWidth())
                        .padding(.top, 150.getHeight())
                }
            }
        }
        .padding(.horizontal, 55.getWidth())
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
        .onPreferenceChange(BottomFramePreferenceKey.self) { pref in
            Task { @MainActor in
                viewModel.updateBottomFrames(from: pref)
            }
        }
        .overlay(
            Group {
                if let loc = viewModel.burstLocation {
                    StarBurstView(center: loc)
                }
            }
        )
    }
}

#Preview {
    BlocksGameView(level: .level1)
}
