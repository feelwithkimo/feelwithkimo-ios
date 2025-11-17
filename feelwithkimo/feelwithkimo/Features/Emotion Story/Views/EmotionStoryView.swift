//
//  EmotionStoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct EmotionStoryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: EmotionStoryViewModel
    @ObservedObject private var audioManager = AudioManager.shared
    @StateObject private var accessibilityManager = AccessibilityManager.shared
    
    var body: some View {
        HStack(spacing: 37) {
            ZStack {
                VStack(alignment: .center) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }, label: {
                            KimoImage(image: "Back", width: 80.getWidth())
                        })

                        Spacer()
                    }
                    .padding(.top, 35)

                    Spacer().frame(height: 115)

                    Image(viewModel.emotion.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 186, height: 186)
                        .clipShape(Circle())
                        .shadow(radius: 10)

                    VStack(spacing: 16) {
                        Text(viewModel.emotion.title)
                            .font(.customFont(size: 34, family: .primary, weight: .bold))
                            .fontWeight(.bold)
                            .foregroundStyle(ColorToken.textPrimary.toColor())

                        Text(viewModel.emotion.description)
                            .font(.customFont(size: 22, family: .primary, weight: .bold))

                            .foregroundStyle(ColorToken.textSecondary.toColor())
                            .multilineTextAlignment(.center)
                    }
                    .kimoTextGroupAccessibility(
                        combinedLabel: "Emosi \(viewModel.emotion.title). \(viewModel.emotion.description)",
                        identifier: "emotionStory.titleAndDescription"
                    )
                    Spacer()
                }
                .padding(.horizontal, 35)
            }
            .frame(maxWidth: 0.4 * UIScreen.main.bounds.width)
            .background(ColorToken.backgroundMain.toColor())
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    ForEach(Array(viewModel.emotion.stories.enumerated()), id: \.element.id) { index, story in
                        NavigationLink {
                            StoryView(viewModel: StoryViewModel(story: story))
                        } label: {
                            HStack {
                                KimoImage(image: story.thumbnail, width: 150.getWidth())
                                    .cornerRadius(30)

                                VStack(alignment: .leading) {
                                    Text(story.name)
                                        .font(.customFont(size: 22, family: .primary, weight: .bold))
                                        .kimoTextAccessibility(
                                            label: "Judul cerita: \(story.name)",
                                            identifier: "emotionStory.storyName.\(index)"
                                        )

                                    Text(story.description)
                                        .font(.customFont(size: 15, family: .primary, weight: .regular))
                                        .kimoTextAccessibility(
                                            label: "Deskripsi cerita: \(story.description)",
                                            identifier: "emotionStory.storyDescription.\(index)"
                                        )
                                }
                            }
                            .foregroundStyle(ColorToken.additionalColorsBlack.toColor())
                        }
                        .kimoNavigationAccessibility(
                            label: "Cerita \(story.name)",
                            hint: "Ketuk dua kali untuk membuka cerita \(story.name) tentang \(viewModel.emotion.title)",
                            identifier: "emotionStory.storyLink.\(index)"
                        )

                        Divider()
                            .accessibilityHidden(true)
                    }
                }
                .kimoAccessibility(
                    label: "Daftar cerita tentang emosi \(viewModel.emotion.title)",
                    hint: "Geser untuk melihat semua cerita yang tersedia",
                    traits: .allowsDirectInteraction,
                    identifier: "emotionStory.storiesList"
                )
            }
            .frame(maxWidth: 0.6 * UIScreen.main.bounds.width)
            .padding(.top, 115)
            Spacer()
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            AudioManager.shared.startBackgroundMusic(assetName: "backsong")

            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                accessibilityManager.announceScreenChange("Halaman cerita \(viewModel.emotion.title). Pilih salah satu cerita untuk dimulai.")
            }
        }
    }
}
