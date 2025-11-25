//
//  EmotionStoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct OldEmotionStoryView: View {
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
                    KimoCloseButton(action: { dismiss() })
                    
                    Spacer()
                }
                .padding(.horizontal, 55.getWidth())
                .padding(.top, 44.getHeight())
                
                 HStack(spacing: 39) {
                    KimoImage(image: "KimoTutorialAsset", width: 0.429 * UIScreen.main.bounds.width)
                     
                     VStack(spacing: 0) {
                         Text(NSLocalizedString("EmotionStoryViewDialogueText", comment: ""))
                             .font(.customFont(size: 22, family: .primary, weight: .bold))
                             .fontWeight(.regular)
                             .frame(maxWidth: 500.getWidth())
                             .padding(.horizontal, 49.getWidth())
                             .padding(.vertical, 42.getHeight())
                             .background(ColorToken.corePinkDialogue.toColor())
                             .cornerRadius(30)
                        
                         HStack {
                             KimoImage(image: "KimoDialogue", width: 157.getWidth())
                             Spacer()
                         }
                        
                         HStack {
                             Spacer()
                            
                             NavigationLink(destination: {
                                 StoryView(viewModel: StoryViewModel(story: viewModel.emotion.stories[0]))
                             }, label: {
                                 KimoBubbleButtonPrimary(buttonLabel: NSLocalizedString("StartPlaying", comment: ""))
                             })
                         }
                     }
                 }
                 .padding(.top, 53.getHeight())
                 .padding(.horizontal, 72.getWidth())

                Spacer()
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .onAppear {            
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                accessibilityManager.announceScreenChange("Halaman cerita \(viewModel.emotion.title). Pilih salah satu cerita untuk dimulai.")
            }
            
            AudioManager.shared.stopAll()
        }
    }
}
