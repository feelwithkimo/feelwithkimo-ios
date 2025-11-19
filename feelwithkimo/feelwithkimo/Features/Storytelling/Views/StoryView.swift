//
//  StoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI
import RiveRuntime

struct StoryView: View {
    @AppStorage("hasSeenTutorial") var seenTutorial = false
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var audioManager = AudioManager.shared
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
                storySceneView()
            } else {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()

                questionView()
            }
            
            if viewModel.currentScene.interactionType != .normal &&
                viewModel.currentScene.interactionType != .storyBranching &&
                viewModel.currentScene.interactionType != .scaffoldingOption {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        KimoImage(image: "xmark", width: 80.getWidth())
                    })
                    
                    Spacer()
                
                    KimoMuteButton(audioManager: audioManager)
                        .kimoButtonAccessibility(
                            label: audioManager.isMuted ? "Suara dimatikan" : "Suara dinyalakan",
                            hint: audioManager.isMuted ? "Ketuk dua kali untuk menyalakan suara" : "Ketuk dua kali untuk mematikan suara",
                            identifier: "story.muteButton"
                        )
                }
                .padding(.horizontal, 55.getWidth())
                .padding(.top, 44.getHeight())
                
                InteractionBanner(viewModel: viewModel, accessibilityManager: accessibilityManager)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
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
            
            audioManager.startBackgroundMusic(assetName: viewModel.story.backsong)
        }
        .statusBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.index) {
            // Announce scene changes
            if viewModel.index == 6 {
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
            
            if viewModel.index == 6 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.currentScene.path = "Scene 6_2"

                        if let sound = viewModel.currentScene.soundEffect {
                            audioManager.playSoundEffect(effectName: sound)
                        }
                    }
                }
            }
            
//            if let sound = viewModel.currentScene.soundEffect  {
//                audioManager.playSoundEffect(effectName: sound)
//            }
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
