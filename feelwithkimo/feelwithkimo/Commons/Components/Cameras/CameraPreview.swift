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
    @Binding var orientation: UIDeviceOrientation

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        let previewLayer = view.videoPreviewLayer
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        guard let connection = uiView.videoPreviewLayer.connection else { return }

        // Ignore invalid orientations
        guard orientation.isLandscape else { return }

        #if compiler(>=5.9)
        // New iOS 17+ API
        if connection.isVideoRotationAngleSupported(0),
           connection.isVideoRotationAngleSupported(180) {
            
            // Kamera landscape tengah vs samping
            let isCameraOnLongSide = isFrontCameraOnLongEdge()
            
            switch orientation {
            case .landscapeLeft:
                connection.videoRotationAngle = isCameraOnLongSide ? 180 : 0

            case .landscapeRight:
                connection.videoRotationAngle = isCameraOnLongSide ? 0 : 180

            default:
                break
            }
        }

        #else
        // Fallback old iOS API
        if connection.isVideoOrientationSupported {
            switch orientation {
            case .landscapeLeft:
                connection.videoOrientation = .landscapeLeft
            case .landscapeRight:
                connection.videoOrientation = .landscapeRight
            default:
                break
            }
        }
        #endif
    }

    /// Detect camera position relative to device orientation (long-edge or short-edge)
    private func isFrontCameraOnLongEdge() -> Bool {
        let model = deviceModelIdentifier()

        guard
            model.hasPrefix("iPad"),
            let commaIndex = model.firstIndex(of: ",")
        else { return false }

        let prefix = String(model[..<commaIndex])

        let numberString = prefix.replacingOccurrences(of: "iPad", with: "")
        guard let number = Int(numberString) else { return false }

        // Hanya 1–14 yang long-edge camera
        return (1...14).contains(number)
    }
    func deviceModelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        return mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
}

extension UIDeviceOrientation {
    var isLandscape: Bool {
        self == .landscapeLeft || self == .landscapeRight
    }
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
