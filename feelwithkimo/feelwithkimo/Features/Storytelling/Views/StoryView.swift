//
//  StoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct StoryView: View {
    @AppStorage("hasSeenTutorial") var seenTutorial = false
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var audioManager = AudioManager.shared
    @StateObject var viewModel: StoryViewModel = StoryViewModel()
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
                .animation(.easeInOut(duration: 1), value: viewModel.index)
                .kimoImageAccessibility(
                    label: "Gambar cerita adegan \(viewModel.index + 1)",
                    isDecorative: false,
                    identifier: "story.scene.\(viewModel.index)"
                )
            
            if viewModel.currentScene.question == nil {
                VStack(alignment: .center) {
                    Spacer()
                        .frame(height: 685.getHeight())
                    
                    HStack(spacing: 0) {
                        if viewModel.currentScene.nextScene.count > 1 || viewModel.currentScene.isEnd {
                            Image("PreviousScene")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100.getWidth())
                                .onTapGesture {
                                    viewModel.goScene(to: -1, choice: 0)
                                    accessibilityManager.announce("Kembali ke adegan sebelumnya")
                                }
                                .kimoButtonAccessibility(
                                    label: "Adegan sebelumnya",
                                    hint: "Ketuk dua kali untuk kembali ke adegan sebelumnya",
                                    identifier: "story.previousButton"
                                )
                        } else {
                            Spacer()
                                .frame(width: 100.getWidth())
                        }
                        
                        RoundedRectangle(cornerRadius: 24)
                            .fill(ColorToken.corePinkStory.toColor())
                            .overlay(
                                Text(viewModel.currentScene.text)
                                    .font(.app(.headline, family: .primary))
                                    .foregroundColor(ColorToken.additionalColorsBlack.toColor())
                                    .padding(.horizontal, 45.getWidth())
                                    .padding(.vertical, 32.getHeight())
                                    .multilineTextAlignment(.center)
                                    .kimoTextAccessibility(
                                        label: "Narasi: \(viewModel.currentScene.text)",
                                        identifier: "story.narration.text"
                                    ),
                                alignment: .center
                            )
                            .frame(
                                width: 840.getWidth(),
                                height: 120.getHeight()
                            )
                            .padding(.horizontal, 20.getWidth())
                        
                        // Next Scene Button
                        if viewModel.currentScene.nextScene.count >= 1 && !viewModel.currentScene.isEnd {
                            Image("NextScene")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100.getWidth())
                                .onTapGesture {
                                    guard !viewModel.currentScene.isEnd else {
                                        accessibilityManager.announce("Cerita selesai. Kembali ke halaman sebelumnya.")
                                        dismiss()
                                        return
                                    }
                                    viewModel.goScene(to: 1, choice: 0)
                                    accessibilityManager.announce("Melanjutkan ke adegan berikutnya")
                                }
                                .kimoButtonAccessibility(
                                    label: viewModel.currentScene.isEnd ? "Selesai" : "Adegan berikutnya",
                                    hint: viewModel.currentScene.isEnd ? "Ketuk dua kali untuk mengakhiri cerita dan kembali" :
                                        "Ketuk dua kali untuk melanjutkan ke adegan berikutnya",
                                    identifier: "story.nextButton"
                                )
                        } else if viewModel.currentScene.isEnd {
                            Spacer()
                                .frame(width: 100.getWidth())
                        }
                    }
                    .padding(.bottom, 50.getHeight())
                    .padding(.horizontal, 57.getWidth())
                }
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
                .ignoresSafeArea()
            }
            
            // Add KimoAskView overlay
            KimoAskView()
            
            VStack {
                HStack {
                    Image(systemName: "xmark")
                        .font(.app(.title1))
                        .foregroundColor(ColorToken.additionalColorsBlack.toColor())
                        .padding(14)
                        .background(
                            Circle()
                                .fill(ColorToken.coreSecondary.toColor())
                        )
                        .onTapGesture {
                            dismiss()
                        }
                    
                        Spacer()
                    
                        KimoMuteButton(audioManager: audioManager)
                            .kimoButtonAccessibility(
                                label: audioManager.isMuted ? "Suara dimatikan" : "Suara dinyalakan",
                                hint: audioManager.isMuted ? "Ketuk dua kali untuk menyalakan suara" : "Ketuk dua kali untuk mematikan suara",
                                identifier: "story.muteButton"
                            )
                }
                .padding(.horizontal, 57.getWidth())
                .padding(.top, 50.getHeight())
                .padding(.bottom, 16.getHeight())
                
                InteractionBanner(viewModel: viewModel, accessibilityManager: accessibilityManager)
                
                Spacer()
            }
            
            if !viewModel.hasSeenTutor {
                ColorToken.additionalColorsBlack.toColor().opacity(0.6)
                    .ignoresSafeArea()
                
                switch viewModel.tutorialStep {
                case 1: firstTutorialView()
                case 2: secondTutorialView()
                case 3: thirdTutorialView()
                default: EmptyView()
                }
            }
          
            if viewModel.currentScene.isEnd {
                endSceneOverlay(
                    dismiss: { dismiss() },
                    replay: { viewModel.replayStory() }
                )
            }
        }
        .onAppear {
            // audioManager.startBackgroundMusic()
            
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
    
    private func firstTutorialView() -> some View {
        VStack(alignment: .center) {
            Spacer()
            
            HStack(alignment: .bottom, spacing: 0) {
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Bacakan cerita ini untuk si kecil, ya!")
                        .font(.app(.title3, family: .primary))
                    
                    Text("Gunakan suara dan ekspresi supaya si kecil ikut merasakannya")
                        .font(.app(.title3, family: .primary))
                        .fontWeight(.regular)
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 15)
                .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                .cornerRadius(20)
                
                Image("textDialogueLeft")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 59.getWidth())
                    .padding(.bottom, 10.getHeight())
                    .padding(.trailing, 19)
                
                Image("Kimo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150.getWidth())
                    .padding(.trailing, 79)
            }
            
            Image("Point")
                .resizable()
                .scaledToFit()
                .frame(width: 125.getWidth())
            
            RoundedRectangle(cornerRadius: 24)
                .fill(ColorToken.additionalColorsWhite.toColor())
                .overlay(
                    Text(viewModel.currentScene.text)
                        .font(.app(.headline, family: .primary))
                        .foregroundColor(ColorToken.additionalColorsBlack.toColor())
                        .padding(.horizontal, 24.getWidth())
                        .padding(.vertical, 16.getHeight())
                        .multilineTextAlignment(.center)
                        .kimoTextAccessibility(
                            label: "Narasi: \(viewModel.currentScene.text)",
                            identifier: "story.narration.text"
                        ),
                    alignment: .center
                )
                .frame(
                    width: 840.getWidth(),
                    height: 120.getHeight()
                )
                .padding(.horizontal, 177.getWidth())
                .padding(.top, 11.getHeight())
                .onTapGesture {
                    viewModel.nextTutorial()
                }
        }
        .padding(.bottom, 50.getHeight())
        .ignoresSafeArea()
        .padding(0)
    }
    
    private func secondTutorialView() -> some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                Image("Kimo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150.getWidth())
                    .padding(.top, 51 )
                    .padding(.trailing, 9)
                
                Image("textDialogueRight")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 59.getWidth())
                    .padding(.top, 71.getHeight())
                
                // Text
                VStack(alignment: .leading) {
                    Text("Klik ikon Kimo, ya!")
                        .font(.app(.title3, family: .primary))
                    
                    Text("Kimo akan memberikan petunjuk saat si kecil butuh bantuan")
                        .font(.app(.title3, family: .primary))
                        .fontWeight(.regular)
                }
                .frame(maxWidth: 564)
                .padding(.vertical, 24)
                .padding(.horizontal, 15)
                .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                .cornerRadius(20)
                .padding(.trailing, 18)
                .padding(.top, 71)
                
                Image("Point_2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 125)
                    .padding(.top, 45)
                
                Image("KimoVisual")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130)
                    .padding(.bottom, 71)
                    .onTapGesture {
                        viewModel.nextTutorial()
                    }
            }
            .padding(.bottom, 175.getHeight())
        }
        .padding(.leading, 112.getWidth())
        .padding(.trailing, 33.getWidth())
    }
    
    private func thirdTutorialView() -> some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                Image("Kimo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150.getWidth())
                    .padding(.top, 51.getHeight())
                    .padding(.trailing, 9)
                
                Image("textDialogueRight")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 59.getWidth())
                    .padding(.top, 71.getHeight())
                
                // Text
                Text("dan juga komentar seru untuk menemani si kecil sepanjang cerita!...")
                    .font(.app(.title3, family: .primary))
                    .fontWeight(.regular)
                    .frame(maxWidth: 564)
                    .padding(.vertical, 24)
                    .padding(.horizontal, 15)
                    .background(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255))
                    .cornerRadius(20)
                    .padding(.trailing, 18)
                    .padding(.top, 71)
                
                Image("Point_2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 125)
                    .padding(.top, 45)
                
                Image("KimoVisual_2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130)
                    .padding(.bottom, 71)
                    .onTapGesture {
                        viewModel.nextTutorial()
                        print("test")
                    }
            }
            .padding(.bottom, 175.getHeight())
        }
        .padding(.leading, 112.getWidth())
        .padding(.trailing, 33.getWidth())
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
