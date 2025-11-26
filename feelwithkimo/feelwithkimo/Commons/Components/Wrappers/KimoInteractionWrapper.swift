//
//  KimoInteractionWrapper.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 26/10/25.
//
import Foundation
import SwiftUI

/// A generic SwiftUI View that wraps an interaction view to handle shared completion and dismissal logic.
struct InteractionWrapper<Content: View>: View {
    
    let onCompletion: () -> Void
    let viewFactory: (@escaping () -> Void) -> Content
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var audioManager = AudioManager.shared
    
    var body: some View {
        viewFactory {
            self.onCompletion()
            self.dismiss()
        }
        .onDisappear {
            if audioManager.isMuted {
                audioManager.startBackgroundMusic(volume: 1.0)
            }
        }
    }
}
