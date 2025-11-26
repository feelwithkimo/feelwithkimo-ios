//
//  StoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI
import RiveRuntime

struct StoryView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: StoryViewModel
    @StateObject var accessibilityManager = AccessibilityManager.shared
    @State var moveButton = false
    @State private var charPos = CGPoint(x: UIScreen.main.bounds.width * 0.9, y: UIScreen.main.bounds.height * 0.55)

    var body: some View {
        ZStack {
            Image(viewModel.currentScene.path)
                .resizable()
                .frame(maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()
                .id(viewModel.currentScene.path)
                .modifier(FadeContentTransition())
                .kimoImageAccessibility(
                    label: "Gambar cerita adegan \(viewModel.index + 1)",
                    isDecorative: false,
                    identifier: "story.scene.\(viewModel.index)"
                )
            
            if viewModel.currentScene.path == "Scene 6" {
                RiveViewModel(fileName: "JackMove").view()
                    .frame(width: 232.getWidth())
                    .position(charPos)
            }
            
            if viewModel.currentScene.question == nil {
                if viewModel.currentScene.interactionType == .normal {
                    storySceneView()
                }
            }
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    KimoHomeButton(isLarge: false, action: { dismiss() })
            
                    Spacer()
                
                    KimoMuteButton(audioManager: AudioManager.shared)
                        .kimoButtonAccessibility(
                            label: AudioManager.shared.isMuted ? "Suara dimatikan" : "Suara dinyalakan",
                            hint: AudioManager.shared.isMuted ? "Ketuk dua kali untuk menyalakan suara" : "Ketuk dua kali untuk mematikan suara",
                            identifier: "story.muteButton"
                        )
                }
                .padding(.horizontal, 55.getWidth())
                .padding(.top, 44.getHeight())
                                    
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            InteractionBanner(viewModel: viewModel, accessibilityManager: accessibilityManager)
          
            if viewModel.currentScene.isEnd {
                endSceneOverlay(
                    dismiss: { dismiss() },
                    replay: { viewModel.replayStory() },
                    textDialogue: viewModel.currentScene.text
                )
            }
        }
        .onAppear {
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
            
            AudioManager.shared.startBackgroundMusic(assetName: viewModel.story.backsong)
            
            AudioManager.shared.playSoundEffect(effectName: viewModel.currentScene.soundEffect ?? "")
        }
        .statusBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.quitStory) {
            dismiss()
        }
        .onChange(of: viewModel.index) {
            // Announce scene changes
            if viewModel.index == 8 {
                charPos = CGPoint(x: UIScreen.main.bounds.width * 0.9, y: UIScreen.main.bounds.height * 0.55)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    withAnimation(.easeInOut(duration: 2)) {
                        // compute a target using container size, so it's responsive
                        charPos = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.55)
                    }
                }
            }

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
            
            if viewModel.index == 8 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if viewModel.currentScene.path == "Scene 6" {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            viewModel.currentScene.path = "Scene 6_2"
                        }
                        
                        AudioManager.shared.playSoundEffect(effectName: viewModel.currentScene.soundEffect ?? "")
                    }
                }
            } else {
                AudioManager.shared.playSoundEffect(effectName: viewModel.currentScene.soundEffect ?? "")
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
