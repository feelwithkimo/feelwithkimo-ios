//
//  ClapGameView+Extension.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 26/10/25.
//

import SwiftUI

// MARK: - Subviews
extension ClapGameView { 
    func headerView(progress: Double) -> some View {
        VStack {
            HStack {
                Spacer()
                Text("Clap the Hand")
                    .font(.app(.largeTitle, family: .primary))
                    .kimoTextAccessibility(
                        label: "Permainan Tepuk Tangan",
                        identifier: "clapping.title",
                        sortPriority: 1
                    )
                Spacer()
            }
            
            KimoProgressBar(value: progress)
                .animation(.spring(duration: 0.5), value: progress)
        }
    }

    var cameraContentView: some View {
        ZStack {
            CameraPreview(session: viewModel.avSession)
                .kimoAccessibility(
                    label: "Kamera untuk deteksi tangan",
                    hint: "Posisikan kedua tangan di depan kamera untuk bermain",
                    traits: .allowsDirectInteraction,
                    identifier: "clapping.cameraPreview"
                )

//            // Debugging overlays
//            handDebugOverlays
//
//            // Visual feedback
//            clapFeedbackCircle
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
                        Text("No Hands Detected")
                            .font(.app(.headline, family: .primary))
                            .foregroundStyle(ColorToken.grayscale100.toColor())
                    }
                    .transition(.opacity)

                case .oneHand:
                    VStack {
                        Image(systemName: "hand.point.up.left.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.yellow.opacity(0.8))
                            .padding(.bottom, 8)
                        Text("One Hand Detected")
                            .font(.app(.headline, family: .primary))
                            .foregroundStyle(.yellow)
                    }
                    .transition(.opacity)

                case .twoHands:
                    VStack {
                        Image(systemName: "hands.clap.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.green.opacity(0.9))
                            .padding(.bottom, 8)
                        Text("Both Hands Detected")
                            .font(.app(.headline, family: .primary))
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
