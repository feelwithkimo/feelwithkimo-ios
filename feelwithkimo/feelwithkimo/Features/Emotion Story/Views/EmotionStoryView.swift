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
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                
                ColorToken.coreSecondary.toColor()
                    .frame(height: 101 * UIScreen.main.bounds.height / 834)
                
                ColorToken.coreSecondaryTwo.toColor()
                    .frame(height: 130 * UIScreen.main.bounds.height / 834)
            }
            
            VStack(alignment: .center, spacing: 0) {
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
                
                HStack(spacing: 39) {
                    Image("KimoEmotionStory")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 512 * UIScreen.main.bounds.width / 1194)
                    
                    VStack(spacing: 0) {
                        Text("Hari ini, Kimo mau bermain dengan teman Kimo, namanya Lala.")
                            .frame(maxWidth: 500 * UIScreen.main.bounds.width / 1194)
                            .padding(.horizontal, 49 * UIScreen.main.bounds.width / 1194)
                            .padding(.vertical, 42.5 * UIScreen.main.bounds.height / 834)
                            .background(ColorToken.corePinkDialogue.toColor())
                            .cornerRadius(30)
                        
                        HStack {
                            Image("KimoDialogue")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 157 * UIScreen.main.bounds.width / 1194)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            
                            NavigationLink(destination: {
                                StoryView()
                            }, label: {
                                Text("Mulai bermain")
                                    .font(.app(.title1, family: .primary))
                                    .frame(maxWidth: 234 * UIScreen.main.bounds.width / 1194)
                                    .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 15.5)
                                    .background(ColorToken.backgroundCard.toColor())
                                    .cornerRadius(30)
                            })
                        }
                    }
                }
                .padding(.top, 53)
                .padding(.horizontal, 72)
                
                Spacer()
            }
            .padding(.horizontal, 35)
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
