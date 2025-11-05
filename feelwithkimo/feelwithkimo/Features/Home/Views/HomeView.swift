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
    @StateObject private var accessibilityManager = AccessibilityManager.shared

    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - Header Section
            headerView
            
            Spacer()
            
            // MARK: - Main Content
            VStack(alignment: .center, spacing: 40) {
                questionView
                emotionSelectionView
            }
            .padding(.leading, 20)
            .padding(.top, 60)
            
            Spacer()
        }
        .onAppear {
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let userName = viewModel.currentUser?.name ?? "Teman"
                accessibilityManager.announceScreenChange("Halaman utama aplikasi Kimo. Selamat datang, \(userName). Pilih emosi yang ingin dipelajari hari ini.")
            }
            AudioManager.shared.startBackgroundMusic()
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Child Views
private extension HomeView {
    /// View untuk menampilkan banner header.
    var headerView: some View {
        KimoHeaderView {
            HStack(spacing: 23) {
                Text("Hi, \(viewModel.currentUser?.name ?? "Guest")!")
                    .font(.app(.largeTitle, family: .primary))
                    .fontWeight(.bold)
                    .padding()
                    .kimoTextAccessibility(
                        label: "Hai, \(viewModel.currentUser?.name ?? "Teman")!",
                        identifier: "home.greeting",
                        sortPriority: 1
                    )
                
                Spacer()
                
                KimoMuteButton(audioManager: AudioManager.shared)
                    .padding(20)
                    .padding(.top, 10)
                    .padding(.trailing, 20)
                    .kimoButtonAccessibility(
                        label: viewModel.muted ? "Suara dimatikan" : "Suara dinyalakan",
                        hint: viewModel.muted ? "Ketuk dua kali untuk menyalakan suara" : "Ketuk dua kali untuk mematikan suara",
                        identifier: "story.muteButton"
                    )
            }
            .padding(.horizontal, 70.getWidth())
        }
    }

    /// View untuk menampilkan teks pertanyaan.
    var questionView: some View {
        HStack(alignment: .top, spacing: 4) {
            Text("Hari ini mau belajar emosi apa, ya?")
                .font(.app(.title1, family: .primary))
                .foregroundStyle(ColorToken.backgroundMain.toColor())
                .padding(0)
                .kimoTextAccessibility(
                    label: "Hari ini mau belajar emosi apa, ya?",
                    identifier: "home.question",
                    sortPriority: 2
                )

            Image(systemName: "speaker.wave.1.fill")
                .foregroundColor(ColorToken.backgroundMain.toColor())
                .padding(0)
                .kimoImageAccessibility(
                    label: "Ikon suara",
                    isDecorative: true,
                    identifier: "home.speakerIcon"
                )
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
                            .kimoCardAccessibility(
                                label: "Kartu emosi \(emotion.name) terpilih",
                                isSelected: viewModel.selectedEmotion?.name == emotion.name,
                                hint: "Ketuk dua kali untuk memilih emosi \(emotion.name) dan mulai belajar",
                                identifier: "home.emotionCard.\(emotion.name.lowercased())"
                            )
                        }
                    }
                    // optional padding so first/last items can reach exact center if you want:
                    // .padding(.horizontal, outerGeo.size.width / 2 - (approxCardWidth / 2))
                }
                .kimoAccessibility(
                    label: "Daftar pilihan emosi",
                    hint: "Geser ke kiri atau kanan untuk melihat pilihan emosi lainnya",
                    traits: .allowsDirectInteraction,
                    identifier: "home.emotionScrollView"
                )
                // react to updates of all card centers and pick the one nearest to the screen center
                .onPreferenceChange(CardCenterPreferenceKey.self) { centers in
                    viewModel.updateSelectedEmotion(screenCenterX: screenCenterX, centers: centers)
                    
                    // Announce selection change for accessibility
                    if let selectedEmotion = viewModel.selectedEmotion {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            accessibilityManager.announce("Emosi \(selectedEmotion.name) terpilih")
                        }
                    }
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
        .frame(maxHeight: 400)
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
