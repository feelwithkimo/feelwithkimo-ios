//
//  EmotionStoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct EmotionStoryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var audioManager = AudioManager.shared
    @StateObject var viewModel: EmotionStoryViewModel
    @StateObject private var accessibilityManager = AccessibilityManager.shared
    @State private var navigateToStory = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                
                ColorToken.coreSecondary.toColor()
                    .frame(height: 101.getHeight())
                
                ColorToken.coreSecondaryTwo.toColor()
                    .frame(height: 130.getHeight())
            }
            
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Image("xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80.getWidth())
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
                
                // TODO: Move this code to KimoDialogueView
                 HStack(spacing: 39) {
                     Image("KimoEmotionStory")
                         .resizable()
                         .scaledToFit()
                         .frame(width: 512.getWidth())
                    
                     VStack(spacing: 0) {
                         Text("Hari ini, Kimo mau bermain dengan teman Kimo, namanya Lala.")
                             .frame(maxWidth: 500.getWidth())
                             .padding(.horizontal, 49.getWidth())
                             .padding(.vertical, 42.getHeight())
                             .background(ColorToken.corePinkDialogue.toColor())
                             .cornerRadius(30)
                        
                         HStack {
                             Image("KimoDialogue")
                                 .resizable()
                                 .scaledToFit()
                                 .frame(maxWidth: 157.getWidth())
                            
                             Spacer()
                         }
                        
                         HStack {
                             Spacer()
                            
                             NavigationLink(destination: {
                                 StoryView()
                             }, label: {
                                 KimoBubbleButton(buttonLabel: "Mulai bermain")
                             })
                         }
                     }
                 }
                 .padding(.top, 53.getHeight())
                 .padding(.horizontal, 72.getWidth())
                
//                KimoDialogueView(
//                    kimoDialogueIcon: "KimoEmotionStory",
//                    textDialogue: "Hari ini, Kimo mau bermain dengan teman Kimo, namanya Lala.",
//                    textDialogueTriangle: "KimoDialogue",
//                    buttonLayout: .single(
//                        KimoDialogueButtonConfig(
//                            title: "Mulai Bermain",
//                            action: {
//                                navigateToStory = true
//                            }
//                        )
//                    )
//                )
//                .padding(.top, 53)
//                .padding(.horizontal, 72)
                
                // navigationDestination with a boolean binding
//                Color.clear
//                    .frame(width: 0, height: 0)
//                    .accessibilityHidden(true)
//                    .navigationDestination(isPresented: $navigateToStory) {
//                        StoryView()
//                    }
                
                Spacer()
            }
            .padding(.horizontal, 35.getWidth())
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .onAppear {            
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                accessibilityManager.announceScreenChange("Halaman cerita emosi \(viewModel.emotion.name). Pilih salah satu cerita untuk dimulai.")
            }
        }
    }
}
