//
//  VisionManager.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 21/10/25.
//

import AVFoundation
import Combine
import Vision

final class VisionManager: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let handPoseRequest = VNDetectHumanHandPoseRequest()

    @Published var user1Hands: (left: CGPoint?, right: CGPoint?) = (nil, nil)
    @Published var user2Hands: (left: CGPoint?, right: CGPoint?) = (nil, nil)

    override init() {
        super.init()
        handPoseRequest.maximumHandCount = 4
        configureCamera()
    }

    // MARK: - Camera Configuration
    private func configureCamera() {
        session.sessionPreset = .high
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input)
        else {
            print("❌ Camera configuration failed")
            return
        }

        session.addInput(input)

        // MARK: - Output Setup
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.alwaysDiscardsLateVideoFrames = true
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))

        guard session.canAddOutput(dataOutput) else {
            print("❌ Failed to add video output")
            return
        }
        session.addOutput(dataOutput)

        if let connection = dataOutput.connection(with: .video) {
            #if compiler(>=5.9)
            // iOS 17+ version
            if connection.isVideoRotationAngleSupported(180) {
                connection.videoRotationAngle = 180
            }
            if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = true
            }
            #else
            // iOS 16 fallback
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = .landscapeRight
            }
            if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = true
            }
            #endif
        }

        DispatchQueue.global(qos: .userInteractive).async {
            self.session.startRunning()
        }
    }
}

extension VisionManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
        try? requestHandler.perform([handPoseRequest])
        guard let results = handPoseRequest.results else { return }

        var leftHands: [CGPoint] = []
        var rightHands: [CGPoint] = []

        for hand in results {
            if let wrist = try? hand.recognizedPoint(.wrist),
               wrist.confidence > 0.6 {
                switch hand.chirality {
                case .left:
                    leftHands.append(CGPoint(x: wrist.location.x, y: wrist.location.y))
                case .right:
                    rightHands.append(CGPoint(x: wrist.location.x, y: wrist.location.y))
                default:
                    break
                }
            }
        }

        // Asumsi: user 1 berada di kiri layar, user 2 di kanan layar
        let leftSorted = leftHands.sorted { $0.x < $1.x }
        let rightSorted = rightHands.sorted { $0.x < $1.x }

        let user1Left = leftSorted.count > 0 ? leftSorted.first : nil
        let user1Right = rightSorted.count > 0 ? rightSorted.first : nil
        let user2Left = leftSorted.count > 1 ? leftSorted.last : nil
        let user2Right = rightSorted.count > 1 ? rightSorted.last : nil

        DispatchQueue.main.async {
            self.user1Hands = (user1Left, user1Right)
            self.user2Hands = (user2Left, user2Right)
        }
    }
}
