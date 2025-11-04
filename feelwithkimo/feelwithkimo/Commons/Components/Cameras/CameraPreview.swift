//
//  CameraPreview.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 26/10/25.
//

import AVFoundation
import SwiftUI

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
    override static var layerClass: AnyClass {
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
