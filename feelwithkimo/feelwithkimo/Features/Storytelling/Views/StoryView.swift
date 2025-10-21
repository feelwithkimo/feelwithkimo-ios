//
//  StoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct StoryView: View {
    @StateObject var viewModel: StoryViewModel = StoryViewModel()
    @ObservedObject private var audioManager = AudioManager.shared

    var body: some View {
        ZStack {
            Image(viewModel.story.storyScene[viewModel.index].path)
                .resizable()
                .frame(maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()
                .id(viewModel.index)
                .modifier(FadeContentTransition())
                .animation(.easeInOut(duration: 1.5), value: viewModel.index)
            // Area tombol transparan kiri/kanan
            GeometryReader { geo in
                HStack(spacing: 0) {
                    Button {
                        viewModel.goScene(to: -1)
                    } label: {
                        Color.clear.contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .frame(width: geo.size.width/2, height: geo.size.height)
                    .accessibilityLabel("Previous")

                    Button {
                        viewModel.goScene(to: 1)
                    } label: {
                        Color.clear.contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .frame(width: geo.size.width/2, height: geo.size.height)
                    .accessibilityLabel("Next")
                }
                .ignoresSafeArea()
            }
            // Show breathing button only on scene 13
            if viewModel.index == 13 {
                VStack {
                    Spacer()
                    NavigationLink(destination: BreathingViewWrapper(onCompletion: {
                        viewModel.completeBreathingExercise()
                    })) {
                        HStack {
                            Text("Ayo Latihan Pernapasan")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30)
                }
            }
            // Mute button in top right corner
            VStack {
                HStack {
                    Spacer()
                    MusicMuteButton(audioManager: audioManager)
                        .padding(20)
                        .padding(.top, 10)
                        .padding(.trailing, 20)
                }
                Spacer()
            }
        }
        .onAppear {
            AudioManager.shared.startBackgroundMusic()
        }
        .statusBarHidden(true)
    }
}

// Helper aman akses index
fileprivate extension Array {
    subscript(safe idx: Int) -> Element? { indices.contains(idx) ? self[idx] : nil }
}

/// Modifier fade crossfade
struct FadeContentTransition: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.contentTransition(.opacity)
        } else {
            content.transition(.opacity)
        }
    }
}

/// Wrapper for BreathingView that handles completion callback
struct BreathingViewWrapper: View {
    let onCompletion: () -> Void
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var audioManager = AudioManager.shared
    var body: some View {
        BreathingView(onCompletion: {
            print("🎮 Breathing exercise completed via BreathingView callback")
            onCompletion()
            // Don't manage music here - let the "Lanjut" button handle it
            dismiss()
        })
        .navigationBarHidden(true)
        .onDisappear {
            // Ensure music is properly restored when leaving breathing view (fallback)
            if audioManager.isMuted {
                audioManager.startBackgroundMusic(volume: 1.0)
                print("� Music restored on BreathingViewWrapper disappear (fallback)")
            }
        }
    }
}
