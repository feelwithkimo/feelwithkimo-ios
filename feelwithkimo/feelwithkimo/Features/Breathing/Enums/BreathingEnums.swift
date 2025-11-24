//
//  BreathTypes.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import Foundation

enum GamePhase {
    case welcome
    case parentTurn
    case childTurn
    case gameComplete
}

enum PlayerType {
    case parent
    case child
    var balloonColor: String {
        switch self {
        case .parent:
            return "red"
        case .child:
            return "blue"
        }
    }
    var kimoImageName: String {
        switch self {
        case .parent:
            return "KimoBreathing-Blowing-Red"
        case .child:
            return "KimoBreathing-Blowing-Blue"
        }
    }
}

/// An enumeration that represents the error conditions that the class emits
enum BreathingClassificationError: Error {
    /// The app encounters an interruption during audio recording
    case audioStreamInterrupted
    /// The app doesn't have permission to access microphone input
    case noMicrophoneAccess
}

enum BreathingPhase: String, CaseIterable {
    case inhale = "Tarik Nafas"
    case hold = "Tahan Nafas"
    case exhale = "Buang Nafas"
    
    var duration: TimeInterval {
        switch self {
        case .inhale:
            return 4
        case .hold:
            return 3
        case .exhale:
            return 4
        }
    }
    
    var imageName: String {
        switch self {
        case .inhale:
            return "Kimo-Inhale"
        case .hold:
            return "Kimo-Hold-Breath"
        case .exhale:
            return "Kimo-Exhale"
        }
    }
    
    // Lazy computed property for scale values
    var scaleValue: CGFloat {
        switch self {
        case .inhale, .hold:
            return 1.5
        case .exhale:
            return 1.0
        }
    }
}
