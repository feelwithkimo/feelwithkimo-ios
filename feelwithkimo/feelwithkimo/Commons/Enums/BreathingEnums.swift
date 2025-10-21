//
//  BreathTypes.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import Foundation

enum BreathType {
    case inhale
    case exhale
    case none
}

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
