//
//  EmotionStoryView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct EmotionStoryView: View {
    @StateObject var viewModel: EmotionStoryViewModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var audioManager = AudioManager.shared
    var body: some View {
        HStack(spacing: 37) {
            ZStack {
                Color.gray

                VStack(alignment: .center) {
                    HStack {
                        Image("Back")
                            .resizable()
                            .frame(maxWidth: 55, maxHeight: 55)

                        Spacer()
                    }
                    .padding(.top, 35)
                    .onTapGesture {
                        // Stop music when navigating back to main menu
                        audioManager.stop()
                        dismiss()
                    }

                    Spacer().frame(height: 115)

                    Image("Anger")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 186, height: 186)
                        .clipShape(Circle())
                        .shadow(radius: 10)

                    Text("Hi, Aku Marah!")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Aku gampang kesal kalau sesuatu tidak adil, tapi belajar menarik napas dan bicara baik-baik.")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(.horizontal, 35)
            }
            .frame(maxWidth: 0.4 * UIScreen.main.bounds.width)

            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    ForEach(viewModel.emotion.stories) { story in
                        NavigationLink {
                            StoryView()
                        } label: {
                            HStack {
                                Image("Thumbnail")

                                VStack(alignment: .leading) {
                                    Text(story.name)
                                        .font(.title2)
                                        .fontWeight(.bold)

                                    Text(story.description)
                                        .font(.body)

                                }
                            }
                            .foregroundStyle(Color.black)
                        }

                        Divider()
                    }
                }
            }
            .frame(maxWidth: 0.6 * UIScreen.main.bounds.width)
            .padding(.top, 115)
            Spacer()
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}
