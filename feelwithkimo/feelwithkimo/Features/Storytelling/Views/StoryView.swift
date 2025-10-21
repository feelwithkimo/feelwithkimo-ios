//
//  StoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct StoryView: View {
    @StateObject var viewModel: StoryViewModel = StoryViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Image(viewModel.currentScene.path)
                .resizable()
                .frame(maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()
                .id(viewModel.index)
                .modifier(FadeContentTransition())
                .animation(.easeInOut(duration: 1.5), value: viewModel.index)

            // Area tombol transparan kiri/kanan
            GeometryReader { geo in
                if viewModel.currentScene.question == nil {
                    HStack(spacing: 0) {
                        Button {
                            viewModel.goScene(to: -1, choice: 0)
                        } label: {
                            Color.clear.contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .frame(width: geo.size.width / 2, height: geo.size.height)
                        .accessibilityLabel("Previous")

                        Button {
                            guard !viewModel.currentScene.isEnd else {
                                dismiss()
                                return
                            }
                            viewModel.goScene(to: 1, choice: 0)
                        } label: {
                            Color.clear.contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .frame(width: geo.size.width / 2, height: geo.size.height)
                        .accessibilityLabel("Next")
                    }
                    .ignoresSafeArea()
                } else {
                    ZStack {
                        Color.black.opacity(0.5)

                        VStack {
                            if let question = viewModel.currentScene.question {
                                Text(question.question)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(10)
                                    .frame(maxWidth: 0.5 * UIScreen.main.bounds.width)

                                HStack(spacing: 5) {
                                    Spacer()

                                    Text(question.option[0])
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(10)
                                        .frame(width: 0.25 * UIScreen.main.bounds.width)
                                        .onTapGesture {
                                            viewModel.goScene(to: 1, choice: 0)
                                        }

                                    Text(question.option[1])
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(10)
                                        .frame(width: 0.25 * UIScreen.main.bounds.width)
                                        .onTapGesture {
                                            viewModel.goScene(to: 1, choice: 1)
                                        }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            
            // Show breathing button only on scene 13
            if viewModel.index == 13 {
                VStack {
                    NavigationLink(destination: BreathingViewWrapper(onCompletion: {
                        viewModel.completeBreathingExercise()
                    })) {
                        HStack {
                            Image(systemName: "lungs")
                                .font(.title3)
                            Text(viewModel.hasCompletedBreathing ? "Lanjut" : "Mulai Bermain")
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
        }
//        .onAppear { AudioManager.shared.startBackgroundMusic() }
//        .onDisappear { AudioManager.shared.stop() }
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
