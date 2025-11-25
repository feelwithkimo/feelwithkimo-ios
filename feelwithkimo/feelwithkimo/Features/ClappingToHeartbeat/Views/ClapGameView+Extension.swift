//
//  ClapGameView+Extension.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 26/10/25.
//

import SwiftUI

// MARK: - Subviews
extension ClapGameView {
    func headerView() -> some View {
        HStack(spacing: 18.getWidth()) {
            Spacer()
            Spacer()
            
            Text(NSLocalizedString("Clapping_Title", comment: ""))
                .font(.customFont(size: 34, family: .primary, weight: .bold))
                .foregroundStyle(ColorToken.corePrimary.toColor())
                .kimoTextAccessibility(
                    label: "Permainan Tepuk Tangan",
                    identifier: "clapping.title",
                    sortPriority: 1
                )
            
            Spacer()
            
            Button(action: {
                viewModel.toggleShowTutorial()
            }, label: {
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80.getWidth(), height: 80.getHeight())
                    .foregroundStyle(ColorToken.additionalColorsLightPink.toColor())
            })
            
            KimoPauseButton(action: viewModel.onPausePressed)
        }
    }

    var cameraContentView: some View {
        ZStack {
            CameraPreview(session: viewModel.avSession, orientation: $orientation)
                .kimoAccessibility(
                    label: "Kamera untuk deteksi tangan",
                    hint: "Posisikan kedua tangan di depan kamera untuk bermain",
                    traits: .allowsDirectInteraction,
                    identifier: "clapping.cameraPreview"
                )
                .onAppear {
                    orientation = UIDevice.current.orientation
                }
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    orientation = UIDevice.current.orientation
                }

//            // Debugging overlays
//            handDebugOverlays
//
//            // Visual feedback
//            clapFeedbackCircle
        }
    }
    
    @ViewBuilder
    func skeletonPairView() -> some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom, spacing: 40.getHeight()) {
                parentSkeleton
                    .alignmentGuide(.bottom) { dimension in dimension[.bottom] - 38.getWidth() }
                kidSkeleton
            }
            .offset(y: 190.getWidth())
        }
    }
    
    // MARK: - Completion View
    func completionView(skip: Bool) -> some View {
            if skip {
                CompletionPageView(
                    title: NSLocalizedString("ClappingSkip", comment: ""),
                    primaryButtonLabel: NSLocalizedString("Skip", comment: ""),
                    secondaryButtonLabel: NSLocalizedString("Try_Again", comment: ""),
                    primaryButtonSymbol: .chevronRight2,
                    secondaryButtonSymbol: .arrowClockwise,
                    onPrimaryAction: {
                        dismiss()
                        storyViewModel.goScene(to: 1, choice: 0)
                    },
                    onSecondaryAction: {
                        viewModel.restart()
                    }
                )
                .transition(.opacity)
            } else {
                CompletionPageView(
                    title: NSLocalizedString("Completion_Text", comment: ""),
                    primaryButtonLabel: NSLocalizedString("Try_Again", comment: ""),
                    secondaryButtonLabel: NSLocalizedString("Continue", comment: ""),
                    primaryButtonSymbol: .arrowClockwise,
                    secondaryButtonSymbol: .chevronRight,
                    onPrimaryAction: {
                        viewModel.restart()
                    },
                    onSecondaryAction: {
                        dismiss()
                        storyViewModel.goScene(to: 1, choice: 0)
                    }
                )
                .transition(.opacity)
            }
    }
    
    func tutorialContentView() -> some View {
        HStack(alignment: .top) {
            ClappingTutorialStep(
                image: "TutorialClappingFirst",
                stepNumber: "1",
                description: "Dimainkan anak bersama orang tua dengan posisi berada di garis putus-putus"
            )

            ClappingTutorialStep(
                image: "TutorialClappingSecond",
                stepNumber: "2",
                description: "Pastikan tangan terlihat di layar"
            )

            ClappingTutorialStep(
                image: "TutorialClappingThird",
                stepNumber: "3",
                description: "Tepuk tangan sampai progress bar selesai."
            )
        }
    }

    private var parentSkeleton: some View {
        VStack(spacing: 29.getWidth()) {
            DashedCircleView(
                type: .full,
                lineWidth: 5.getHeight(),
                dash: [30.getHeight(), 30.getHeight()],
                strokeColor: ColorToken.additionalColorsWhite.toColor(),
                size: CGSize(width: 266.getHeight(), height: 266.getHeight()),
                clockwise: false
            )
            
            DashedCircleView(
                type: .half(startAngle: .degrees(180)),
                lineWidth: 5.getHeight(),
                dash: [30.getHeight(), 30.getHeight()],
                strokeColor: ColorToken.additionalColorsWhite.toColor(),
                size: CGSize(width: 400.getHeight(), height: 400.getHeight()),
                clockwise: true
            )
        }
    }

    private var kidSkeleton: some View {
        VStack(spacing: 24.getWidth()) {
            DashedCircleView(
                type: .full,
                lineWidth: 5.getHeight(),
                dash: [30.getHeight(), 30.getHeight()],
                strokeColor: ColorToken.additionalColorsWhite.toColor(),
                size: CGSize(width: 222.getHeight(), height: 222.getHeight()),
                clockwise: false
            )
            
            DashedCircleView(
                type: .half(startAngle: .degrees(180)),
                lineWidth: 5.getHeight(),
                dash: [30.getHeight(), 30.getHeight()],
                strokeColor: ColorToken.additionalColorsWhite.toColor(),
                size: CGSize(width: 324.getHeight(), height: 324.getHeight()),
                clockwise: true
            )
        }
    }

    var handDebugOverlays: some View {
        Group {
            // Debug connection line user1
            if let left = viewModel.user1Hands.left,
               let right = viewModel.user1Hands.right {
                HandConnectionDebugView(left: left, right: right, color: .yellow)
                    .accessibilityHidden(true)
            }

            // Debug connection line user2
            if let left = viewModel.user2Hands.left,
               let right = viewModel.user2Hands.right {
                HandConnectionDebugView(left: left, right: right, color: .orange)
                    .accessibilityHidden(true)
            }

            // Debugging State User 1 & 2
            HandStateDebugView(handState: viewModel.user1HandState)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding([.top, .leading], 24)
                .handDetectionAccessibility(handState: viewModel.user1HandState)

            HandStateDebugView(handState: viewModel.user2HandState)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding([.top, .trailing], 24)
                .handDetectionAccessibility(handState: viewModel.user2HandState)
        }
    }

    var clapFeedbackCircle: some View {
        Group {
            if viewModel.showClapFeedback {
                Circle()
                    .fill(viewModel.didClapSuccessfully ? Color.green.opacity(0.6) : Color.red.opacity(0.6))
                    .frame(width: 220, height: 220)
                    .transition(.scale)
                    .animation(.easeOut(duration: 0.25), value: viewModel.showClapFeedback)
                    .clapFeedbackAccessibility(
                        showFeedback: viewModel.showClapFeedback,
                        isSuccessful: viewModel.didClapSuccessfully
                    )
            }
        }
    }
    
    /// View untuk visualisasi garis penghubung dan titik tangan
    struct HandConnectionDebugView: View {
        let left: CGPoint
        let right: CGPoint
        let color: Color

        var body: some View {
            GeometryReader { geo in
                let leftPt = CGPoint(x: left.x * geo.size.width,
                                     y: (1 - left.y) * geo.size.height)
                let rightPt = CGPoint(x: right.x * geo.size.width,
                                      y: (1 - right.y) * geo.size.height)

                Path { path in
                    path.move(to: leftPt)
                    path.addLine(to: rightPt)
                }
                .stroke(color, lineWidth: 3)

                Circle()
                    .fill(color.opacity(0.5))
                    .frame(width: 40, height: 40)
                    .position(leftPt)

                Circle()
                    .fill(color.opacity(0.8))
                    .frame(width: 40, height: 40)
                    .position(rightPt)
            }
        }
    }

    struct HandStateDebugView: View {
        let handState: HandState

        var body: some View {
            VStack {
                switch handState {
                case .noHand:
                    VStack {
                        Image(systemName: "hand.raised.slash")
                            .font(.system(size: 80))
                            .foregroundStyle(ColorToken.grayscale40.toColor())
                            .padding(.bottom, 8)
                            
                        Text(NSLocalizedString("No_Hands_Detected", comment: ""))
                            .font(.customFont(size: 17, family: .primary, weight: .semibold))
                            .foregroundStyle(ColorToken.grayscale100.toColor())
                    }
                    .transition(.opacity)

                case .oneHand:
                    VStack {
                        Image(systemName: "hand.point.up.left.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.yellow.opacity(0.8))
                            .padding(.bottom, 8)
                        Text(NSLocalizedString("One_Hand_Detected", comment: ""))
                            .font(.customFont(size: 17, family: .primary, weight: .semibold))
                            .foregroundStyle(.yellow)
                    }
                    .transition(.opacity)

                case .twoHands:
                    VStack {
                        Image(systemName: "hands.clap.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.green.opacity(0.9))
                            .padding(.bottom, 8)
                        Text(NSLocalizedString("Both_Hands_Detected", comment: ""))
                            .font(.customFont(size: 17, family: .primary, weight: .semibold))
                            .foregroundStyle(.green)
                    }
                    .transition(.opacity)
                }
            }
            .padding()
            .background(ColorToken.backgroundMain.toColor())
            .cornerRadius(16)
            .shadow(radius: 4)
            .animation(.easeInOut(duration: 0.3), value: handState)
        }
    }
}
