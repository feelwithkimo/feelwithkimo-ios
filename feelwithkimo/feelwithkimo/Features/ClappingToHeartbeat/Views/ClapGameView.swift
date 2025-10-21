//
//  ClapGameView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 21/10/25.
//

import SwiftUI
import Combine
import AVFoundation

struct ClapGameView: View {
    // Cukup satu StateObject untuk ViewModel
    @StateObject private var viewModel: ClapGameViewModel

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

            // MARK: - Content
            cameraContentView
        }
        .padding(40)
    }

    // MARK: - Subviews
    private var headerView: some View {
        HStack {
            Spacer()
            Text("Clap the Hand")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
    }

    private var cameraContentView: some View {
        RoundedContainer {
            ZStack {
                CameraPreview(session: viewModel.avSession)

                // Debugging overlays
                handDebugOverlays

                // Visual feedback
                if viewModel.showClapFeedback {
                    clapFeedbackCircle
                }

                if viewModel.isHeartbeatActive {
                    HeartbeatView(bpm: 100, isClapping: .constant(viewModel.showClapFeedback)) {
                        viewModel.onHeartbeat()
                    }
                }

                // Buttons
                controlButtons
            }
        }
    }

    private var handDebugOverlays: some View {
        Group {
            // Debug connection line user1
            if let left = viewModel.user1Hands.left,
               let right = viewModel.user1Hands.right {
                HandConnectionDebugView(left: left, right: right, color: .yellow)
            }

            // Debug connection line user2
            if let left = viewModel.user2Hands.left,
               let right = viewModel.user2Hands.right {
                HandConnectionDebugView(left: left, right: right, color: .orange)
            }

            // Debugging State User 1 & 2
            HandStateDebugView(handState: viewModel.user1HandState)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding([.top, .leading], 24)

            HandStateDebugView(handState: viewModel.user2HandState)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding([.top, .trailing], 24)
        }
    }

    private var clapFeedbackCircle: some View {
        Circle()
            .fill(viewModel.didClapSuccessfully ? Color.green.opacity(0.6) : Color.red.opacity(0.6))
            .frame(width: 220, height: 220)
            .transition(.scale)
            .animation(.easeOut(duration: 0.25), value: viewModel.showClapFeedback)
    }

    private var controlButtons: some View {
        VStack {
            Spacer()
            Button("▶️ Start Heartbeat") {
                viewModel.startHeartbeat()
            }
            .disabled(viewModel.isHeartbeatActive)
            .padding(.bottom, 20)

            Button("⏹ Stop") {
                viewModel.stopHeartbeat()
            }
            .disabled(!viewModel.isHeartbeatActive)
            .padding(.bottom, 40)
        }
        .foregroundColor(.white)
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        let previewLayer = view.videoPreviewLayer
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill

        if let connection = previewLayer.connection {
            #if compiler(>=5.9)
            if connection.isVideoRotationAngleSupported(180) {
                connection.videoRotationAngle = 180
            }
            #else
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = .landscapeRight
            }
            #endif
        }

        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {}
}

/// UIView subclass agar layer-nya otomatis menjadi AVCaptureVideoPreviewLayer
final class PreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected AVCaptureVideoPreviewLayer but got \(type(of: layer))")
        }
        return layer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = bounds
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
                        .foregroundColor(.gray.opacity(0.4))
                        .padding(.bottom, 8)
                    Text("No Hands Detected")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .transition(.opacity)

            case .oneHand:
                VStack {
                    Image(systemName: "hand.point.up.left.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.yellow.opacity(0.8))
                        .padding(.bottom, 8)
                    Text("One Hand Detected")
                        .font(.headline)
                        .foregroundColor(.yellow)
                }
                .transition(.opacity)

            case .twoHands:
                VStack {
                    Image(systemName: "hands.clap.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green.opacity(0.9))
                        .padding(.bottom, 8)
                    Text("Both Hands Detected")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                .transition(.opacity)
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
        .shadow(radius: 4)
        .animation(.easeInOut(duration: 0.3), value: handState)
    }
}
