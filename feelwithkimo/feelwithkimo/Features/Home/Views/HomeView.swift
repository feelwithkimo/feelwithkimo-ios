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

            ScrollView(.vertical, showsIndicators: false) {
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
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Child Views
private extension HomeView {
    /// View untuk menampilkan banner header.
    var headerView: some View {
        KimoHeaderView {
            HStack(spacing: 23) {
                Image(systemName: "photo.artframe.circle")
                    .font(.system(size: 140, weight: .thin))
                    .foregroundStyle(ColorToken.grayscale60.toColor())

                Text("Hi, \(viewModel.currentUser?.name ?? "Guest")!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
            }
        }
    }

    /// View untuk menampilkan teks pertanyaan.
    var questionView: some View {
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
    struct CardCenterPreferenceKey: PreferenceKey {
        static var defaultValue: [AnyHashable: CGFloat] = [:]
        static func reduce(value: inout [AnyHashable: CGFloat], nextValue: () -> [AnyHashable: CGFloat]) {
            value.merge(nextValue(), uniquingKeysWith: { $1 })
        }
    }

    var emotionSelectionView: some View {
        GeometryReader { outerGeo in
            // screen center X in global coordinates
            let screenCenterX = outerGeo.frame(in: .global).midX

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 100) {
                        ForEach(viewModel.emotions) { emotion in
                            NavigationLink(destination: {
                                EmotionStoryView(viewModel: EmotionStoryViewModel(emotion: emotion))
                            }, label: {
                                EmotionCard(
                                    emotion: emotion,
                                    isSelected: viewModel.selectedEmotion?.name == emotion.name
                                )
                                .id(emotion.id)
                                // measure the card's center X and publish it via the preference key
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .preference(
                                                key: CardCenterPreferenceKey.self,
                                                value: [AnyHashable(emotion.id): geo.frame(in: .global).midX]
                                            )
                                    }
                                )
                            })
                        }
                    }
                    // optional padding so first/last items can reach exact center if you want:
                    // .padding(.horizontal, outerGeo.size.width / 2 - (approxCardWidth / 2))
                }
                // react to updates of all card centers and pick the one nearest to the screen center
                .onPreferenceChange(CardCenterPreferenceKey.self) { centers in
                    viewModel.updateSelectedEmotion(screenCenterX: screenCenterX, centers: centers)
                }
                // initial selection + centering: pick middle index if nothing selected yet
                .onAppear {
                    viewModel.ensureInitialSelection()
                    DispatchQueue.main.async {
                        viewModel.scrollToSelected(proxy: proxy)
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
