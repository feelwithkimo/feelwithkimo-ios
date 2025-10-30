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
    @Environment(\.dismiss) private var dismiss
    @StateObject private var accessibilityManager = AccessibilityManager.shared
    
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
                .kimoImageAccessibility(
                    label: "Gambar cerita adegan \(viewModel.index + 1)",
                    isDecorative: false,
                    identifier: "story.scene.\(viewModel.index)"
                )
            
            // Area tombol transparan kiri/kanan
            GeometryReader { geo in
                if viewModel.currentScene.question == nil {
                    HStack(spacing: 0) {
                        Button {
                            viewModel.goScene(to: -1, choice: 0)
                            accessibilityManager.announce("Kembali ke adegan sebelumnya")
                        } label: {
                            Color.clear.contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .frame(width: geo.size.width / 2, height: geo.size.height)
                        .kimoButtonAccessibility(
                            label: "Adegan sebelumnya",
                            hint: "Ketuk dua kali untuk kembali ke adegan sebelumnya",
                            identifier: "story.previousButton"
                        )

                        Button {
                            guard !viewModel.currentScene.isEnd else {
                                accessibilityManager.announce("Cerita selesai. Kembali ke halaman sebelumnya.")
                                dismiss()
                                return
                            }
                            viewModel.goScene(to: 1, choice: 0)
                            accessibilityManager.announce("Melanjutkan ke adegan berikutnya")
                        } label: {
                            Color.clear.contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .frame(width: geo.size.width / 2, height: geo.size.height)
                        .kimoButtonAccessibility(
                            label: viewModel.currentScene.isEnd ? "Selesai" : "Adegan berikutnya",
                            hint: viewModel.currentScene.isEnd ? "Ketuk dua kali untuk mengakhiri cerita dan kembali" : "Ketuk dua kali untuk melanjutkan ke adegan berikutnya",
                            identifier: "story.nextButton"
                        )
                    }
                    .ignoresSafeArea()
                } else {
                    ZStack {
                        Color.black.opacity(0.5)
                            .kimoAccessibility(
                                label: "Latar belakang pertanyaan",
                                traits: .isStaticText,
                                identifier: "story.questionBackground"
                            )

                        VStack {
                            if let question = viewModel.currentScene.question {
                                Text(question.question)
                                    .padding()
                                    .frame(maxWidth: 0.5 * UIScreen.main.bounds.width)
                                    .background(ColorToken.backgroundMain.toColor())
                                    .foregroundStyle(ColorToken.textPrimary.toColor())
                                    .cornerRadius(10)
                                    .kimoTextAccessibility(
                                        label: "Pertanyaan: \(question.question)",
                                        identifier: "story.questionText",
                                        sortPriority: 1
                                    )

                                HStack(spacing: 5) {
                                    Spacer()

                                    Text(question.option[0])
                                        .padding()
                                        .frame(width: 0.25 * UIScreen.main.bounds.width)
                                        .background(ColorToken.backgroundCard.toColor())
                                        .foregroundStyle(ColorToken.textPrimary.toColor())
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            viewModel.goScene(to: 1, choice: 0)
                                            accessibilityManager.announce("Memilih: \(question.option[0])")
                                        }
                                        .kimoButtonAccessibility(
                                            label: "Pilihan A: \(question.option[0])",
                                            hint: "Ketuk dua kali untuk memilih jawaban ini",
                                            identifier: "story.optionA"
                                        )

                                    Text(question.option[1])
                                        .padding()
                                        .frame(width: 0.25 * UIScreen.main.bounds.width)
                                        .background(ColorToken.backgroundCard.toColor())
                                        .foregroundStyle(ColorToken.textPrimary.toColor())
                                        .cornerRadius(10)
                                        .frame(width: 0.25 * UIScreen.main.bounds.width)
                                        .onTapGesture {
                                            viewModel.goScene(to: 1, choice: 1)
                                            accessibilityManager.announce("Memilih: \(question.option[1])")
                                        }
                                        .kimoButtonAccessibility(
                                            label: "Pilihan B: \(question.option[1])",
                                            hint: "Ketuk dua kali untuk memilih jawaban ini",
                                            identifier: "story.optionB"
                                        )
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }

            // Switch for case interactions -> Breathing, Clapping, Mimic, and so on.
            switch viewModel.currentScene.interactionType {
            case .breathing:
                VStack {
                    NavigationLink(
                        destination: InteractionWrapper(
                            onCompletion: {
                                viewModel.completeBreathingExercise()
                                accessibilityManager.announce("Latihan pernapasan selesai. Melanjutkan cerita.")
                            },
                            viewFactory: { wrapperCompletion in
                                BreathingView(onCompletion: wrapperCompletion)
                            }
                        )
                    ) {
                        HStack {
                            Text("Ayo Latihan Pernapasan")
                                .font(.app(.title3, family: .primary))
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ColorToken.corePrimary.toColor())
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30)
                    .kimoNavigationAccessibility(
                        label: "Ayo Latihan Pernapasan",
                        hint: "Ketuk dua kali untuk memulai permainan latihan pernapasan",
                        identifier: "story.breathingButton"
                    )
                    
                    Spacer()
                }
                
            case .clapping:
                VStack {
                    NavigationLink(
                        destination: InteractionWrapper(
                            onCompletion: {
                                viewModel.completeClappingExercise()
                                accessibilityManager.announce("Permainan tepuk tangan selesai. Melanjutkan cerita.")
                            },
                            viewFactory: { wrapperCompletion in
                                ClapGameView(onCompletion: wrapperCompletion)
                            }
                        )
                    ) {
                        HStack {
                            Image(systemName: "hands.clap")
                                .font(.app(.title3, family: .primary))
                                .kimoImageAccessibility(
                                    label: "Ikon tepuk tangan",
                                    isDecorative: true,
                                    identifier: "story.clapIcon"
                                )
                            Text("Mulai Bermain")
                                .font(.app(.title3, family: .primary))
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ColorToken.corePrimary.toColor())
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30)
                    .kimoNavigationAccessibility(
                        label: "Mulai Bermain tepuk tangan",
                        hint: "Ketuk dua kali untuk memulai permainan tepuk tangan mengikuti detak jantung",
                        identifier: "story.clappingButton"
                    )
                    Spacer()
                }
                
            default:
                EmptyView()
            }
            
            VStack {
                HStack {
                    KimoMuteButton(audioManager: audioManager)
                        .kimoButtonAccessibility(
                            label: audioManager.isMuted ? "Suara dimatikan" : "Suara dinyalakan",
                            hint: audioManager.isMuted ? "Ketuk dua kali untuk menyalakan suara" : "Ketuk dua kali untuk mematikan suara",
                            identifier: "story.muteButton"
                        )

                    Spacer()
                    
                    Image(systemName: "xmark")
                        .font(.app(.title1))
                        .foregroundColor(.gray)
                        .padding(14)
                        .background(
                            Circle()
                                .fill(Color(white: 0.9))
                        )
                        .onTapGesture {
                            dismiss()
                        }
                }
                .padding(.horizontal, 57 * UIScreen.main.bounds.width / 1194)
                .padding(.top, 50 * UIScreen.main.bounds.height / 834)
                Spacer()
            }
        }
        .onAppear {
            audioManager.startBackgroundMusic()
            
            // Announce story scene information
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                var announcement = "Cerita dimulai. Adegan \(viewModel.index + 1)"
                
                if viewModel.currentScene.question != nil {
                    announcement += ". Ada pertanyaan untuk dijawab."
                } else if viewModel.currentScene.interactionType != .normal {
                    switch viewModel.currentScene.interactionType {
                    case .breathing:
                        announcement += ". Ada permainan pernapasan yang bisa dimainkan."
                    case .clapping:
                        announcement += ". Ada permainan tepuk tangan yang bisa dimainkan."
                    default:
                        break
                    }
                } else {
                    announcement += ". Ketuk sisi kanan untuk melanjutkan, atau sisi kiri untuk kembali."
                }
                
                accessibilityManager.announceScreenChange(announcement)
            }
        }
        .onDisappear {
            audioManager.stop()
        }
        .statusBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.index) {
            // Announce scene changes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                var announcement = "Adegan \(viewModel.index + 1)"
                
                if let question = viewModel.currentScene.question {
                    announcement += ". Pertanyaan: \(question.question)"
                } else if viewModel.currentScene.isEnd {
                    announcement += ". Akhir cerita. Ketuk untuk kembali."
                } else {
                    announcement += " dari cerita."
                }
                
                accessibilityManager.announce(announcement)
            }
        }
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
