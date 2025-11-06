//
//  HomeViewModel.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 19/10/25.
//

import Combine
import Foundation
import SwiftUI

internal class HomeViewModel: ObservableObject {
    @AppStorage("identity") var identity: String = ""

    // MARK: - Published Properties
    @Published var currentUser: UserModel?
    @Published var emotions: [EmotionModel] = []
    @Published var selectedEmotion: EmotionModel?
    @Published var muted: Bool = false
    @Published var navigateToEmotionTarget: EmotionModel?
    
    let ellipseHeight = 674
    private var cardCenters: [AnyHashable: CGFloat] = [:]
    private var screenCenterX: CGFloat = 0
    
    // MARK: - Lifecycle
    init() {
        fetchData()
    }

    // MARK: - Private Methods

    /// Mengambil semua data yang diperlukan untuk Home View.
    /// Fungsi ini memanggil manager untuk mendapatkan data user dan menyiapkan daftar emosi.
    private func fetchData() {
        self.currentUser = UserModel(id: UUID(), name: identity)

        // Data dummy untuk daftar emosi
        self.emotions = [
            EmotionModel(id: UUID(), name: "Senang", visualCharacterName: "face.smiling", emotionImage: "Carousel-Senang", title: "", description: "", stories: []),
            EmotionModel(id: UUID(), name: "Marah", visualCharacterName: "face.dashed", emotionImage: "Carousel-Marah", title: "Hi, aku marah",
                         description: "Aku gampang kesal kalau sesuatu tidak adil, tapi belajar menarik napas dan bicara baik-baik.", stories: []),
            EmotionModel(id: UUID(), name: "Sedih", visualCharacterName: "sad", emotionImage: "Carousel-Sedih", title: "", description: "", stories: []),
            EmotionModel(id: UUID(), name: "Takut", visualCharacterName: "figure.walk.motion", emotionImage: "Carousel-Takut", title: "", description: "", stories: []),
            EmotionModel(id: UUID(), name: "Jijik", visualCharacterName: "figure.walk.motion", emotionImage: "Carousel-Jijik", title: "", description: "", stories: []),
            EmotionModel(id: UUID(), name: "Terkejut", visualCharacterName: "figure.mind.and.body", emotionImage: "Carousel-Terkejut", title: "", description: "", stories: []),
            EmotionModel(id: UUID(), name: "Capek", visualCharacterName: "figure.mind.and.body", emotionImage: "Carousel-Capek", title: "", description: "", stories: [])
        ]

        self.selectedEmotion = emotions.first(where: { $0.name == "Marah" })
    }

    // MARK: - Public Methods

    /// Mengatur emosi yang dipilih oleh pengguna.
    /// Dipanggil dari View ketika pengguna mengetuk salah satu kartu emosi.
    /// - Parameter emotion: Emosi yang dipilih.
    func selectEmotion(_ emotion: EmotionModel) {
        guard selectedEmotion?.id != emotion.id else { return }
        selectedEmotion = emotion
    }

    /// Update emosi terdekat berdasarkan posisi tengah layar
    func updateSelectedEmotion(screenCenterX: CGFloat, centers: [AnyHashable: CGFloat]) {
        self.screenCenterX = screenCenterX
        self.cardCenters = centers

        guard !centers.isEmpty else { return }

        if let (closestId, _) = centers.min(by: { abs($0.value - screenCenterX) < abs($1.value - screenCenterX) }),
           let matched = emotions.first(where: { AnyHashable($0.id) == closestId }) {
            selectEmotion(matched)
        }
    }

    func isEmotionCentered(_ emotion: EmotionModel) -> Bool {
        guard let cardCenter = cardCenters[AnyHashable(emotion.id)] else { return false }
        let distance = abs(cardCenter - screenCenterX)
        return distance < 20
    }
    
    func navigateToEmotion(_ emotion: EmotionModel) {
        navigateToEmotionTarget = emotion
    }

    /// Scroll ke emosi yang dipilih
    func scrollToSelected(proxy: ScrollViewProxy) {
        guard let selected = selectedEmotion else { return }
        withAnimation {
            proxy.scrollTo(selected.id, anchor: .center)
        }
    }

    /// Pastikan ada emosi awal yang dipilih
    func ensureInitialSelection() {
        if selectedEmotion == nil, !emotions.isEmpty {
            let midIndex = emotions.count / 2
            selectedEmotion = emotions[midIndex]
        }
    }

    /// Buat destination view untuk NavigationLink
    func makeEmotionStoryView(for emotion: EmotionModel) -> some View {
        EmotionStoryView(viewModel: EmotionStoryViewModel(emotion: emotion))
    }
    
    /// Buat lagu di home
    func changeSongSetting() {
        DispatchQueue.main.async {
            if self.muted {
                self.muted = false
                AudioManager.shared.startBackgroundMusic()
            } else {
                self.muted = true
                AudioManager.shared.stopAll()
            }
        }
    }
}
