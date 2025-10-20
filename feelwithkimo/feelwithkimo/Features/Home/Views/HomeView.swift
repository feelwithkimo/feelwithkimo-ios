//
//  HomeView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 19/10/25.
//

import SwiftUI

struct HomeView: View {

    // MARK: - Properties

    @StateObject private var viewModel = HomeViewModel()

    // MARK: - Body

    var body: some View {
        ZStack {
            // Latar belakang utama
            ColorToken.additionalColorsWhite.toColor().ignoresSafeArea()

            VStack(alignment: .leading) {
                // MARK: - Header Section
                headerView

                Spacer().frame(height: 74)

                // MARK: - Main Content
                VStack(alignment: .center, spacing: 40) {
                    questionView
                    emotionSelectionView
                }
                .padding(.leading, 20)

                Spacer()
            }
//            .background(.red)
//            .padding()
        }
    }

    // MARK: - Child Views

    /// View untuk menampilkan banner header.
    private var headerView: some View {
        HStack(spacing: 23) {
            Image(systemName: "photo.artframe.circle")
                .font(.system(size: 140, weight: .thin))
                .foregroundStyle(ColorToken.grayscale60.toColor())

            Text("Hi, \(viewModel.currentUser?.name ?? "Guest")!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
        }
    }

    /// View untuk menampilkan teks pertanyaan.
    private var questionView: some View {
        HStack(alignment: .top, spacing: 4) {
            Text("Hari ini mau belajar emosi apa, ya?")
                .font(.title)
                .foregroundColor(ColorToken.additionalColorsBlack.toColor())
                .padding(0)

            Image(systemName: "speaker.wave.1.fill")
                .foregroundColor(ColorToken.additionalColorsBlack.toColor())
                .padding(0)
        }
    }

    /// View untuk menampilkan daftar emosi yang bisa di-scroll.
    private var emotionSelectionView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 100) {
                    ForEach(viewModel.emotions) { emotion in
                        EmotionCard(
                            emotion: emotion,
                            isSelected: viewModel.selectedEmotion == emotion
                        )
                        .id(emotion.id)
                        .onTapGesture {
//                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewModel.selectEmotion(emotion)
                                proxy.scrollTo(emotion.id, anchor: .center)
//                            }
                        }
                    }
                }
            }
        }
    }

}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
