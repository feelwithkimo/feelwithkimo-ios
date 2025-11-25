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
        VStack(spacing: 0) {
            headerView
            Spacer()
            mainContent
        }
        .background(ColorToken.backgroundHome.toColor())
        .onAppear {
            AudioManager.shared.startBackgroundMusic(assetName: "backsong")
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(
            isPresented: Binding(
                get: { viewModel.navigateToEmotionTarget != nil },
                set: { if !$0 { viewModel.navigateToEmotionTarget = nil } }
            ),
            destination: {
                if let emotion = viewModel.navigateToEmotionTarget {
                    EmotionStoryView(viewModel: EmotionStoryViewModel(emotion: emotion, path: emotion.id))
                }
            }
        )
    }
    
    private var mainContent: some View {
        ZStack {
            ellipseBackground
            emotionSelectionSection
        }
    }

    private var ellipseBackground: some View {
        VStack {
            Spacer()
            KimoEllipseView2(color: ColorToken.ellipseHome.toColor(), height: CGFloat(viewModel.ellipseHeight))
                .offset(y: 360.getHeight())
        }
    }

    private var emotionSelectionSection: some View {
        VStack(alignment: .center, spacing: 40.getHeight()) {
            Text(NSLocalizedString("Choose_Emotion", comment: ""))
                .font(.customFont(size: 80, weight: .bold))
                .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                .kimoTextAccessibility(
                    label: "Hari ini mau belajar emosi apa, ya?",
                    identifier: "home.question",
                    sortPriority: 2
                )

            emotionSelectionView
        }
        .padding(.top, 60.getHeight())
        .padding(.bottom, 174.getHeight())
    }
    
    private func onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let userName = viewModel.currentUser?.name ?? "Teman"
            accessibilityManager.announceScreenChange(
                "Halaman utama aplikasi Kimo. Selamat datang, \(userName). Pilih emosi yang ingin dipelajari hari ini."
            )
        }
    }
}

// MARK: - Child Views
private extension HomeView {
    /// View untuk menampilkan banner header.
    var headerView: some View {
        KimoHeaderView {
            HStack(spacing: 23) {
                Text("Hi, " + "\(viewModel.currentUser?.name ?? "Guest")!")
                    .font(.customFont(size: 34, family: .primary, weight: .bold))
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

    /// View untuk menampilkan daftar emosi yang bisa di-scroll.
    struct CardCenterPreferenceKey: PreferenceKey {
        static var defaultValue: [AnyHashable: CGFloat] = [:]
        static func reduce(value: inout [AnyHashable: CGFloat], nextValue: () -> [AnyHashable: CGFloat]) {
            value.merge(nextValue(), uniquingKeysWith: { $1 })
        }
    }

    var emotionSelectionView: some View {
        GeometryReader { outerGeo in
            let screenCenterX = outerGeo.frame(in: .global).midX

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 50.getWidth()) {
                        Spacer()
                            .frame(width: 250.getWidth())
                        
                        ForEach(viewModel.emotions) { emotion in
                            emotionButton(for: emotion, proxy: proxy)
                        }
                        
                        Spacer()
                            .frame(width: 250.getWidth())
                    }
                    .padding(.horizontal, 148.getWidth())
                }
                .kimoAccessibility(
                    label: "Daftar pilihan emosi",
                    hint: "Geser ke kiri atau kanan untuk melihat pilihan emosi lainnya",
                    traits: .allowsDirectInteraction,
                    identifier: "home.emotionScrollView"
                )
                .onPreferenceChange(CardCenterPreferenceKey.self) { centers in
                    viewModel.updateSelectedEmotion(screenCenterX: screenCenterX, centers: centers)
                }
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

    // MARK: - Separated Button Builder
    @ViewBuilder
    private func emotionButton(for emotion: EmotionModel, proxy: ScrollViewProxy) -> some View {
        Button {
            if viewModel.isEmotionCentered(emotion) {
                viewModel.navigateToEmotion(emotion)
            } else {
                withAnimation {
                    proxy.scrollTo(emotion.id, anchor: .center)
                }
            }
        } label: {
            EmotionCard(
                emotion: emotion,
                isSelected: viewModel.selectedEmotion?.title == emotion.title
            )
            .id(emotion.id)
            .background(
                GeometryReader { geo in
                    Color.clear.preference(
                        key: CardCenterPreferenceKey.self,
                        value: [AnyHashable(emotion.id): geo.frame(in: .global).midX]
                    )
                }
            )
        }
        .kimoCardAccessibility(
            label: "Kartu cerita \(emotion.title) terpilih",
            isSelected: viewModel.selectedEmotion?.title == emotion.title,
            hint: "Ketuk dua kali untuk memilih \(emotion.title) dan mulai belajar",
            identifier: "home.emotionCard.\(emotion.title.lowercased())"
        )
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
