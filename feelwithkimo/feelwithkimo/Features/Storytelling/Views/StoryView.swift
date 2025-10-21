//
//  StoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct StoryView: View {
    @StateObject var viewModel: StoryViewModel = StoryViewModel()

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

            if viewModel.index == 5 {
                VStack {
                    NavigationLink(
                        destination: ClapGameViewWrapper(onCompletion: {
                        viewModel.completeClappingExercise()
                    })) {
                        HStack {
                            Image(systemName: "hands.clap")
                                .font(.title3)
                            Text("Mulai Bermain")
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
                    Spacer()
                }
            }
            // Show breathing button only on scene 13
            if viewModel.index == 13 {
                VStack {
                    Spacer()
                    NavigationLink(destination: BreathingViewWrapper(onCompletion: {
                        viewModel.completeBreathingExercise()
                    })) {
                        HStack {
                            Image(systemName: "lungs")
                                .font(.title3)
                            Text("Mulai Bermain")
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
        }
        .onAppear { AudioManager.shared.startBackgroundMusic() }
        .onDisappear { AudioManager.shared.stop() }
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

    var body: some View {
        BreathingView(onCompletion: {
            print("🎮 Breathing exercise completed, returning to story...")
            onCompletion()
            dismiss()
        })
    }
}

/// Wrapper for ClapGameView that handles completion callback
struct ClapGameViewWrapper: View {
    let onCompletion: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ClapGameView(onCompletion: {
            onCompletion()
            dismiss()
        })
    }
}
